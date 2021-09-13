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
                    
            AsyncImage(url: URL(string: presenter.singleRepository?.owner.avatar_url ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)

            
            Form {
                Section(header: Text(presenter.singleRepository?.name ?? "N/A")) {
                    FormRowView(firstItem: "Date created:",
                                secondItem: presenter.singleRepository?.created_at ?? "N/A")
                    FormRowView(firstItem: "Language used:",
                                secondItem: presenter.singleRepository?.language ?? "N/A")
                    FormRowView(firstItem: "Description",
                                secondItem: presenter.singleRepository?.description ?? "N/A")
                    FormRowView(firstItem: "URL",
                                secondItem: presenter.singleRepository?.html_url ?? "N/A")
                        .onTapGesture {
                            UIApplication.shared.open((URL(string: presenter.singleRepository?.html_url ?? "https://google.com") ?? URL(string: "https://google.com"))!)
                        }
                }
            }
        }
        .alert(presenter.errorMessage, isPresented: $presenter.showingAlert) {
            Button("OK", role: .cancel) { }
            .onAppear {
                feedback.notificationOccurred(.error)
            }
        }
        .navigationBarItems(trailing: Button(action: {
            // Play haptic feedback.
            feedback.notificationOccurred(.success)
            
            Task {
                if await self.presenter.isInDatabase(for: viewContext) {
                    presenter.removeItemFromDatabase(for: viewContext)
                } else {
                    presenter.addItemToDatabase(for: viewContext)
                }
            }
        }, label: {
            Image(systemName: presenter.isRepositoryInDatabase ? "star.fill" : "star")
        }))
        /* If for some reason (slow internet, for example) the name is nil (most likely due to not being fetched yet) don't allow to be saved because it might cause database problems or just display unnecessary empty object, else safely add it */
        .disabled((presenter.singleRepository?.name == nil) ? true : false)
        .onAppear {
            Task {
                await presenter.getselectedRepository(with: viewContext)
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

//struct RepositoryDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RepositoryDetailView(presenter: RepositoryDetailPresenter(interactor: RepositoryDetailInteractor(model: DataModel(), userRepository: dummyUserRepo)))
//    }
//}
