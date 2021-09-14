//
//  RepositoryDetailInteractor.swift
//  RepositoryDetailInteractor
//
//  Created by Pavel on 6.09.21.
//

import SwiftUI
import Combine
import CoreData


class RepositoryDetailInteractor: ObservableObject {
    @Published var isRepositoryInDatabase: Bool = false
    
    /// If there is a connection error --> this will be the message
    @Published var errorMessage: String = ""
    /// If there is a connection error --> this will trigger the appearance of the alert message
    @Published var showingAlert = false
    
    let model: DataModel
    private let repository: UserRepositories
        
    init(model: DataModel, userRepository: UserRepositories) {
        self.model = model
        self.repository = userRepository
    }
    
    func getSingleRepository(with context: NSManagedObjectContext) async {
        
        guard let url = URL(string: "https://api.github.com/repos/\(self.repository.owner.login)/\(repository.name)") else {
            print("Invalid URL")
            
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let decodedResponse: SingleRepository = try? JSONDecoder().decode(SingleRepository.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async { [self] in
                        self.model.singleRepository = decodedResponse
                        Task {
                            await isInDatabase(for: context)
                        }
                    }
                    return
                }
            }
            
            // if we're still here it means there was a problem
            DispatchQueue.main.async {
            self.errorMessage = "Fetch failed: \(error?.localizedDescription ?? "Unknown error")"
            self.showingAlert.toggle()
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
            
        }.resume()
        
    }
    
    /// This method adds a single repository item to the CoreData database.
    func addItem(for context: NSManagedObjectContext) {
        withAnimation {
            
            if let singleRepo = self.model.singleRepository {
            
            let newItem = Repository(context: context)
            
            newItem.id = Int32(singleRepo.id)
            newItem.timestamp = Date()
            newItem.name = singleRepo.name
            newItem.languageUsed = singleRepo.language
            newItem.repoDescription = singleRepo.description
            newItem.dateCreated = singleRepo.created_at
            newItem.url = singleRepo.html_url
            newItem.repoId = Int32(singleRepo.id)
            newItem.avatarURL = singleRepo.owner.avatar_url
            
            self.isRepositoryInDatabase = true
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                
                DispatchQueue.main.async {
                self.errorMessage = "\(nsError.userInfo).\nPlease, restart the app and try again."
                self.showingAlert.toggle()
                }
            }
            }
        }
    }
    
    /// This function checks if a single repository with particular id has been saved to the CoreData database.
    @MainActor
    func isInDatabase(for context: NSManagedObjectContext) async -> Bool  {
        
        if let singleRepo = self.model.singleRepository {
            let predicate = NSPredicate(format: "id CONTAINS[cd] %@", String(singleRepo.id))
            
            let request: NSFetchRequest<Repository> = Repository.fetchRequest()
            request.predicate = predicate
            
            if let result = try? context.fetch(request) {
                if (result != []) {
                    isRepositoryInDatabase = true
                } else {
                    isRepositoryInDatabase = false
                }
            }
        }
        return isRepositoryInDatabase
    }
    
    /// This method removes a single repository from the CoreData database.
    func removeItemFromDatabase(for context: NSManagedObjectContext) {
        self.isRepositoryInDatabase = false
        let request: NSFetchRequest<Repository> = Repository.fetchRequest()
        let predicate = NSPredicate(format: "id CONTAINS[cd] %@", String(self.model.singleRepository!.id))
        request.predicate = predicate
        
        if let result = try? context.fetch(request) {
            for object in result {
                context.delete(object)
            }
        }
        
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            
            DispatchQueue.main.async {
            self.errorMessage = "\(nsError.userInfo).\nPlease, restart the app and try again."
            self.showingAlert.toggle()
            }
        }
    }
}
