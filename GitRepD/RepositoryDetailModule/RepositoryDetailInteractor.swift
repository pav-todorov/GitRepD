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
    
    
    let model: DataModel
    private let repository: UserRepositories
    
    private var cancellables = Set<AnyCancellable>()
    
    init(model: DataModel, userRepository: UserRepositories) {
        self.model = model
        self.repository = userRepository
    }
    
    func getSingleRepository() {
        
        print("https://api.github.com/repos/\(self.repository.owner.login)/\(repository.name)")
             
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
                                }
        
                            print("Single repo: \(decodedResponse.created_at) \n \(decodedResponse.language)")
                            
        
                            // everything is good, so we can exit
                            return
                        }
                    }
        
                    // if we're still here it means there was a problem
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        
        
                }.resume()
        
    }
    
    func addItem(for context: NSManagedObjectContext) {
        withAnimation {
            let newItem = Repository(context: context)
            if let singleRepo = self.model.singleRepository {
                newItem.id = Int32(singleRepo.id)
                newItem.timestamp = Date()
                newItem.name = self.model.singleRepository!.name
            }
//            newItem.repoId = model.singleRepository.id
  
//            newItem.dateCreated = self.model.singleRepository!.created_at
//            newItem.languageUsed = model.singleRepository!.language
////            newItem.description = self.model.singleRepository?.description
//            newItem.url = self.model.singleRepository!.url
            
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
}
