//
//  EmptySearchView.swift
//  EmptySearchView
//
//  Created by Pavel on 5.09.21.
//

import SwiftUI

struct EmptySearchView: View {
    @State private var isAnimating: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: "binoculars.fill")
                .font(.largeTitle)
            Text("Start typing to search for GitHub repositories.")
                .multilineTextAlignment(.center)
        }
        .padding(.leading, 50)
        .padding(.trailing, 50)
        .overlay(
            Image(systemName: "arrow.up")
                .offset(y: isAnimating ? -150 : -125)
                .font(.largeTitle)
            , alignment: .top)
        .onAppear {
            withAnimation(Animation.linear(duration: 0.8).repeatForever(autoreverses: true)) {
                self.isAnimating.toggle()
            }
        }
    }
        
}

struct EmptySearchView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySearchView()
    }
}
