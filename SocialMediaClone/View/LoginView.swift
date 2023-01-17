//
//  LoginView.swift
//  SocialMediaClone
//
//  Created by Necati Bozkurt on 15.01.2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    // MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    // MARK: View Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
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
        // MARK:  Resgister View VIA Sheet
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }
        // MARK: Dispilaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    func loginUser() {
        Task {
            do{
                // With the help Swift Concurrency Auth can be done with single line
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found")
                
            }catch{
                await setError(error)
            }
        }
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
        })
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// MARK: View extensions for UI Building

extension View {
    func hAling (_ alingment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alingment)
    }
    
    func vAling (_ alingment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alingment)
    }
    
    // MARK: Custum border view with padding
    func border(_ width: CGFloat, _ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
        
    }
    
    // MARK: Custum fill view with padding
    func fillView(_ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
        
    }

    
}
