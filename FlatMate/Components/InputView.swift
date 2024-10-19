//
//  InputView.swift
//  AuthenticationPracticeApp
//
//  Created by 李吉喆 on 2024-10-08.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Outfit-ExtraLight", size: 17))
                .padding(.bottom, -5)
            
            TextField(placeholder, text: $text)
                .font(.custom("Outfit-ExtraLight", size: 17))
                .padding(.all, 12)
                .background(Color("primaryBackground")) // Using the custom color
                .cornerRadius(10) // Rounded corners

                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 48) // Adjusted frame
        .padding(.bottom, 20)
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
}
