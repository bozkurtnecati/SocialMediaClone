//
//  RegisterView.swift
//  SocialMediaClone
//
//  Created by Necati Bozkurt on 16.01.2023.
//

import SwiftUI
import PhotosUI
import Firebase

struct RegisterView: View {
    // MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    // MARK: View Properties
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    var body: some View {
        VStack(spacing: 10.0) {
            Text("Lets Register\nAccount")
                .font(.largeTitle.bold())
                .hAling(.leading)
            Text("Hello user, have a wonderful journey")
                .font(.title3)
                .hAling(.leading)
            
            // MARK: For smaller size optimization
            ViewThatFits{
                ScrollView (.vertical, showsIndicators: false) {
                    HelperView()
                }
                HelperView()
            }
            
            // MARK: Register Button
            HStack{
                Text("Already have an account?")
                    .foregroundColor(.gray)
                Button("Login Now") {
                    dismiss()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAling(.bottom)
            
        }
        .vAling(.top)
        .padding(15)
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            // MARK: Extracting UIImage From PhotoItem
            if let newValue {
                Task{
                    do{
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else {return}
                        // MARK: UI Must be Updated on Main Thread
                        await MainActor.run(body: {
                            userProfilePicData = imageData
                        })
                    }
                }
                
            }
        }
    }
    
    @ViewBuilder
    func HelperView() -> some View {
        VStack(spacing: 12.0){
            ZStack{
                if let userProfilePicData, let image = UIImage(data: userProfilePicData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else {
                    Image("NullProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 85.0, height: 85.0)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            .padding(.top,25)
        
            TextField("Username", text: $userName)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            SecureField("Password", text: $password)
                .textContentType(.password)
                .border(1, .gray.opacity(0.5))
            
            TextField("About You", text: $userBio, axis: .vertical)
                .frame(minHeight:100, alignment: .top)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("Bio Link (Optional)", text: $userBioLink)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            

            Button {
                
            } label: {
                // MARK: Login button
                Text("Sign up")
                    .foregroundColor(.white)
                    .hAling(.center)
                    .fillView(.black)
            }
            .padding(.top,10)

        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
