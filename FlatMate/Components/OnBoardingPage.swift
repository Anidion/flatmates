//
//  LandingPage.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct OnBoardingPage: View {
    @State private var opacityEffect: Bool = false
    @State private var clipEdges: Bool = false
    
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 313) // Adjust the image size as needed
                .clipShape(Circle())
            
            Text(title)
                .font(.custom("Outfit-Semibold", size: 34))
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Text(description)
                .font(.custom("Outfit-Regular", size: 16))
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    OnBoardingPage(imageName: "landingPageImage-1", title: "Live with like-minded people.", description: "It's easier than you think.")
}
