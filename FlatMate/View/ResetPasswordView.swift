//
//  ResetPasswordView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-11-15.
//

import SwiftUI
import FirebaseAuth

struct ResetPasswordView: View {
    @State private var email = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            // Title
            Text("Reset Password")
                .font(.custom("Outfit-Bold", size: 28))
                .multilineTextAlignment(.center)
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            // Email Input
            InputView(text: $email, title: "Email Address", placeholder: "name@example.com", isSecureField: false)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            
            // Error Message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.custom("Outfit-Regular", size: 14))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
            }
            
            // Success Message
            if let successMessage = successMessage {
                Text(successMessage)
                    .font(.custom("Outfit-Regular", size: 14))
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
            }
            
            // Reset Password Button
            ButtonView(title: "Send Reset Link", action: { Task {
                do {
                    try await viewModel.sendPasswordReset(toEmail: email)
                    errorMessage = nil
                    successMessage = "Password reset email sent successfully."
                } catch let error as NSError {
                    if let authError = AuthErrorCode(rawValue: error.code) {
                        switch authError {
                            case .invalidEmail:
                                errorMessage = "The email address is invalid."
                            default:
                                errorMessage = "An error occurred. Please try again."
                            }
                    } else {
                        errorMessage = "An unexpected error occurred. Please contact support."
                    }
                    successMessage = nil
                }
            }})
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Spacer()
            
            // Back Button
            Button(action: {
                dismiss() // Return to the previous screen
            }) {
                Text("Back to Login")
                    .font(.custom("Outfit-Bold", size: 17))
                    .foregroundColor(Color("primary"))
                    .underline()
            }
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ResetPasswordView()
}
