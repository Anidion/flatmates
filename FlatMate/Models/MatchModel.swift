//
//  MatchModel.swift
//  FlatMate
//
//  Created by Youssef Abdelrhafour on 2024-11-16.
//

//
//  MatchModel.swift
//  FlatMate
//

import Foundation

struct Match: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let messagePreview: String?
    
    static let sampleMatches: [Match] = [
        Match(name: "Alex Johnson", imageName: "person1", messagePreview: nil),
        Match(name: "Jamie Lee", imageName: "person2", messagePreview: "Looking forward to meeting you!"),
        Match(name: "Taylor Smith", imageName: "person3", messagePreview: "Can we schedule a call to discuss further?"),
        Match(name: "Chris Evans", imageName: "person4", messagePreview: "Hey! Are you still interested in the room?"),
        Match(name: "Morgan Brown", imageName: "person5", messagePreview: "Let’s finalize the agreement."),
    ]
}
