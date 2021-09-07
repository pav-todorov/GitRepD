//
//  SingleRepository.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import Foundation

struct SingleRepository: Codable {
    let id: Int
    let name: String?
    //date created
    let created_at: String?
    //language used
    let language: String?
    //description
    let description: String?
    //link to it
    let url: String?
    
//    let parent: SingleRepositoryOwner
}

//struct SingleRepositoryOwner: Codable {
//    let avatar_url: String
//}
