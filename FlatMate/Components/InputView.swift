//
//  InputView.swift
//  AuthenticationPracticeApp
//
//  Created by 李吉喆 on 2024-10-08.
//

import SwiftUI

struct InputFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Outfit-ExtraLight", size: 17))
            .foregroundColor(.black)
            .padding(.all, 12)
            .background(Color("primaryBackground"))
            .cornerRadius(10)
    }
}

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Outfit-ExtraLight", size: 17))
                .padding(.bottom, -5)
            
            // Ternary operator to decide between SecureField and TextField
            (isSecureField ? AnyView(SecureField(placeholder, text: $text)
                                    .autocapitalization(.none)
                                    .modifier(InputFieldStyle()))
                            : AnyView(TextField(placeholder, text: $text)
                                    .autocapitalization(.none)
                                    .modifier(InputFieldStyle())))
        }
        .frame(maxWidth: .infinity, minHeight: 48) // Adjusted frame
//        .padding(.bottom, 20)
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com", isSecureField: false)
    InputView(text: .constant(""), title: "Password", placeholder: "***********", isSecureField: true)
}
