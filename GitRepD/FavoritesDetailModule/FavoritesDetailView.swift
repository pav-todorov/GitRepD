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
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        Form {
            Section() {
                AsyncImage(url: URL(string: presenter.singleRepository?.owner.avatar_url ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 125, alignment: .center)
                .clipShape(Circle())
                .overlay(Circle()
                            .stroke(Color.black .opacity(0.8), lineWidth: 4))
                .overlay(Circle()
                            .stroke(Color.white, lineWidth: 4))
                .shadow(color: .gray .opacity(colorScheme == .dark ? 0 : 1), radius: 10)
            }
            .listRowBackground(Color(UIColor.systemGroupedBackground))
            .listSectionSeparator(.hidden)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            
            Section(header: Text("Quick overview:")) {
                DetailFormRowView(firstItem: "Date created:",
                                  secondItem: presenter.singleRepository?.created_at ?? "N/A")
                DetailFormRowView(firstItem: "Language used:",
                                  secondItem: presenter.singleRepository?.language ?? "N/A")
                DetailFormRowView(firstItem: "Description",
                                  secondItem: presenter.singleRepository?.description ?? "N/A")
                DetailFormRowView(firstItem: "URL",
                                  secondItem: presenter.singleRepository?.html_url ?? "N/A")
                    .onTapGesture {
                        UIApplication.shared.open((URL(string: presenter.singleRepository?.html_url ?? "https://google.com") ?? URL(string: "https://google.com"))!)
                        
                    }
            }
            
        }
        .navigationTitle(presenter.singleRepository?.name ?? "N/A")
        
        .onAppear {
            Task {
                await self.presenter.fetchRepository(with: viewContext)
            }
        } //: onAppear
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
                .multilineTextAlignment(.trailing)
            
        }
    }
}


//
//struct FavoritesDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesDetailView()
//    }
//}
