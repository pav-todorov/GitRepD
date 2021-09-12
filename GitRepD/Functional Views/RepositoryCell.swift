//
//  RepositoryCell.swift
//  GitRepD
//
//  Created by Pavel Todorov on 3.09.21.
//

import SwiftUI
import CoreData

struct RepositoryCell: View {
    // MARK: -  Properties
    let repositoryAvatar: String
    let userName: String
    let repositoryName: String
    let repositoryId: Int
    @State var includeStarIndicator: Bool
    @State var isRepositorySaved: Bool = false
    @State private var singleRepository: SingleRepository?
    
    @Binding var needToRefreshCellData: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        //        entity: Repository.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Repository.name, ascending: false)],
        animation: .default)
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
                .opacity((includeStarIndicator && (isRepositorySaved)) ? 1 : 0)
                .onAppear {
                    isInDatabase(for: viewContext, and: repositoryId)
                }
                .onChange(of: needToRefreshCellData) { _ in
                    isInDatabase(for: viewContext, and: repositoryId)
                    DispatchQueue.main.async {
                        needToRefreshCellData.toggle()
                    }
                    
                }
        }
        
    }
    
    /// This function checks if a single repository with particular id has been saved to the CoreData database.
    func isInDatabase(for context: NSManagedObjectContext, and id: Int) {
        
        let predicate = NSPredicate(format: "id == %@", String(id))
        
        let request: NSFetchRequest<Repository> = Repository.fetchRequest()
        request.predicate = predicate
        
        if let result = try? context.fetch(request) {
            if (result != []) {
                isRepositorySaved = true
            } else {
                isRepositorySaved = false
            }
        }
        
    }
    
    func getSingleRepository(with url: String) async {
        
        guard let url = URL(string: url) else {
            fatalError("wrong url")
        }
        
        print("GitRepDInteractor url: \(url)")
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let decodedResponse: SingleRepository = try? JSONDecoder().decode(SingleRepository.self, from: data) {
                    // we have good data – go back to the main thread
                    
                    self.singleRepository = decodedResponse
                    
                    return
                }
            }
            
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
            
        }.resume()
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
