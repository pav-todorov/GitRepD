//
//  FavoritesDetailPresenter.swift
//  FavoritesDetailPresenter
//
//  Created by Pavel Todorov on 8.09.21.
//

import SwiftUI
import Combine
import CoreData

class FavoritesDetailPresenter: ObservableObject {
    private let repositoryId:Int!
    private let interactor: FavoritesDetailInteractor
    private let router = FavoritesDetailRouter()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var singleRepository: SingleRepository?
    @Published var name: String?
    init(interactor: FavoritesDetailInteractor, repository id: Int){
        self.repositoryId = id
        self.interactor = interactor
        interactor.$singleRepository
            .assign(to: \.singleRepository, on: self)
            .store(in: &cancellables)
        
    }
    
    func fetchRepository(with context: NSManagedObjectContext) async {
        await interactor.fetchRepositoryDetailsFromDB(for: repositoryId, with: context)
    }
    
}

