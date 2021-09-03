//
//  GitRepDView.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI

struct GitRepDView: View {
    
    @ObservedObject var presenter: GitRepDPresenter
    
    var body: some View {
        
            TabView {
                SearchView(repositories: presenter.userRepositories)
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    .onAppear(perform: {
                        presenter.fetchUserRepositories()
                    })
                
                    ContentView()
                        .tabItem {
                            Image(systemName: "star")
                            Text("Favorites")
                        }
                    
            } //: TabView
        
    }
}

struct GitRepDView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel()
        let interactor = GitRepDInteractor(model: model)
        let presenter = GitRepDPresenter(interactor: interactor)
        
        GitRepDView(presenter: presenter)
    }
}
