//
//  ProfileCardView.swift
//  FlatMate
//
//  Created by Ben Schmidt on 2024-10-20.
//

import SwiftUI

struct ProfileCardView: View {
    enum SwipeDirection {
        case left, right, none
    }

    struct Model: Identifiable, Equatable, Codable {
        let id: String
        let firstName: String
        let age: Int
        let gender: String
        let bio: String
        let roomState: String
        let location: String
        let profileImageURL: String? // Now optional
        let isSmoker: Bool
        let petsOk: Bool
        let noiseTolerance: Double
        let partyFrequency: String
        let guestFrequency: String
        var swipeDirection: SwipeDirection = .none

        enum CodingKeys: String, CodingKey {
            case id
            case firstName
            case age
            case gender
            case bio
            case roomState
            case location
            case profileImageURL
            case isSmoker
            case petsOk
            case noiseTolerance = "noise"
            case partyFrequency
            case guestFrequency
        }
    }

    private func renderTextWithEmoji(_ emoji: String, _ text: String) -> HStack<TupleView<(Text, Text)>> {
        HStack(alignment: .top, spacing: 15) {
            Text(emoji)
            Text(text)
        }
    }

    private func renderNoiseTolerance(_ noiseTolerance: Double) -> HStack<TupleView<(Text, Text)>> {
        if noiseTolerance < 3 {
            return renderTextWithEmoji(noiseTolerance > 0 ? "✅" : "🚫", "Noise")
        }
        return renderTextWithEmoji("🔊", "Unbothered by noise")
    }

    private func renderPartying(_ partyFrequency: String) -> HStack<TupleView<(Text, Text)>> {
        switch partyFrequency {
        case "Always":
            return renderTextWithEmoji("🪩", "Party Animal")
        case "Sometimes":
            return renderTextWithEmoji("✅", "Partying")
        default:
            return renderTextWithEmoji("🚫", "No Parties")
        }
    }

    private func renderGuests(_ guestFrequency: String) -> HStack<TupleView<(Text, Text)>> {
        switch guestFrequency {
        case "Always":
            return renderTextWithEmoji("🧑‍🤝‍🧑", "Loves Guests")
        case "Sometimes":
            return renderTextWithEmoji("✅", "Occasional Guests")
        default:
            return renderTextWithEmoji("🚫", "No Guests")
        }
    }

    var profile: Model
    var size: CGSize
    var dragOffset: CGSize
    var isTopCard: Bool
    var isSecondCard: Bool

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                if let profileImageURL = profile.profileImageURL, let url = URL(string: profileImageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width, height: size.height * 0.65)
                            .clipShape(Rectangle())
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    // Default placeholder for users without a profile image
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size.width, height: size.height * 0.65)
                        .foregroundColor(.gray)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Rectangle())
                }

                VStack(alignment: .leading) {
                    Text("\(profile.firstName), \(profile.age)")
                        .font(.custom("Outfit-Bold", size: 32))
                        .colorInvert()
                    Text(profile.gender).colorInvert()
                    Text("\(profile.roomState) in \(profile.location)").colorInvert()
                }
                .padding()
                .background(.ultraThinMaterial)
            }

            VStack(alignment: .leading, spacing: 6) {
                renderTextWithEmoji("🗣️", "“\(profile.bio)“")
                    .padding(.bottom)
                renderTextWithEmoji(profile.isSmoker ? "🚬" : "🚭", "\(profile.isSmoker ? "" : "No") Smoking")
                renderTextWithEmoji(profile.petsOk ? "🐾" : "🚫", "\(profile.petsOk ? "Yes" : "No") Pets")
                renderNoiseTolerance(profile.noiseTolerance)
                renderPartying(profile.partyFrequency)
                renderGuests(profile.guestFrequency)
            }
            .padding()
        }
        .frame(width: size.width, height: size.height)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: isTopCard ? getShadowColor() : (isSecondCard && dragOffset.width != 0 ? Color.gray.opacity(0.2) : Color.clear), radius: 10, x: 0, y: 3)
    }

    private func getShadowColor() -> Color {
        if dragOffset.width > 0 {
            return Color.green
        } else if dragOffset.width < 0 {
            return Color.red
        } else {
            return Color.gray.opacity(0.2)
        }
    }
}
