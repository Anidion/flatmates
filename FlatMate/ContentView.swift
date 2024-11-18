//
//  ContentView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if let userSession = viewModel.userSession {
                if viewModel.hasCompletedOnboarding {
                    MainView()
                } else {
                    OnboardingPageView(onComplete: {
                        Task {
                            try? await viewModel.completeOnboarding()
                        }
                    })
                }
            } else {
                NavigationStack {
                    LandingPageView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

