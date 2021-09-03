//
//  GitRepDView.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI

struct GitRepDView: View {
    
    @ObservedObject var presenter: GitRepDPresenter
    
    var body: some View {
        
        VStack {
            List {
                ForEach(presenter.userRepositories, id: \.id) { repository in
                    Text(repository.name)
                }
                .onDelete(perform: { indexSet in
                    print("\(indexSet) is deleted.")
                })
            } //: List
            .listStyle(InsetGroupedListStyle())
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
            .padding(.vertical, 0)
            .frame(maxWidth: 640)
            
            Spacer()
            
            Button(action: {
                presenter.fetchUserRepositories()
            }, label: {
                Text("Button")
            })
            
            TabView{
                ContentView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                ContentView()
                    .tabItem {
                        Image(systemName: "star")
                        Text("Favorites")
                    }
                
            } //: TabView
            .edgesIgnoringSafeArea(.top)

        } //: VStack
        .navigationBarTitle("User repositories")
    }
}

struct GitRepDView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel()
        let interactor = GitRepDInteractor(model: model)
        let presenter = GitRepDPresenter(interactor: interactor)
        
        GitRepDView(presenter: presenter)
    }
}
