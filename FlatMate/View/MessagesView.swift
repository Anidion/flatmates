//
//  MessagesView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-25.
//

import SwiftUI

struct MessagesView: View {
    let matches = Match.sampleMatches
    
    var body: some View {
        VStack(alignment: .leading) {
            // Title
            Text("Matches")
                .font(.custom("Outfit-Bold", size: 38))
                .foregroundColor(Color("primary"))
                .padding(.horizontal)
            
            // List of Matches
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(matches) { match in
                        MatchRow(
                            name: match.name,
                            imageName: match.imageName,
                            messagePreview: match.messagePreview ?? "Start a conversation with \(match.name.components(separatedBy: " ").first ?? match.name)!"
                        )
                    }
                }
                .padding()
            }
            Spacer()
        }
        .navigationTitle("Messages")
    }
}

#Preview {
    MessagesView()
}
