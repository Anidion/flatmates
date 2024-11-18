//
//  ProfileView.swift
//  FlatMate
//
//  Created by Jingke Huang on 2024-10-22.
//

import SwiftUI

struct ProfileView: View {
    var userName: String = "John"
    var userAge: Int = 25

    // State variables for handling button clicks
    @State private var isSettingClicked = false
    @State private var isEditProfileClicked = false
    @State private var isLogOutClicked = false
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                // Logo at the top
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 103)
                    .padding(.bottom, 20)

                // Profile Image
                Image("profileImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 220, height: 220)
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                    .shadow(radius: 10)

                // User Details
                Text("\(userName), \(userAge)")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()

                // Reuse ProfileButton for Settings, Edit Profile, Logout
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
                            action: { viewModel.signOut() } // Activate logout navigation
                        )
                    }
                    ProfileButton(
                        icon: "edit_icon",
                        label: "EDIT PROFILE",
                        isSelected: isEditProfileClicked,
                        action: { isEditProfileClicked = true } // Navigate to EditProfileView
                    )
                }
                .padding(.bottom, 40)

                Spacer()
            }
            .navigationBarBackButtonHidden(true) // Hide default back button
            // Add .navigationDestination for Edit Profile
            .navigationDestination(isPresented: $isEditProfileClicked) {
                EditProfileView()
            }
            // Add .navigationDestination for Logout
            .navigationDestination(isPresented: $isLogOutClicked) {
                LoginView()
            }
        }
    }
}

#Preview {
    ProfileView()
}
