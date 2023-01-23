//
//  PostView.swift
//  SocialMediaClone
//
//  Created by Necati Bozkurt on 23.01.2023.
//

import SwiftUI

struct PostView: View {
    @State private var createNewPost: Bool = false
    var body: some View {
        Text("Hello, World!")
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
            .fullScreenCover(isPresented: $createNewPost) {
                CreateNewPost { post in
                    
                }
            }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
