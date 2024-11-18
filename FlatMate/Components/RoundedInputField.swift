//
//  RoundedInputField.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct RoundedInputField: View {
    @State private var username: String = ""
    
    var body: some View {
        TextField("Username", text: $username)
            .padding()
            .background(Color(.systemGray6)) // Light gray background
            .cornerRadius(1000) // Rounded corners
            .padding(.horizontal, 20) // Extra horizontal padding
            .font(.system(size: 18)) // Adjust font size
            .foregroundColor(.gray) // Text color
    }
}
