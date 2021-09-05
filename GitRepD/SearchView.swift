//
//  SearchView.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    // MARK: -  Properties
    @State var repositories: [UserRepositories] = []
    var presenter: GitRepDPresenter
    @State var searchText: String = ""
    
    var searchResults: [UserRepositories] {
        if searchText.isEmpty {
            presenter.clearArrayOfRepositories()
            return presenter.userRepositories
        } else {
            presenter.fetchUserRepositories(for: searchText)
            
            return presenter.userRepositories
            //            return repositories.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.id) { repository in
                    RepositoryCell(repositoryAvatar: repository.owner.avatar_url, userName: repository.name, repositoryName: repository.owner.login)
                    
                } //: ForEach
                
                .onDelete(perform: { indexSet in
                    print("\(indexSet) is deleted.")
                })
            } //: List
            .searchable(text: $searchText, prompt: "Search for a repository...")
            .listStyle(InsetGroupedListStyle())
            .padding(.vertical, 0)
            .frame(maxWidth: 640)
            .navigationBarTitle("Search")
            .overlay {
                EmptySearchView()
                    .opacity(presenter.userRepositories.isEmpty ? 1 : 0)
            }
        } //: NavigationView
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        let repos = [dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, ]
//
//        return SearchView(repositories: repos, presenter: GitRepDPresenter(interactor: GitRepDInteractor()))
//
//    }
//}
