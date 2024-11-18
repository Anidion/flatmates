//
//  MatchRow.swift
//  FlatMate
//
//  Created by Youssef Abdelrhafour on 2024-11-16.
//

import SwiftUI

struct MatchRow: View {
    let name: String
    let imageName: String
    let messagePreview: String
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                // Profile Image
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                
                // Name and Message Preview
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                    Text(messagePreview)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            .padding(.vertical, 10) // Adjust spacing within rows
            
            // Separator Line
            Divider()
        }
    }
}

#Preview {
    MatchRow(
        name: "Alex Johnson",
        imageName: "person1",
        messagePreview: "Hello!"
    )
}
