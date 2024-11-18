//
//  SignupView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

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
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com", isSecureField: false)
                    InputView(text: $password, title: "Password", placeholder: "***************", isSecureField: true)
                    InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "***************", isSecureField: true)
                    
                    // Error Message Display
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 10)
                    }

                    // Signup Button
                    ButtonView(title: "Sign up", action: {Task {
                        if validatePassword() {
                            do {
                                try await viewModel.createUser(withEmail: email, password: password, username: username)
                            } catch let error as NSError {
                                // Handle Firebase-specific errors
                                if let authError = AuthErrorCode(rawValue: error.code) {
                                    switch authError {
                                    case .emailAlreadyInUse:
                                        errorMessage = "The email address is already taken."
                                    default:
                                        errorMessage = "Failed to create an account. Please try again."
                                    }
                                } else {
                                    errorMessage = "An unexpected error occurred. Please contact support."
                                }
                            }
                        }
                    }})
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
        }
    }
    
    // MARK: - Password Validation
    private func validatePassword() -> Bool {
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return false
        }
        
        if password.count < 12 {
            errorMessage = "Password must be at least 12 characters long."
            return false
        }
        
        let uppercaseLetter = CharacterSet.uppercaseLetters
        let lowercaseLetter = CharacterSet.lowercaseLetters
        let number = CharacterSet.decimalDigits
        let specialCharacter = CharacterSet.punctuationCharacters.union(.symbols)
        
        if !password.unicodeScalars.contains(where: { uppercaseLetter.contains($0) }) {
            errorMessage = "Password must include at least one uppercase letter."
            return false
        }
        
        if !password.unicodeScalars.contains(where: { lowercaseLetter.contains($0) }) {
            errorMessage = "Password must include at least one lowercase letter."
            return false
        }
        
        if !password.unicodeScalars.contains(where: { number.contains($0) }) {
            errorMessage = "Password must include at least one number."
            return false
        }
        
        if !password.unicodeScalars.contains(where: { specialCharacter.contains($0) }) {
            errorMessage = "Password must include at least one special character."
            return false
        }
        
        errorMessage = nil
        return true
    }
}

#Preview {
    SignupView()
}


