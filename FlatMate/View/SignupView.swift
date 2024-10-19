//
//  SignupView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 103)
                .padding(.bottom, 20)
            Text("Create Your Account")
                .font(.custom("Outfit-Bold", size: 28))
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
            VStack {
                InputView(text: .constant(""), title: "Username", placeholder: "name@example.com")
                InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
                InputView(text: .constant(""), title: "Password", placeholder: "name@example.com")
                InputView(text: .constant(""), title: "Confirm Password", placeholder: "***************")
                ButtonView(title: "Sign up", action: {})
            }
            .padding(.horizontal, 20)
            Spacer()
            Button {
                dismiss()
            } label: {
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
    }
}

#Preview {
    SignupView()
}
