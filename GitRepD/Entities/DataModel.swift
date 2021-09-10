//
//  DataModel.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import Combine

final class DataModel {
    @Published var userRepositories: [UserRepositories] = []
    @Published var singleRepository: SingleRepository?
}
