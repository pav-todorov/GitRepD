//
//  SearchCoreData.swift
//  SearchCoreData
//
//  Created by Pavel Todorov on 9.09.21.
//

import SwiftUI
import CoreData

struct SearchCoreData: View {
    var presenter: FavoritesPresenter
    let context: NSManagedObjectContext
    
    @Environment(\.managedObjectContext) private var viewContext
    var fetchRequest: FetchRequest<Repository>
    //    private var items: FetchedResults<Repository>
    
    init(with context: NSManagedObjectContext, for value: Binding<String>, and presenter: FavoritesPresenter, items: FetchedResults<Repository>) {
        self.items = items
        self.presenter = presenter
        self.context = context
        self.fetchRequest = FetchRequest<Repository>(sortDescriptors: [NSSortDescriptor(keyPath: \Repository.timestamp, ascending: false)], predicate: NSPredicate(format: "name == %@", value as! CVarArg), animation: .default)
    }
    private var items: FetchedResults<Repository>
    
    var body: some View {
        List {
            ForEach(items, id: \.id) { item in
                self.presenter.linkBuilder(for: Int(item.id)) {
                    
                    RepositoryCell(repositoryAvatar: "",
                                   userName: item.name ?? "N/A",
                                   repositoryName: item.name ?? "N/A")
                }
            }
            .onDelete(perform: deleteItems)
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
