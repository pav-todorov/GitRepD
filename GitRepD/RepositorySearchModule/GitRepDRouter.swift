//
//  GitRepDRouter.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI

class GitRepDRouter {
    
    func makeGitRepDDetailView(for repository: UserRepositories, model: DataModel) -> some View {
        return RepositoryDetailView(
            presenter: RepositoryDetailPresenter(
                interactor: RepositoryDetailInteractor(
                    model: DataModel(),
                    userRepository: repository)))
    }
}
