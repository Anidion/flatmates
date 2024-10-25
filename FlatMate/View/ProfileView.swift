//
//  MyProfileView.swift
//  FlatMate
//
//  Created by Jingke Huang on 2024-10-22.
//

import SwiftUI

struct ProfileView: View {
    var userName: String = "John"
    var userAge: Int = 25
    
    // Add those variables for the next step: Adding logic
    @State private var isSettingClicked = false
    @State private var isEditProfileClicked = false
    @State private var isLogOutClicked = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo at the top
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 103)
                    .padding(.bottom, 20)
                
                Image("profileImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 220, height: 220)
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                    .shadow(radius: 10)
                    
                Text("\(userName), \(userAge)")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()
                
                // Reuse ProfileButton Component for Settings, Edit Profile, Logout
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        ProfileButton(
                            icon: "settings_icon",
                            label: "SETTINGS",
                            isSelected: isSettingClicked,
                            action: { isSettingClicked.toggle() }
                        )
                        ProfileButton(
                            icon: "logout_icon",
                            label: "LOGOUT",
                            isSelected: isLogOutClicked,
                            action: { isLogOutClicked = true } // Activate logout navigation
                        )
                    }
                    ProfileButton(
                        icon: "edit_icon",
                        label: "EDIT PROFILE",
                        isSelected: isEditProfileClicked,
                        action: { isEditProfileClicked.toggle() }
                    )
                }
                .padding(.bottom, 40)

                Spacer()
            }
            .navigationBarBackButtonHidden(true) // Hide default back button
            // Add .navigationDestination for logout
            .navigationDestination(isPresented: $isLogOutClicked) {
                LoginView()
            }
        }
    }
}

#Preview {
    ProfileView()
}
