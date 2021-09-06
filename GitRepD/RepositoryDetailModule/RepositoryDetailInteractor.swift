//
//  RepositoryDetailInteractor.swift
//  RepositoryDetailInteractor
//
//  Created by Pavel on 6.09.21.
//

import Foundation
import Combine

class RepositoryDetailInteractor {
    let model: DataModel
    private let repository: UserRepositories
    
    private var cancellables = Set<AnyCancellable>()
    
    init(model: DataModel, userRepository: UserRepositories) {
        self.model = model
        self.repository = userRepository
    }
    
    func getSingleRepository() {
        
        print("https://api.github.com/repos/\(self.repository.owner.login)/\(repository.name)")
             
        guard let url = URL(string: "https://api.github.com/repos/\(self.repository.owner.login)/\(repository.name)") else {
            print("Invalid URL")
            
            return
        }
        
                let request = URLRequest(url: url)
        
                URLSession.shared.dataTask(with: request) { data, response, error in
        
                    if let data = data {
                        if let decodedResponse: SingleRepository = try? JSONDecoder().decode(SingleRepository.self, from: data) {
                            // we have good data – go back to the main thread
        
                            
                                DispatchQueue.main.async { [self] in
                                    self.model.singleRepository = decodedResponse
                                }
        
                            print("Single repo: \(decodedResponse.created_at) \n \(decodedResponse.language)")
                            
        
                            // everything is good, so we can exit
                            return
                        }
                    }
        
                    // if we're still here it means there was a problem
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        
        
                }.resume()
        
        

        
    }
}
