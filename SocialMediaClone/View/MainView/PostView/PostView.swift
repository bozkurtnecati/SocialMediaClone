//
//  PostView.swift
//  SocialMediaClone
//
//  Created by Necati Bozkurt on 23.01.2023.
//

import SwiftUI

struct PostView: View {
    @State private var recentsPosts: [Post] = []
    @State private var createNewPost: Bool = false
    var body: some View {
        NavigationStack{
            ReusablePostView(posts: $recentsPosts)
                .hAling(.center).vAling(.center)
                .overlay(alignment: .bottomTrailing) {
                    Button{
                        createNewPost.toggle()
                    }label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(13)
                            .background(.black,in: Circle())
                        
                    }
                    .padding(15)
                }
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink{
                            SearchUserView()
                        }label: {
                            Image(systemName: "magnifyingglass")
                                .tint(.black)
                                .scaleEffect(0.9)
                        }
                    }
                })
                .navigationTitle("Post's")
        }
        .fullScreenCover(isPresented: $createNewPost) {
            CreateNewPost { post in
                // Adding Created post at the Top of the Recent Posts
                recentsPosts.insert(post, at: 0)
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
