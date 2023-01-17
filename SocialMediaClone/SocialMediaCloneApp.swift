//
//  SocialMediaCloneApp.swift
//  SocialMediaClone
//
//  Created by Necati Bozkurt on 15.01.2023.
//

import SwiftUI
import Firebase

@main
struct SocialMediaCloneApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
