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
    @Published var errorMessage: String = ""
    
    init(interactor: GitRepDInteractor) {
        self.interactor = interactor
        
        interactor.model.$userRepositories
            .assign(to: \.userRepositories, on: self)
            .store(in: &cancellables)
    }
    
    func fetchUserRepositories(for user: String, _ page: Int) async {
        await interactor.loadRepositories(for: user, page)
    }
    
    func clearArrayOfRepositories() {
        interactor.clearArrayOfRepositories()
    }
    
    func linkBuilder<Content: View>(for repository: UserRepositories, @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(destination: router.makeGitRepDDetailView(for: repository, model: interactor.model)) {
            content()
        }
    }
}
