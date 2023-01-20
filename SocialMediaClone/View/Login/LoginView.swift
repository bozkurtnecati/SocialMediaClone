//
//  LoginView.swift
//  SocialMediaClone
//
//  Created by Necati Bozkurt on 15.01.2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    // MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    // MARK: View Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    // MARK: UserDefaults
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        VStack(spacing: 10.0) {
            Text("Lets Sing you in")
                .font(.largeTitle.bold())
                .hAling(.leading)
            Text("Welcome back, \nYou have been missed")
                .font(.title3)
                .hAling(.leading)
            
            VStack(spacing: 12.0){
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top,25)
                
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .border(1, .gray.opacity(0.5))
                
                Button("Reset Password?", action: resetPasword)
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAling(.trailing)
                
                Button (action: loginUser){
                    // MARK: Login button
                    Text("Sign in")
                        .foregroundColor(.white)
                        .hAling(.center)
                        .fillView(.black)
                }
                .padding(.top,10)

            }
            
            // MARK: Register Button
            HStack{
                Text("Don't have a account?")
                    .foregroundColor(.gray)
                Button("Register Now") {
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAling(.bottom)
        }
        .vAling(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        // MARK:  Resgister View VIA Sheet
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }
        // MARK: Dispilaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    func loginUser() {
        isLoading = true
        closeKeyboard()
        Task {
            do{
                // With the help Swift Concurrency Auth can be done with single line
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found")
                try await fetchUser()
            }catch{
                await setError(error)
            }
        }
    }
    
    // MARK: If user if found then Fetching user data from Firestore
    func fetchUser() async throws {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        // MARK: UI Updating Must be Run ON Main Thread
        await MainActor.run(body: {
            // Settigs UserDefaults Data and Changing App's Auth Status
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
            logStatus = true
        })
    }
    
    func resetPasword() {
        Task {
            do{
                // With the help Swift Concurrency Auth can be done with single line
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
                
            }catch{
                await setError(error)
            }
        }
    }
    
    // MARK: Displaying Errors VIA Alert
    func setError(_ error: Error) async {
        // MARK: UI Must be Updated on Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
