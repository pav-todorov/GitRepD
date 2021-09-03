//
//  SearchView.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: -  Properties
    var repositories: [UserRepositories]
    
    @State var searchText = ""
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                ZStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search repositories", text: $searchText)
                    }
                    .foregroundColor(.gray)
                    .padding(.leading, 13)
                    
                    Capsule()
                        .foregroundColor(Color("ColorSearchbar"))
                } //: ZStack
                .frame(height: 40)
                .padding()
                
                List {
                    
                    
                    ForEach(repositories, id: \.id) { repository in
                        RepositoryCell(userName: repository.name, repositoryName: repository.owner.login)
                    }
                    
                    .onDelete(perform: { indexSet in
                        print("\(indexSet) is deleted.")
                    })
                } //: List
                .listStyle(InsetGroupedListStyle())
                //                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                .padding(.vertical, 0)
                .frame(maxWidth: 640)
                
            }
            
            .navigationBarTitle("Search")
            
        } //: NavigationView
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let repos = [dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, dummyUserRepo, ]
        
        return SearchView(repositories: repos)
        
    }
}
