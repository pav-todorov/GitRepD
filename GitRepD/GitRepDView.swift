//
//  GitRepDView.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI

struct GitRepDView: View {
    var body: some View {
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
            
        }
        .edgesIgnoringSafeArea(.top)
        
    }
}

struct GitRepDView_Previews: PreviewProvider {
    static var previews: some View {
        GitRepDView()
    }
}
