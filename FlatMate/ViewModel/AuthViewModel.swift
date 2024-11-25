//
//  AuthViewModel.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-11-14.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseStorage

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
        Task { await fetchUser() }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
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
            self.currentUser = user
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
    
    func fetchUser() async {
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
    
    func submitOnboardingData(
        firstName: String,
        lastName: String,
        dob: Date,
        gender: String,
        bio: String,
        roomState: String,
        isSmoker: Bool,
        petsOk: Bool,
        noise: Double,
        partyFrequency: String,
        guestFrequency: String,
        location: String,
        city: String,
        province: String,
        country: String,
        onComplete: @escaping () -> Void
    ) async throws {
        guard let userID = userSession?.uid else { return }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dob, to: Date())
        let age = ageComponents.year ?? 0 // Fallback to 0 if age cannot be calculated
        
        let data: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "dob": dob,
            "age": age, // Include the calculated age here
            "gender": gender,
            "bio": bio,
            "roomState": roomState,
            "isSmoker": isSmoker,
            "petsOk": petsOk,
            "noise": noise,
            "partyFrequency": partyFrequency,
            "guestFrequency": guestFrequency,
            "location": location,
            "city": city,          // Add city
            "province": province,  // Add province
            "country": country,    // Add country
        ]
        
        do {
            print("Saving onboarding data to Firebase...")
            try await Firestore.firestore().collection("users").document(userID).updateData(data)
            onComplete() // Notify the caller that the operation is complete
        } catch {
            print("DEBUG: Failed to save onboarding data with error \(error.localizedDescription)")
            throw error
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
    
    func updateProfile(
        firstname: String,
        lastname: String,
        dob: Date, // Updated to accept Date instead of age
        bio: String,
        isSmoker: Bool,
        pets: Bool,
        gender: String,
        partyFrequency: String,
        guestFrequency: String,
        noiseTolerance: Double,
        profileImage: UIImage?
    ) async throws {
        guard let uid = userSession?.uid else { throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]) }

        // Prepare updated data
        var updatedData: [String: Any] = [
            "firstName": firstname,
            "lastName": lastname,
            "dob": Timestamp(date: dob), // Store Date as Firestore Timestamp
            "bio": bio,
            "isSmoker": isSmoker,
            "pets": pets,
            "gender": gender,
            "partyFrequency": partyFrequency,
            "guestFrequency": guestFrequency,
            "noiseTolerance": noiseTolerance
        ]

        do {
            // Upload profile image if available
            if let profileImage = profileImage, let imageData = profileImage.jpegData(compressionQuality: 0.8) {
                let storageRef = Storage.storage().reference().child("profile_images/\(uid).jpg")
                let _ = try await storageRef.putDataAsync(imageData)
                let downloadURL = try await storageRef.downloadURL()
                updatedData["profileImageURL"] = downloadURL.absoluteString
            }

            // Update Firestore document
            try await Firestore.firestore().collection("users").document(uid).updateData(updatedData)

            // Update local `currentUser` with the new data
            if var currentUser = self.currentUser {
                currentUser.firstName = firstname
                currentUser.lastName = lastname
                currentUser.dob = dob // Update dob directly
                currentUser.bio = bio
                currentUser.isSmoker = isSmoker
                currentUser.pets = pets
                currentUser.gender = gender
                currentUser.partyFrequency = partyFrequency
                currentUser.guestFrequency = guestFrequency
                currentUser.noiseTolerance = noiseTolerance
                if let profileImageURL = updatedData["profileImageURL"] as? String {
                    currentUser.profileImageURL = profileImageURL
                }
                self.currentUser = currentUser
            }
        } catch {
            throw error
        }
    }
}
