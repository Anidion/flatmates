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
    let hasCompletedOnboarding: Bool
}
