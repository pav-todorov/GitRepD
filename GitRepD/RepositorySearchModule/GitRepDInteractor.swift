//
//  GitRepDInteractor.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI

class GitRepDInteractor {
    let model: DataModel
    var pageNumber = 1
    
    @Published var message: String = ""
    
    init(model: DataModel) {
        self.model = model
    }
    
    func loadRepositories(for userName: String, _ page: Int) async {
        guard let url = URL(string: "https://api.github.com/users/\(userName)/repos?per_page=10&page=\(page)") else {
            print("Invalid URL")
            return
        }
                let request = URLRequest(url: url)
        
                URLSession.shared.dataTask(with: request) { data, response, error in
        
                    if let data = data {
                        if let decodedResponse: [UserRepositories] = try? JSONDecoder().decode([UserRepositories].self, from: data) {
                            
                            // we have good data – go back to the main thread
                            for index in decodedResponse {
                                
                                DispatchQueue.main.async { [self] in
                                    self.model.userRepositories.append(index)
                                }
                            }
        
                            // everything is good, so we can exit
                            return
                        }
                    }
        
                    // if we're still here it means there was a problem
//                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                    self.message = "\(error!.localizedDescription)"
        
                }.resume()
        
        
    }
    
    func getMoreRepositories(for userName: String, _ page: Int) async {
        self.pageNumber += 1
        Task {
            await loadRepositories(for: userName, page)
        }
    }
    
    func clearArrayOfRepositories() {
        self.model.userRepositories.removeAll()
    }
    
}
