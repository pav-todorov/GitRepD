//
//  DataModel.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import Combine

final class DataModel {
//    private let persistence = PersistenceController()

    @Published var userRepositories: [UserRepositories] = []
}
