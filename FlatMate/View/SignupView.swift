//
//  SignupView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct SignupView: View {
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSignupActive = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                // Logo Image
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 103)
                    .padding(.bottom, 20)
                
                // Signup Title
                Text("Create Your Account")
                    .font(.custom("Outfit-Bold", size: 28))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
                
                // Input Fields
                VStack {
                    InputView(text: $username, title: "Username", placeholder: "username", isSecureField: false)
                    InputView(text: $fullname, title: "Email Address", placeholder: "name@example.com", isSecureField: false)
                    InputView(text: $password, title: "Password", placeholder: "***************", isSecureField: true)
                    InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "***************", isSecureField: true)

                    // Signup Button
                    ButtonView(title: "Sign up", action: {// Add logic here to validate inputs and handle signup
                        isSignupActive = true}, type: .standard)
                }
                .padding(.horizontal, 20)

                Spacer()

                // Already have an account? Log in button
                Button(action: {
                    dismiss() // Dismiss the signup view to return to login
                }) {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                            .font(.custom("Outfit-Regular", size: 17))
                            .foregroundColor(.primary)
                        Text("Log in")
                            .font(.custom("Outfit-Bold", size: 17))
                            .foregroundColor(Color("primary")) // Use your custom primary color here
                            .underline()
                    }
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
            .navigationBarHidden(true) // Hide the navigation bar
            .navigationDestination(isPresented: $isSignupActive) {
                MainView() // Navigate to MainView on successful signup
            }
        }
    }
}

#Preview {
    SignupView()
}
