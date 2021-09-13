//
//  FavoritesDetailInteractor.swift
//  FavoritesDetailInteractor
//
//  Created by Pavel Todorov on 8.09.21.
//

import SwiftUI
import CoreData

class FavoritesDetailInteractor {
    let model: DataModel
    @Published var singleRepository: SingleRepository?
    
    @FetchRequest(
        entity: Repository.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Repository.id, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Repository>
    
    init(model: DataModel) {
        self.model = model
    }
    
    func fetchRepositoryDetailsFromDB(for id: Int, with context: NSManagedObjectContext) async {
        
        let predicate = NSPredicate(format: "id CONTAINS[cd] %@", String(id))
        
        let request: NSFetchRequest<Repository> = Repository.fetchRequest()
        request.predicate = predicate
        
        if let result = try? context.fetch(request) {
            if (result != []) {
                for result in result {
                    self.singleRepository = SingleRepository(id: Int(result.id),
                                                             name: result.name!,
                                                             created_at: result.dateCreated,
                                                             language: result.languageUsed,
                                                             description: result.repoDescription,
                                                             html_url: result.url,
                                                             owner: SingleRepositoryOwner(avatar_url: result.avatarURL ?? ""))
                }
            }
        }
    }
}
