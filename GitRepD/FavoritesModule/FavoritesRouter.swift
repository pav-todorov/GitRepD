//
//  FavoritesRouter.swift
//  FavoritesRouter
//
//  Created by Pavel Todorov on 7.09.21.
//

import SwiftUI

class FavoritesRouter {
    
    func makeFavoritesDetailView(for repositoryId: Int) -> some View {
        
        return FavoritesDetailView(presenter: FavoritesDetailPresenter(interactor: FavoritesDetailInteractor(model: DataModel()), repository: repositoryId))
        
        
//        RepositoryDetailView(presenter: RepositoryDetailPresenter(interactor: RepositoryDetailInteractor(model: DataModel(), userRepository: dummyUserRepo)))
    }
}
