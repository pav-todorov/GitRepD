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
            LinearGradient(gradient:
                            Gradient(colors:
                                        [Color.mint,
                                         Color.blue]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .frame(width: 200, height: 50, alignment: .center)
                .mask(Text("Start typing to search for GitHub repositories."))
                .multilineTextAlignment(.center)
            
        }
        .padding(.leading, 50)
        .padding(.trailing, 50)
        .overlay(
            Image(systemName: "arrow.up")
                .offset(y: isAnimating ? -145 : -120)
                .font(.largeTitle)
            , alignment: .top)
        .onAppear {
            withAnimation(
                Animation
                    .linear(duration: 1)
                    .repeatForever(autoreverses: true)) {
                        self.isAnimating.toggle()
                    }
        } //: OnAppear
    }
    
}

struct EmptySearchView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySearchView()
    }
}
