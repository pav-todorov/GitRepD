//
//  RepositoryDetailView.swift
//  RepositoryDetailView
//
//  Created by Pavel on 5.09.21.
//

import SwiftUI

struct RepositoryDetailView: View {
    @ObservedObject var presenter: RepositoryDetailPresenter
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        
        VStack {
            ZStack {
                //                AsyncImage(url: URL(string: presenter.singleRepository?.parent.avatar_url ?? ""))
                Image(systemName: "photo")
                    .font(.system(size: 100))
                
            }
            
            Spacer()
            
            Form {
                Section(header: Text(presenter.singleRepository?.name ?? "N/A")) {
                    FormRowView(firstItem: "Date created:", secondItem: presenter.singleRepository?.created_at ?? "N/A")
                    FormRowView(firstItem: "Language used:", secondItem: presenter.singleRepository?.language ?? "N/A")
                    FormRowView(firstItem: "Description", secondItem: presenter.singleRepository?.description ?? "N/A")
                    
                }
            }
        }
        .navigationBarItems(leading: Button(action: {
            self.presenter.removeItemFromDatabase(for: self.viewContext)
            print("deleted a repo")
        }, label: {
            Image(systemName: "trash")
            
        }), trailing: Button(action: {
            Task {
                if await self.presenter.isInDatabase(for: viewContext) {
                    presenter.removeItemFromDatabase(for: viewContext)
                } else {
                    presenter.addItemToDatabase(for: viewContext)
                }
                print("star pressed")
            }
        }, label: {
            Image(systemName: presenter.isRepositoryInDatabase ? "star.fill" : "star")
        }))
        .onAppear {
            Task {
                await presenter.getselectedRepository(with: viewContext)
//                await presenter.isInDatabase(for: viewContext)
            }
        }
    }
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String
    
    var body: some View {
        HStack {
            Text(firstItem).foregroundColor(Color.gray)
            Spacer()
            Text(secondItem)
            
        }
    }
}

struct RepositoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryDetailView(presenter: RepositoryDetailPresenter(interactor: RepositoryDetailInteractor(model: DataModel(), userRepository: dummyUserRepo)))
    }
}
