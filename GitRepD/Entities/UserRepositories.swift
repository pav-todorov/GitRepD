//
//  UserRepository.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import Foundation

struct UserRepositories: Codable {
    // Repository name
    let name: String
    let owner: Owner
}

struct Owner: Codable {
    // Username
    let login: String
    let avatar_url: String
    
}
