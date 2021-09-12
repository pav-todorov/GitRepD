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
    @Published var isRepositoryInDatabase: Bool = false
    /// If there is a connection error --> this will be the message
    @Published var errorMessage: String = ""
    /// If there is a connection error --> this will trigger the appearance of the alert message
    @Published var showingAlert = false
    
    init(interactor: RepositoryDetailInteractor) {
        self.interactor = interactor
        self.router = nil
        
        self.interactor.model.$singleRepository
            .assign(to: \.singleRepository, on: self)
            .store(in: &cancellables)
        
        self.interactor.$isRepositoryInDatabase
            .assign(to: \.isRepositoryInDatabase, on: self)
            .store(in: &cancellables)
        
        self.interactor.$errorMessage
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
        
        self.interactor.$showingAlert
            .assign(to: \.showingAlert, on: self)
            .store(in: &cancellables)
    }
    
    func getselectedRepository(with context: NSManagedObjectContext) async {
        await interactor.getSingleRepository(with: context )
    }
    
    func addItemToDatabase(for context: NSManagedObjectContext) {
        self.interactor.addItem(for: context)
    }
    
    func isInDatabase(for context: NSManagedObjectContext) async -> Bool {
        return await self.interactor.isInDatabase(for: context)
    }
    
    func removeItemFromDatabase(for context: NSManagedObjectContext){
        self.interactor.removeItemFromDatabase(for: context)
    }
}
