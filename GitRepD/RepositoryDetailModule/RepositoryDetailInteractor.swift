//
//  RepositoryDetailInteractor.swift
//  RepositoryDetailInteractor
//
//  Created by Pavel on 6.09.21.
//

import SwiftUI
import Combine
import CoreData


class RepositoryDetailInteractor {
    @Published var isRepositoryInDatabase: Bool = false
    @FetchRequest(
        //        entity: Repository.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Repository.name, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Repository>
    
    let model: DataModel
    private let repository: UserRepositories
    
    private var cancellables = Set<AnyCancellable>()
    
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
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
            
        }.resume()
        
    }
    
    /// This method adds a single repository item to the CoreData database.
    func addItem(for context: NSManagedObjectContext) {
        withAnimation {
            let newItem = Repository(context: context)
            
            newItem.id = Int32(self.model.singleRepository!.id)
            newItem.timestamp = Date()
            newItem.name = self.model.singleRepository!.name
            newItem.languageUsed = self.model.singleRepository?.language
            newItem.repoDescription = self.model.singleRepository?.description
            newItem.dateCreated = self.model.singleRepository?.created_at
            newItem.url = self.model.singleRepository?.html_url
            newItem.repoId = Int32(self.model.singleRepository?.id ?? 0)
            newItem.avatarURL = model.singleRepository?.owner.avatar_url
            
            self.isRepositoryInDatabase = true
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
//                    self.model.singleRepository = SingleRepository(id: Int(result.first!.id),
//                                                                   name: result.first?.name,
//                                                                   created_at: result.first?.dateCreated,
//                                                                   language: result.first?.languageUsed,
//                                                                   description: result.first?.repoDescription,
//                                                                   html_url: result.first?.url, owner: SingleRepositoryOwner(avatar_url: result.first?.avatarURL ?? ""))
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
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
