//
//  PostCardView.swift
//  SocialMediaClone
//
//  Created by Necati Bozkurt on 24.01.2023.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct PostCardView: View {
    var post: Post
    // Callbacks
    var onUpdate: (Post)->()
    var onDelete: ()->()
    // - View Properties
    @AppStorage("user_UID") private var userUID: String = ""
    @State private var docListener: ListenerRegistration?
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            WebImage(url: post.userProfileURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35,height: 35)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 6) {
                Text(post.userName)
                    .font(.callout)
                    .fontWeight(.semibold)
                Text(post.publishedDate.formatted(date:.numeric, time:.shortened))
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(post.text)
                    .textSelection(.enabled)
                    .padding(.vertical,8)
                
                // Post Image If Any
                if let postImageURL = post.imageURL{
                    GeometryReader{
                        let size = $0.size
                        WebImage(url: postImageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width,height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .frame(height:200)
                }
                
                PostInteraction()
            }
        }
        .hAling(.leading)
        .overlay(alignment: .topTrailing, content: {
            // Displaying Delete Button (if it's Author of that post)
            if post.userUID == userUID{
                Menu {
                    Button("Delete Post", role: .destructive, action: deletePost)
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.caption)
                        .rotationEffect(.init(degrees: -90))
                        .foregroundColor(.black)
                        .padding(8)
                        .contentShape(Rectangle())
                }
            }
        })
        .onAppear{
            // Adding Only Once
            if docListener == nil {
                guard let postID = post.id else{return}
                docListener = Firestore.firestore().collection("Post").document(postID).addSnapshotListener({ snapshot, error in
                    if let snapshot {
                        if snapshot.exists{
                            // Document Update
                            // Fetching Updated Document
                            if let updatedPost = try? snapshot.data(as: Post.self){
                                onUpdate(updatedPost)
                            }
                        }else{
                            // Document Deleted
                            onDelete()
                        }
                    }
                })
            }
        }
        .onDisappear{
            // MARK: Applying SnapShot Listner Only When the Post is Available on the Screen
            // Else removing the Listner (It saves unwanted live updates from the posts which was swiped away from the screen)
            if let docListener{
                docListener.remove()
                self.docListener = nil
            }
        }
    }
    
    // MARK: Like/Dislike Interaction
    @ViewBuilder
    func PostInteraction()-> some View{
        HStack(spacing: 6) {
            Button(action: likePost){
                Image(systemName: post.likedIDs.contains(userUID) ? "hand.thumbsup.fill" : "hand.thumbsup")
            }
            Text("\(post.likedIDs.count)")
                .font(.caption)
                .foregroundColor(.gray)
            
            Button(action: dislikePost){
                Image(systemName: post.dislikedIDs.contains(userUID) ? "hand.thumbsdown.fill" : "hand.thumbsdown")
            }
            .padding(.leading,25)
            
            Text("\(post.dislikedIDs.count)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .foregroundColor(.black)
        .padding(.vertical,8)
    }
    
    
    // Liking Post
    func likePost(){
        Task{
            guard let postID = post.id else{return}
            if post.likedIDs.contains(userUID){
                // Removing UserID
                try await Firestore.firestore().collection("Post").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID])
                ])
            }else{
                // Adding User ID To Liked Array and Removing our ID from Disliked Array (if Added in prior)
                try await Firestore.firestore().collection("Post").document(postID).updateData([
                    "likedIDs": FieldValue.arrayUnion([userUID]),
                    "dislikedIDs": FieldValue.arrayRemove([userUID])
                ])
            }
        }
    }
    
    // Dislike Post
    func dislikePost(){
        Task{
            guard let postID = post.id else{return}
            if post.dislikedIDs.contains(userUID){
                // Removing UserID
                try await Firestore.firestore().collection("Post").document(postID).updateData([
                    "dislikedIDs": FieldValue.arrayRemove([userUID])
                ])
            }else{
                // Adding User ID To Liked Array and Removing our ID from Disliked Array (if Added in prior)
                try await Firestore.firestore().collection("Post").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID]),
                    "dislikedIDs": FieldValue.arrayUnion([userUID])
                   
                ])
            }
        }
    }
    // Deleting Post
    func deletePost(){
        Task{
            // Step 1: Delete Image from Firebase Storage if Present
            do{
                if post.imageReferenceID != ""{
                    try await Storage.storage().reference().child("Post_Images").child(post.imageReferenceID).delete()
                }
                // Step 2: Delete Firestore Document
                guard let postID = post.id else{return}
                try await Firestore.firestore().collection("Post").document(postID).delete()
            }catch{
                print(error.localizedDescription)
            }
            
        }
    }
}

