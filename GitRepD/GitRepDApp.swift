//
//  GitRepDApp.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI

@main
struct GitRepDApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        let model = DataModel()
        let interactor = GitRepDInteractor(model: model)
        let presenter = GitRepDPresenter(interactor: interactor)
        
        WindowGroup {
            
            GitRepDView(presenter: presenter)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            

        }
    }
}
