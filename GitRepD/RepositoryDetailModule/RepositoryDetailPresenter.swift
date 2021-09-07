//
//  RepositoryDetailPresenter.swift
//  RepositoryDetailPresenter
//
//  Created by Pavel on 6.09.21.
//

import SwiftUI
import Combine
import CoreData

class RepositoryDetailPresenter: ObservableObject {

    
    private let interactor: RepositoryDetailInteractor
    private let router: RepositoryDetailRouter?
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var singleRepository: SingleRepository?
    
    init(interactor: RepositoryDetailInteractor) {
        self.interactor = interactor
        self.router = nil
        
        self.interactor.model.$singleRepository
            .assign(to: \.singleRepository, on: self)
            .store(in: &cancellables)
    }
    
    func getselectedRepository() {
        interactor.getSingleRepository()
    }
    
    func addItemToDatabase(for context: NSManagedObjectContext) {
        self.interactor.addItem(for: context)
    }
}
