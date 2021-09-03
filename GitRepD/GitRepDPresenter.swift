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
    
    init(interactor: GitRepDInteractor) {
        self.interactor = interactor
    }
}
