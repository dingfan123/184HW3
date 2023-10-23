//
//   SettingsView.swift
//  hw2
//
//  Created by dingfan zheng on 10/23/23.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject{
    @Published var userEmail: String?
        
    init() {
        fetchUserEmail()
    }
    
    func fetchUserEmail() {
            do {
                let user = try AuthenticationManager.shared.getAuthenticatedUser()
                userEmail = user.email
            } catch {
                print(error)
            }
        }
    
    func signOut() throws{
        try AuthenticationManager.shared.signOut()
        
    }
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State private var showWelcomePage = false
    var body: some View {
        List{
            if let email = viewModel.userEmail {
                            Text("Logged in as: \(email)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
            
            Button("Log out"){
                Task{
                    do{
                        try viewModel.signOut()
                        showSignInView = true
                    } catch{
                        print(error)
                    }
                }
            }
            
            Button("Welcome page"){
                showWelcomePage = true
            }
            .background(NavigationLink("", destination: WelcomeView(), isActive: $showWelcomePage))
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Preview: PreviewProvider{
    static var previews: some View{
        NavigationStack{
            SettingsView(showSignInView: .constant(false))
        }
    }
}
