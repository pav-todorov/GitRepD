//
//  RepositoryCell.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI
import CoreData
import Combine

struct RepositoryCell: View {
    // MARK: -  Properties
    let repositoryAvatar: String
    let userName: String
    let repositoryName: String
    let repositoryId: Int
    @State var includeStarIndicator: Bool
    @State var isRepositorySaved: Bool = false
    @State private var singleRepository: SingleRepository?
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Repository.name, ascending: false)],
        animation: .linear)
    private var items: FetchedResults<Repository>
    
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
                .opacity((includeStarIndicator && (items.map{ Int($0.id) }.contains(repositoryId))) ? 1 : 0)
            
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
