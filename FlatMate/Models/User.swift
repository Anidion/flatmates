//
//  User.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-11-14.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let username: String
    var firstName: String?
    var lastName: String?
    var age: String?
    var bio: String?
    var isSmoker: Bool?
    var pets: Bool?
    var gender: String?
    var partyFrequency: String?
    var guestFrequency: String?
    var noiseTolerance: Double?
    var profileImageURL: String?
    var firstName: String?
    var lastName: String?
    var dob: Date?
    var bio: String?
    var isSmoker: Bool?
    var pets: Bool?
    var gender: String?
    var partyFrequency: String?
    var guestFrequency: String?
    var noiseTolerance: Double?
    var profileImageURL: String?
    let hasCompletedOnboarding: Bool
}

