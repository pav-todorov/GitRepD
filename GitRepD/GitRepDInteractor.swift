//
//  GitRepDInteractor.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI

class GitRepDInteractor {
    let model: DataModel
    
    init(model: DataModel) {
        self.model = model
    }

    func loadRepositories() {
        guard let url = URL(string: userRepositories) else {
            print("Invalid URL")
        
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let decodedResponse: [UserRepositories] = try? JSONDecoder().decode([UserRepositories].self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
//                        self.results = decodedResponse.results
                    }
                    
                    for index in decodedResponse {
                        DispatchQueue.main.async {
                            self.model.userRepositories.append(index)
                        }
                        
                        print("Repo: \(index.name)\n\(index.owner)\n\(index.owner.avatar_url)\n\(index.owner.login)")
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")

            
        }.resume()

        
    }
    
}
