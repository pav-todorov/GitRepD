//
//  GitRepDInteractor.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI
import CoreData
import Combine

class GitRepDInteractor: ObservableObject {
    let model: DataModel
    var pageNumber = 1
    
    @Published var isRepositoryInDatabase: Bool = false
    
    /// If there is a connection error --> this will be the message
    @Published var errorMessage: String = ""
    /// If there is a connection error --> this will trigger the appearance of the alert message
    @Published var showingAlert = false
    
    init(model: DataModel) {
        self.model = model
    }
    
    /// This method loads all repositories for a single GitHub user
    func loadRepositories(for userName: String, _ page: Int) async {
        guard let url = URL(string: "https://api.github.com/users/\(userName)/repos?per_page=10&page=\(page)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let decodedResponse: [UserRepositories] = try? JSONDecoder().decode([UserRepositories].self, from: data) {
                    
                    // we have good data – go back to the main thread
                    for index in decodedResponse {
                        
                        DispatchQueue.main.async { [self] in
                            self.model.userRepositories.append(index)
                        }
                    }
                    
                    // everything is good, so we can exit
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.errorMessage = "\(error?.localizedDescription ?? "Oops...\nAPI rate limit exceeded. \nPlease, try again in an hour.")"
                self.showingAlert = true
            }
        }.resume()
    }
    
    func getMoreRepositories(for userName: String, _ page: Int) async {
        self.pageNumber += 1
        Task {
            await loadRepositories(for: userName, page)
        }
    }
    
    func clearArrayOfRepositories() {
        self.model.userRepositories.removeAll()
    }
    
    /// This function checks if a single repository with particular id has been saved to the CoreData database.
    func isInDatabase(for context: NSManagedObjectContext, and id: Int) -> Bool {
        var isRepositoryInDatabase = false
        let predicate = NSPredicate(format: "id == %@", String(id))
        
        let request: NSFetchRequest<Repository> = Repository.fetchRequest()
        request.predicate = predicate
        
        if let result = try? context.fetch(request) {
            if (result != []) {
                isRepositoryInDatabase = true
            } else {
                isRepositoryInDatabase = false
            }
        }
        return isRepositoryInDatabase
    }
    
    func getAndSaveSingleRepository(with url: String, for context: NSManagedObjectContext) async {
        
        guard let url = URL(string: url) else {
            fatalError("wrong url")
        }
        
        print("GitRepDInteractor url: \(url)")
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let decodedResponse: SingleRepository = try? JSONDecoder().decode(SingleRepository.self, from: data) {
                    // we have good data – go back to the main thread
                    Task {
                        await self.addItem(for: context, with: decodedResponse)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                // if we're still here it means there was a problem
                self.errorMessage = "\(error?.localizedDescription ?? "Unknown error")."
                self.showingAlert.toggle()
            }

        }.resume()
    }
    
    func addItem(for context: NSManagedObjectContext, with repository: SingleRepository) async {
        
            let newItem = Repository(context: context)
            
            newItem.id = Int32(repository.id)
            newItem.timestamp = Date()
            newItem.name = repository.name
            newItem.languageUsed = repository.language
            newItem.repoDescription = repository.description
            newItem.dateCreated = repository.created_at
            newItem.url = repository.html_url
            newItem.repoId = Int32(repository.id)
            newItem.avatarURL = repository.owner.avatar_url
            
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                
                self.errorMessage = "\(nsError.userInfo).\nPlease, restart the app and try again."
                self.showingAlert.toggle()
                return
            }
  
    }
    
    /// This method removes a single repository from the CoreData database.
    func removeItemFromDatabase(for context: NSManagedObjectContext, and id: Int) {
        let request: NSFetchRequest<Repository> = Repository.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", String(id))
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
            
            self.errorMessage = "\(nsError.userInfo).\nPlease, restart the app and try again."
            self.showingAlert.toggle()
            return
        }
    }
    
}
