//
//  ButtonView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct ButtonView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {action: do {
            self.action()
        }} label: {
            HStack {
                Text(title)
                    .font(.custom("Outfit-Medium", size: 17))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 48) // Adjusted frame
        }
        .background(Color("primary"))
        .cornerRadius(10)
        .padding(.top, 24)
    }
}

#Preview {
    ButtonView(title: "Log In", action: {})
}
