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

    // The data model for each card
    struct Model: Identifiable, Equatable, Codable {
        let id: String
        let firstName: String
        let age: Int
        let gender: String
        let bio: String
        let roomState: String
        let location: String
        let profileImageURL: String?
        let isSmoker: Bool
        let petsOk: Bool
        let noiseTolerance: Double
        let partyFrequency: String
        let guestFrequency: String

        // We store swipeDirection (left, right, none) so we can track or animate it
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


    let profile: Model
    let size: CGSize
    let dragOffset: CGSize
    let isTopCard: Bool
    let isSecondCard: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // The top image portion
            ZStack(alignment: .bottomLeading) {
                
                //    Display a spinner placeholder while it loads, then fade it in.
                if let profileImageURL = profile.profileImageURL,
                   let url = URL(string: profileImageURL) {
                    
                    AsyncImage(url: url, transaction: Transaction(animation: .easeIn)) { phase in
                        switch phase {
                        case .empty:
                            // Show a loading spinner while fetching
                            ProgressView()
                                .frame(width: size.width, height: size.height * 0.65)
                                .background(Color.gray.opacity(0.3))
                            
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width, height: size.height * 0.65)
                                .clipShape(Rectangle())
                                .transition(.opacity)
                            
                        case .failure:
                            // If the image fails to load, show a placeholder
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: size.width, height: size.height * 0.65)
                                .foregroundColor(.gray)
                                .background(Color.gray.opacity(0.2))
                            
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                } else {
                    // if there's no profileImageURL, show a default placeholder
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size.width, height: size.height * 0.65)
                        .foregroundColor(.gray)
                        .background(Color.gray.opacity(0.2))
                }

                // The overlay: name, age, location, etc. inside a thin blur
                VStack(alignment: .leading) {
                    Text("\(profile.firstName), \(profile.age)")
                        .font(.custom("Outfit-Bold", size: 32))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .foregroundColor(.black)
                    
                    Text(profile.gender)
                        .foregroundColor(.black)
                    
                    Text("\(profile.roomState) in \(profile.location)")
                        .foregroundColor(.black)
                }
                .padding()
                .background(.ultraThinMaterial)
            }

            // bio and icons
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
        // Card styling
        .background(Color.white)
        .cornerRadius(20)
        .shadow(
            color: isTopCard
                ? getShadowColor()
                : (isSecondCard && dragOffset.width != 0 ? Color.gray.opacity(0.2) : Color.clear),
            radius: 10, x: 0, y: 3
        )
    }
    

    
    // Return a colored shadow on drag: green if swiping right, red if swiping left
    private func getShadowColor() -> Color {
        if dragOffset.width > 0 {
            return Color.green
        } else if dragOffset.width < 0 {
            return Color.red
        } else {
            return Color.gray.opacity(0.2)
        }
    }
    
    private func renderTextWithEmoji(_ emoji: String, _ text: String) -> HStack<TupleView<(Text, Text)>> {
        HStack(alignment: .top, spacing: 15) {
            Text(emoji)
            Text(text)
        }
    }

    // the noise value as text + emoji
    private func renderNoiseTolerance(_ noiseTolerance: Double) -> HStack<TupleView<(Text, Text)>> {
        if noiseTolerance < 3 {
            return renderTextWithEmoji(noiseTolerance > 0 ? "✅" : "🚫", "Noise")
        }
        return renderTextWithEmoji("🔊", "Unbothered by noise")
    }

    // the partyFrequency as text + emoji
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

    // the guestFrequency as text + emoji
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
}
