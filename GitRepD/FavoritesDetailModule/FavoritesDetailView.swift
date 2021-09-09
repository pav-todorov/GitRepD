//
//  FavoritesDetailView.swift
//  FavoritesDetailView
//
//  Created by Pavel Todorov on 8.09.21.
//

import SwiftUI
import Combine

struct FavoritesDetailView: View {
        @ObservedObject var presenter: FavoritesDetailPresenter
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
                        DetailFormRowView(firstItem: "Date created:", secondItem: presenter.singleRepository?.created_at ?? "N/A")
                        DetailFormRowView(firstItem: "Language used:", secondItem: presenter.singleRepository?.language ?? "N/A")
                        DetailFormRowView(firstItem: "Description", secondItem: presenter.singleRepository?.description ?? "N/A")
                        
                    }
                }
            }
//            .navigationBarItems(leading: Button(action: {
//                self.presenter.removeItemFromDatabase(for: self.viewContext)
//                print("deleted a repo")
//            }, label: {
//                Image(systemName: "trash")
//
//            }), trailing: Button(action: {
//                Task {
//                    if await self.presenter.isInDatabase(for: viewContext) {
//                        presenter.removeItemFromDatabase(for: viewContext)
//                    } else {
//                        presenter.addItemToDatabase(for: viewContext)
//                    }
//                    print("star pressed")
//                }
//            }, label: {
////                Image(systemName: presenter.isRepositoryInDatabase ? "star.fill" : "star")
//            }))
            .onAppear {
                
                
                Task {
                    await self.presenter.fetchRepository(with: viewContext)
                    print("from here: \(self.presenter.singleRepository!)")
//                    await presenter.getselectedRepository(with: viewContext)
    //                await presenter.isInDatabase(for: viewContext)
                }
            }
        }
    }

    struct DetailFormRowView: View {
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


//
//struct FavoritesDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesDetailView()
//    }
//}
