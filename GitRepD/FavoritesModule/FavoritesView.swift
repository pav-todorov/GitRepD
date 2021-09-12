//
//  FavoritesView.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    var presenter: FavoritesPresenter
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Repository.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Repository.timestamp, ascending: false)],
        animation: .default)
    var fetchedItemsFromDB: FetchedResults<Repository>
    @State var searchItems: FetchedResults<Repository>?
    @State private var searchText = ""
    @State private var showingAlert = false
    @State private var errorMessage = ""
    
    @State var isRepositorySaved = true
    @State var cellNeedsRefresh: Bool = false
    
    var repositoryItems: FetchedResults<Repository> {
        if !searchText.isEmpty {
            return fetchedItemsFromDB
        } else {
            fetchedItemsFromDB.nsPredicate = NSPredicate(value: true)
            return fetchedItemsFromDB
        }
        
    }
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(repositoryItems, id: \.id) { item in
                    self.presenter.linkBuilder(for: Int(item.id)) {
                        
                        RepositoryCell(repositoryAvatar: item.avatarURL ?? "",
                                       userName: item.name ?? "N/A",
                                       repositoryName: item.name ?? "N/A", repositoryId: Int(item.id), includeStarIndicator: false)
                        
                    }
                    
                } //: ForEach
                .onDelete(perform: deleteItems)
            } //: List
            .searchable(text: $searchText, prompt: "Search through favorites...")
            .onChange(of: searchText, perform: { newValue in
                self.fetchedItemsFromDB.nsPredicate = NSPredicate(format: "name CONTAINS[cd] %@", newValue)
            })
            .listStyle(InsetGroupedListStyle())
            .padding(.vertical, 0)
            .frame(maxWidth: 640)
            .navigationTitle("Favorites")
            .toolbar {
                EditButton()
            }
        }
        .alert(errorMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { fetchedItemsFromDB[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                self.errorMessage = "Oops, \(offsets.map { fetchedItemsFromDB[$0] }.first?.name ?? "N/A") repository couldn't be deleted. Please, restart the app and try again."
                self.showingAlert.toggle()
                return
            }
        }
    }
}
