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
    @State var pageNumber = 1
    
    var body: some View {
        NavigationView {
            List {
                
                ForEach(presenter.userRepositories, id: \.id) { repository in
                    if presenter.userRepositories.last?.id == repository.id {
                        task {
                            self.pageNumber += 1
                            await presenter.fetchUserRepositories(for: searchText, self.pageNumber)
                            print("SearchView: page number: \(pageNumber)")
                        }
                    }
                    
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
            .onSubmit(of: SubmitTriggers.search) {
                self.pageNumber = 1
                presenter.clearArrayOfRepositories()
                if (!searchText.isEmpty){
                    Task {
                        await presenter.fetchUserRepositories(for: searchText.trimmingCharacters(in: .whitespacesAndNewlines), pageNumber)
                    }
                    
                    
                } else {
                    pageNumber = 1
                    presenter.clearArrayOfRepositories()
                }
                
            }
            .onChange(of: searchText, perform: { newValue in
                if newValue.isEmpty {
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
