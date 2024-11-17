//
//  ButtonView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct ButtonView: View {
    enum ButtonType {
        case standard
        case outline
        case link
    }

    let title: String
    let action: () -> Void
    let type: ButtonType

    init(title: String, action: @escaping () -> Void, type: ButtonType = .standard) {
        self.title = title
        self.action = action
        self.type = type
    }

    var body: some View {
        Group {
            switch type {
                case .standard:
                    Button(action: {
                        self.action()
                    }) {
                        HStack {
                            Text(title)
                                .font(.custom("Outfit-Medium", size: 17))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 48)
                        }
                        .background(Color("primary"))
                        .cornerRadius(10)
                    }

                case .outline:
                    Button(action: {
                        self.action()
                    }) {
                        HStack {
                            Text(title)
                                .font(.custom("Outfit-Medium", size: 17))
                                .foregroundColor(Color("primary"))
                                .frame(maxWidth: .infinity, minHeight: 48)
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("primary"), lineWidth: 3)
                        )
                    }

                case .link:
                    Button(action: {
                        self.action()
                    }) {
                        Text(title)
                            .font(.custom("Outfit-Medium", size: 17))
                            .foregroundColor(Color("primary"))
                            .underline()
                    }
                }
        }
        .padding(EdgeInsets(top: type == .standard ? 24 : 0, leading: 0, bottom: 0, trailing: 0))
    }
}

#Preview {
    VStack(spacing: 16) {
        ButtonView(title: "Log In", action: {})
        ButtonView(title: "Forgot Password?", action: {}, type: .link)
    }
    .padding()
}
