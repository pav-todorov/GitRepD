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
        
        AsyncImage(url: URL(string: presenter.singleRepository?.owner.avatar_url ?? "")) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 100, height: 100, alignment: .center)
        
        Form {
            Section(header: Text(presenter.singleRepository?.name ?? "N/A")) {
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
