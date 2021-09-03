//
//  RepositoryCell.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI

struct RepositoryCell: View {
    // MARK: -  Properties
    let userName: String
    let repositoryName: String
    
    // MARK: -  Body
    var body: some View {
        HStack {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45, alignment: .leading)
            
            VStack(alignment: .leading) {
                Text(userName)
                    .fontWeight(.bold)
                    .font(.headline)
                
                Text(repositoryName)
                    .fontWeight(.light)
                    .font(.footnote)
            }
            
        }
    }
}

// MARK: -  Preview
struct RepositoryCell_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryCell(userName: "User Name", repositoryName: "Repository name")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
