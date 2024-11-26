//
//  SwipePageView.swift
//  FlatMate
//
//  Created by Ben Schmidt on 2024-10-20.
//

import SwiftUI

struct SwipePageView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = SwipeViewModel()
    @State private var userID: String = ""
    @State private var lastMatch: ProfileCardView.Model? = nil
    @State private var thisUser: User?
    @State private var matchConfirmed: Bool = false

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading Profiles...")
            } else if viewModel.profiles.isEmpty {
                Text("No profiles available.")
            } else if matchConfirmed && lastMatch != nil {
                YouMatchedView(isOpen: $matchConfirmed, thisUser: thisUser!, otherUser: lastMatch!)
            } else {
                let swipeModel = SwipeCardsView.Model(cards: viewModel.profiles)
                SwipeCardsView(model: swipeModel) { model in
                    print("SwipeCardsView action triggered") // Debug print

                    // Debug currentCard and lastSwipeDirection
                    print("currentCard: \(String(describing: model.currentCard?.firstName))")
                    print("lastSwipeDirection: \(String(describing: model.lastSwipeDirection))")

                    handleSwipe(card: model.currentCard, direction: model.lastSwipeDirection)
                }
            }
        }
        .onAppear {
            userID = authViewModel.userSession?.uid ?? ""
            viewModel.fetchProfiles()
            thisUser = authViewModel.currentUser
        }
        .animation(.easeInOut, value: matchConfirmed)
    }

    private func handleSwipe(card: ProfileCardView.Model?, direction: ProfileCardView.SwipeDirection?) {
        guard let card = card, let direction = direction else {
            print("Invalid swipe: card or direction is nil")
            return
        }

        let isLike = direction == .right
        print("Handling swipe for \(card.firstName), direction: \(direction)")

        viewModel.handleSwipe(userID: userID, targetUserID: card.id, isLike: isLike) { isMatch in
            print("Swipe handled for \(card.firstName), isMatch: \(isMatch)")
            if isMatch {
                lastMatch = card
                matchConfirmed = isMatch
            } else {
                matchConfirmed = false
                lastMatch = nil
            }
        }
    }
}
