//
//  SearchUserView.swift
//  SocialMediaClone
//
//  Created by Necati Bozkurt on 26.01.2023.
//

import SwiftUI
import FirebaseFirestore

struct SearchUserView: View {
    // View Properties
    @State private var fetchedUsers: [User] = []
    @State private var searhText: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        List{
            ForEach(fetchedUsers){ user in
                NavigationLink{
                    ReusableProfileContent(user: user)
                }label: {
                    Text(user.username)
                        .font(.callout)
                        .hAling(.leading)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Search User")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searhText)
        .onSubmit(of: .search, {
            // Fetch User From Firebase
            Task{await searchUser()}
        })
        .onChange(of: searhText, perform: { newValue in
            if newValue.isEmpty{
                fetchedUsers = []
            }
        })
    }
    
    func searchUser()async{
        do{
            
            let documents = try await Firestore.firestore().collection("Users")
                .whereField("username", isGreaterThanOrEqualTo: searhText)
                .whereField("username", isLessThanOrEqualTo: "\(searhText)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }
            // UI Must be Updated on Main Thread
            await MainActor.run(body: {
                fetchedUsers = users
            })
        }catch{
            print(error.localizedDescription)
        }
    }
}

struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
    }
}
