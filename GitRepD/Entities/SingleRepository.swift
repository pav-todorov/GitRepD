//
//  SingleRepository.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import Foundation

struct SingleRepository: Codable {
    //date created
    let createdAt: String
    //language used
    let language: String
    //description
    let description: String
    //link to it
    let url: String
}
