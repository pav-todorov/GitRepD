//
//  FavoritesPresenter.swift
//  FavoritesPresenter
//
//  Created by Pavel Todorov on 7.09.21.
//

import SwiftUI
import Combine

struct FavoritesPresenter {
    private let interactor: FavoritesInteractor
    private let router = FavoritesRouter()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: FavoritesInteractor) {
        self.interactor = interactor
    }
    
    func linkBuilder<Content: View>(for repositoryId: Int, @ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.makeFavoritesDetailView(for: repositoryId)) {
            content()
        }
    }
}
