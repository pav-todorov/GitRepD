//
//  RepositoryCell.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI

struct RepositoryCell: View {
    // MARK: -  Properties
    let repositoryAvatar: String
    let userName: String
    let repositoryName: String
    @State var includeStarIndicator: Bool
    @State var isRepositorySaved: Bool
    
    
    // MARK: -  Body
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: repositoryAvatar)) { image in
                image
                    .resizable()
                    .scaledToFit()
                
            } placeholder: {
                
                ProgressView()
            }
            .frame(width: 45, height: 45, alignment: .leading)
            
            VStack(alignment: .leading) {
                Text(userName)
                    .fontWeight(.bold)
                    .font(.headline)
                
                Text(repositoryName)
                    .fontWeight(.light)
                    .font(.footnote)
                
            }
            
            Spacer()
            
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .opacity((includeStarIndicator && (isRepositorySaved)) ? 1 : 0)
            
        }
    }
}

// MARK: -  Preview
//struct RepositoryCell_Previews: PreviewProvider {
//    static var previews: some View {
//        RepositoryCell(repositoryAvatar: "", userName: "User Name", repositoryName: "Repository name", includeStarIndicator: true, isRepositorySaved: true)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
