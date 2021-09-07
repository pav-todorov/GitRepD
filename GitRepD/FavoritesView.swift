//
//  FavoritesView.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Repository.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Repository>
    
    var body: some View {
        
        NavigationView {
            if (items.isEmpty){
                EmptyView()
            } else {
                List {
                    ForEach(items, id: \.id) { item in
                        Text(item.name ?? "N/A")
                    }
                    .onDelete(perform: deleteItems)
                }
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
    }
    private func addItem() {
        withAnimation {
            let newItem = Repository(context: viewContext)
            newItem.timestamp = Date()
            
            newItem.url = "kjndfsjnsdf"
            newItem.name = "Test from detailView"
            
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

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
