//
//  LoginView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginActive = false // State to manage navigation

    var body: some View {
        NavigationView {
            VStack {
                // Logo Image
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 103)
                    .padding(.bottom, 20)

                // Welcome Text
                Text("Welcome Back")
                    .font(.custom("Outfit-Bold", size: 28))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)

                // Input Fields
                VStack {
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com", isSecureField: false)
                    InputView(text: $password, title: "Password", placeholder: "***************", isSecureField: true)
                    // Use ButtonView for "forget password" link button
                    HStack {
                        Spacer()
                        ButtonView(title: "Forgot Password?", action:{}, type: .link)
                    }
                    .padding(.top, -20)
                    .padding(.bottom, 20)
                   
                    // Use ButtonView for the Log In button
                    ButtonView(title: "Log In", action: {isLoginActive = true}, type: .standard)
                }
                .padding(.horizontal, 20)

                Spacer()

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
            .navigationBarHidden(true)
            // Add .navigationDestination here
            .navigationDestination(isPresented: $isLoginActive) {
                MainView()
            }
        }
    }
}

#Preview {
    LoginView()
}
