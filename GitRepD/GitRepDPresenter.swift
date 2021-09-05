//
//  GitRepDPresenter.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI
import Combine

class GitRepDPresenter: ObservableObject {
    private let interactor: GitRepDInteractor
    private let router = GitRepDRouter()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userRepositories: [UserRepositories] = []
    
    init(interactor: GitRepDInteractor) {
        self.interactor = interactor
        
        interactor.model.$userRepositories
            .assign(to: \.userRepositories, on: self)
            .store(in: &cancellables)
    }
    
    func fetchUserRepositories(for user: String) {
        interactor.loadRepositories(for: user)
    }
    
    func clearArrayOfRepositories() {
        interactor.clearArrayOfRepositories()
    }
}
