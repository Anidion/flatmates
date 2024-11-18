//
//  AuthViewModel.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-11-14.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var hasCompletedOnboarding: Bool = false
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
            throw error // Propogate the error to the caller
        }
    }
    
    func createUser(withEmail email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, email: email, username: username, hasCompletedOnboarding: false)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error // Propagate the error
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // signs out user on backend
            self.userSession = nil // wipes out user session and takes use back to login screen
            self.currentUser = nil // wipes out current user data model
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func sendPasswordReset(toEmail email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("DEBUG: Failed to send password reset with error \(error.localizedDescription)")
            throw error // Propagate the error for the caller to handle
        }
    }
    
    func fetchUser() async throws {
        guard let uid = userSession?.uid else { return }
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            if let data = snapshot.data() {
                self.currentUser = try Firestore.Decoder().decode(User.self, from: data)
                self.hasCompletedOnboarding = self.currentUser?.hasCompletedOnboarding ?? false
            }
        } catch {
            print("DEBUG: Failed to fetch user data with error \(error.localizedDescription)")
        }
    }
    
    func completeOnboarding() async throws {
        guard let uid = userSession?.uid else { return }
        do {
            try await Firestore.firestore().collection("users").document(uid).updateData(["hasCompletedOnboarding": true])
            self.hasCompletedOnboarding = true
        } catch {
            print("DEBUG: Failed to update onboarding status with error \(error.localizedDescription)")
            throw error
        }
    }
}
