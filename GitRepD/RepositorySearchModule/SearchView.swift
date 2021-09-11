//
//  SearchView.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI
import Combine
import CoreData

struct SearchView: View {
    
    // MARK: -  Properties
    @ObservedObject var presenter: GitRepDPresenter
    @State var searchText: String = ""
    @State var pageNumber = 1
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: -  Body
    var body: some View {
        NavigationView {
            List {
                
                ForEach(Array(self.presenter.userRepositories.enumerated()), id: \.1.id) { index, repository in
                    
                    self.presenter.linkBuilder(for: repository) {
                        RepositoryCell (
                            repositoryAvatar: repository.owner.avatar_url,
                            userName: repository.name,
                            repositoryName: repository.owner.login, includeStarIndicator: true,
                            isRepositorySaved: presenter.isInDatabase(for: viewContext, and: repository.id)
                        )
                            .onAppear {
                                if (self.presenter.userRepositories.last?.id == repository.id) {
                                    Task {
                                        self.pageNumber += 1
                                        await self.presenter.fetchUserRepositories(for: searchText, self.pageNumber)
                                    }
                                }
                            }
                    }
                    .swipeActions(edge: .leading, content: {
                        Button {
                            Task {
                                await presenter.addItem(for: viewContext, with: repository.url)
                                
                            }
                        } label: {
                            Label("Save", systemImage: "star.fill")
                        }
                        .tint(.yellow)
                        // If the repository is indeed in the database - don't allow to be saved again, in order to prevent duplicates.
                        .disabled(presenter.isInDatabase(for: viewContext,
                                                            and: repository.id) ? true : false)
                    })
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            self.presenter.removeItemFromDatabase(for: viewContext, and: repository.id)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        // If the repository is NOT in the database - don't allow the delete swipe action.
                        .disabled(presenter.isInDatabase(for: viewContext,
                                                            and: repository.id) ? false : true)
                    }
                } //: ForEach
                
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
        .alert(presenter.errorMessage, isPresented: $presenter.showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}
