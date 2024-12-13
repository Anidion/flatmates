//
//  LoginView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var navigateToResetPassword = false
    @State private var resetEmail = ""
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Logo Image
                    Image("Logo Straight Blue")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 103)
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 35)
                    
                    // Welcome Text
                    Text("Welcome Back")
                        .font(.custom("Outfit-Bold", size: 28))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 20)
                    
                    // Input Fields
                    VStack {
                        InputView(text: $email, title: "Email Address", placeholder: "name@example.com", isSecureField: false)
                        InputView(text: $password, title: "Password", placeholder: "***************", isSecureField: true)
                        
                        // Error Message Display
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.custom("Outfit-Regular", size: 14))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading) // Aligns the text to the left
                                .padding(.bottom, 10)
                        }
                        
                        HStack {
                            Spacer()
                            ButtonView(title: "Forgot Password?", action: {
                                navigateToResetPassword = true
                            }, type: .link)
                        }
                        .padding(.top, errorMessage == nil ? 20 : 5)
                        .padding(.bottom, 20)
                        .navigationDestination(isPresented: $navigateToResetPassword) {
                            ResetPasswordView().environmentObject(viewModel)
                        }
                        
                        // Use ButtonView for the Log In button
                        ButtonView(title: "Log In", action: { Task {
                            do {
                                try await viewModel.signIn(withEmail: email, password: password)
                            } catch let error as NSError {
                                // Firebase-specific error handling
                                if let authError = AuthErrorCode(rawValue: error.code) {
                                    switch authError {
                                    case .invalidEmail:
                                        self.errorMessage = "The email address is invalid."
                                    default:
                                        self.errorMessage = "Wrong credentials. Please try again."
                                    }
                                } else {
                                    // Fallback if the error is not an AuthErrorCode
                                    self.errorMessage = "An unexpected error occurred. Please contact support."
                                }
                            }
                        }})
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Terms of Service and Privacy Policy
                    VStack {
                        (
                            Text("ⓘ By tapping 'Log In', you agree to our ")
                            + Text("Terms of Service").underline()
                            + Text(" and ")
                            + Text("Privacy Policy").underline()
                            + Text(".")
                        )
                        .multilineTextAlignment(.center)
                    }
                    .font(.custom("Outfit-Regular", size: 15))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 45)
                    
                    // Sign Up Section
                    HStack {
                        Text("Don't have an account?")
                            .font(.custom("Outfit-Regular", size: 17))
                            .foregroundColor(.primary)
                        
                        NavigationLink(destination: SignupView().navigationBarBackButtonHidden(true)) {
                            Text("Register")
                                .font(.custom("Outfit-Bold", size: 17))
                                .foregroundColor(Color("primary"))
                                .underline()
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LoginView()
}
