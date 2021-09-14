//
//  EmptySearchView.swift
//  EmptySearchView
//
//  Created by Pavel on 5.09.21.
//

import SwiftUI

struct EmptySearchView: View {
    @State private var isAnimating: Bool = false
    
    /// Depending on the size of the device, increase the x and y position of the arrow, depending on the scale factor.
    var scaleFactor: CGFloat  {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                // iPhone 5 or 5S or 5C
                return 1
                
            case 1334:
                // iPhone 6/6S/7/8
                return 1.35
                
            case 1920, 2208:
                // iPhone 6+/6S+/7+/8+
                return 1.55
                
            case 2436:
                // iPhone X/XS/11 Pro
                return 1.65
                
            case 2688:
                // iPhone XS Max/11 Pro Max
                return 1.90
                
            case 1792:
                // iPhone XR/ 11
                return 1.90
                
            default:
                // Unknown
                return 1
            }
        } else {
            return 1
        }
        
//        return value
    }
    
    
    
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
                .offset(y: isAnimating ? -145*scaleFactor : -120*scaleFactor)
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
