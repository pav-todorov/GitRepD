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
    @ObservedObject var presenter: GitRepDPresenter
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(presenter.userRepositories, id: \.id) { repository in
                    self.presenter.linkBuilder(for: repository) {
                        RepositoryCell (
                            repositoryAvatar: repository.owner.avatar_url,
                            userName: repository.name,
                            repositoryName: repository.owner.login
                        )
                    }
                } //: ForEach
                .onDelete(perform: { indexSet in
                    print("\(indexSet) is deleted.")
                })
            } //: List
            .searchable(text: $searchText, prompt: "Search for a repository...")
            .onChange(of: searchText, perform: { newValue in
                if !newValue.isEmpty {
                    async {
                        await presenter.fetchUserRepositories(for: newValue.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                    
                } else {
                    presenter.clearArrayOfRepositories()
                }
            })
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
