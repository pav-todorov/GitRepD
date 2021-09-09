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
     var items: FetchedResults<Repository>
    @State private var searchText = ""
    
    
    @State var searchItems: FetchedResults<Repository>?
    
    var searching: FetchedResults<Repository> {
        if !searchText.isEmpty {
            return items
        } else {
            return searchItems ?? items
        }
    }
    
    var body: some View {
        
        NavigationView {

     
                List {
                    ForEach(searching, id: \.id) { item in
                        self.presenter.linkBuilder(for: Int(item.id)) {
                        
                        RepositoryCell(repositoryAvatar: "",
                                       userName: item.name ?? "N/A",
                                       repositoryName: item.name ?? "N/A")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .searchable(text: $searchText, prompt: "Search through favorites...")
                .onChange(of: searchText, perform: { newValue in
                    self.searchItems!.nsPredicate = NSPredicate(format: "name CONTAINS %@", newValue)

                })
                .onAppear(perform: {
                    self.searchItems = items
                })
                .navigationTitle("Favorites")
                .toolbar {
                    //            #if os(iOS)
                    EditButton()
                    //                Button(action: addItem) {
                    //                    Label("Add item", systemImage: "plus")
                    //                }
                    //            #endif
                    
                    //                Button(action: addItem) {
                    //                    Label("Add Item", systemImage: "plus")
                    //                }
                }
            
        }
    }
//    private func addItem() {
//        withAnimation {
//            let newItem = Repository(context: viewContext)
//            newItem.timestamp = Date()
//
//            newItem.url = "kjndfsjnsdf"
//            newItem.name = "Test from detailView"
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
    
//    func fetchData(for key: String) {
//        @Environment(\.managedObjectContext)  var viewContext
//        @FetchRequest(
//            entity: Repository.entity(),
//            sortDescriptors: [NSSortDescriptor(keyPath: \Repository.timestamp, ascending: false)],
//            predicate: NSPredicate(format: "name CONTAINS %@", "test"),
//            animation: .default)
//         var items: FetchedResults<Repository>
//
//        print("key: \(key) and result \(items.first)")
//
////    predicate: NSPredicate(format: "name CONTAINS %@", key),
//
//        self.searchItems = items
//
//
//    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//struct FavoritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
