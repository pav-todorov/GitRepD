//
//  GitRepDPresenter.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI
import Combine
import CoreData

class GitRepDPresenter: ObservableObject {
    private let interactor: GitRepDInteractor
    private let router = GitRepDRouter()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userRepositories: [UserRepositories] = []
    @Published var errorMessage: String = ""
    @Published var showingAlert = false
    @Published var isRepositoryInDatabase: Bool = false
    
    init(interactor: GitRepDInteractor) {
        self.interactor = interactor
        
        interactor.model.$userRepositories
            .assign(to: \.userRepositories, on: self)
            .store(in: &cancellables)
        
        interactor.$showingAlert
            .assign(to: \.showingAlert, on: self)
            .store(in: &cancellables)
        
        interactor.$errorMessage
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
        
        interactor.$isRepositoryInDatabase
            .assign(to: \.isRepositoryInDatabase, on: self)
            .store(in: &cancellables)
        
    }
    
    func fetchUserRepositories(for user: String, _ page: Int) async {
        await interactor.loadRepositories(for: user, page)
    }
    
    func clearArrayOfRepositories() {
        interactor.clearArrayOfRepositories()
    }
    
    func linkBuilder<Content: View>(for repository: UserRepositories, @ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.makeGitRepDDetailView(for: repository, model: interactor.model)) {
            content()
        }
    }
    
    @MainActor func isInDatabase(for context: NSManagedObjectContext, and id: Int)  -> Bool {
         interactor.isInDatabase(for: context, and: id)
    }
    
    func getAndSaveSingleRepository(with url: String, for context: NSManagedObjectContext) async  {
        await self.interactor.getAndSaveSingleRepository(with: url, for: context)
    }
    
    func removeItemFromDatabase(for context: NSManagedObjectContext, and id: Int) {
        self.interactor.removeItemFromDatabase(for: context, and: id)
    }
}
