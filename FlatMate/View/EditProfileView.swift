//
//  Edit_Profile.swift
//
//
//  Created by Anshi on 2024-10-22.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

let genders = ["Select an option", "Female", "Male", "Non-binary", "Other"]
let frequencies = ["Never", "Sometimes", "Always"]

struct EditProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode // Add this environment property

    // Profile fields
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var dob: Date = Date()
    @State private var age: Int = 0 // This will be calculated from dob
    @State private var bio: String = ""
    @State private var isSmoker: Bool = false
    @State private var petsOk: Bool = false
    @State private var selectedGender: String = genders[0]
    @State private var selectedPartyFrequency: String = frequencies[0]
    @State private var selectedGuestFrequency: String = frequencies[0]
    @State private var noiseTolerance: Double = 0.0
    @State private var profileImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var errorMessage: String?
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Spacer()
                    Text("Edit Profile")
                        .font(.custom("Outfit-Bold", size: 28))
                    Divider()

                    // Profile Picture
                    HStack {
                        VStack {
                            ZStack {
                                if let image = profileImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 100, height: 100)
                                } else {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 100, height: 100)
                                }
                                PhotosPicker(
                                    selection: $selectedItem,
                                    matching: .images,
                                    photoLibrary: .shared()
                                ) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                        .background(Circle().fill(Color("primary")))
                                        .shadow(radius: 5)
                                }
                                .onChange(of: selectedItem) { oldValue, newValue in
                                    Task {
                                        if let data = try? await newValue?.loadTransferable(type: Data.self),
                                           let uiImage = UIImage(data: data) {
                                            profileImage = uiImage
                                        }
                                    }
                                }
                                .offset(x: 35, y: 35)
                            }
                        }
                        .padding(.trailing, 10)
                        // First Name, Last Name, Date of Birth
                        VStack(alignment: .leading) {
                            ProfileField(title: "First Name", text: $firstName)
                            ProfileField(title: "Last Name", text: $lastName)
                            DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                                .onChange(of: dob) { oldDob, newDob in
                                    age = calculateAge(from: newDob)
                                }
                        }
                    }

                    // Gender Picker
                    GenderPicker(selectedGender: $selectedGender)

                    // Personal Bio
                    VStack(alignment: .leading) {
                        Text("Personal Bio")
                            .font(.custom("Outfit-Bold", fixedSize: 15))
                        TextEditor(text: $bio)
                            .frame(height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    }
                    Divider()

                    // Toggles
                    Toggle("I am a smoker.", isOn: $isSmoker)
                        .font(.custom("Outfit-Bold", fixedSize: 15))
                        .tint(Color("primary"))
                    Divider()
                    Toggle("I am a pet owner.", isOn: $petsOk)
                        .font(.custom("Outfit-Bold", fixedSize: 15))
                        .tint(Color("primary"))
                    Divider()

                    // Party Frequency
                    VStack(alignment: .leading) {
                        Text("How often do you host parties?")
                            .font(.custom("Outfit-Bold", fixedSize: 15))
                        Picker("Parties", selection: $selectedPartyFrequency) {
                            ForEach(frequencies, id: \.self) { frequency in
                                Text(frequency).tag(frequency)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    // Guest Frequency
                    VStack(alignment: .leading) {
                        Text("How often do you have guests over?")
                            .font(.custom("Outfit-Bold", fixedSize: 15))
                        Picker("Guests", selection: $selectedGuestFrequency) {
                            ForEach(frequencies, id: \.self) { frequency in
                                Text(frequency).tag(frequency)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    // Noise Tolerance Slider
                    VStack(alignment: .leading) {
                        Text("Noise Tolerance")
                            .font(.custom("Outfit-Bold", fixedSize: 15))
                        HStack {
                            Text("Quiet")
                            Slider(value: $noiseTolerance, in: 0...5, step: 0.1)
                                .accentColor(Color("primary"))
                            Text("Loud")
                        }
                    }

                    // Update Button
                    HStack {
                        ButtonView(title: "Update", action: { updateProfile() })
                            .padding(.horizontal, 16)
                            .padding(.vertical, -10)
                    }
                    .offset(y: -7)
                }
                .padding(.horizontal, 25)
                .onAppear { fetchUserData() } // Load data when the view appears
            }
        }
    }

    // Fetch user data from Firebase
    private func fetchUserData() {
        guard let userID = viewModel.userSession?.uid else {
            errorMessage = "User not logged in"
            return
        }

        let userDocRef = Firestore.firestore().collection("users").document(userID)
        userDocRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                errorMessage = "Failed to fetch user data"
                return
            }

            guard let data = snapshot?.data() else {
                errorMessage = "User data not found"
                return
            }

            // Populate fields
            firstName = data["firstName"] as? String ?? ""
            lastName = data["lastName"] as? String ?? ""
            if let dobTimestamp = data["dob"] as? Timestamp {
                dob = dobTimestamp.dateValue()
                age = calculateAge(from: dob)
            }
            bio = data["bio"] as? String ?? ""
            isSmoker = data["isSmoker"] as? Bool ?? false
            petsOk = data["petsOk"] as? Bool ?? false
            selectedGender = data["gender"] as? String ?? genders[0]
            selectedPartyFrequency = data["partyFrequency"] as? String ?? frequencies[0]
            selectedGuestFrequency = data["guestFrequency"] as? String ?? frequencies[0]
            noiseTolerance = data["noise"] as? Double ?? 0.0

            if let imageURLString = data["profileImageURL"] as? String,
               let url = URL(string: imageURLString) {
                loadImage(from: url)
            }
        }
    }

    // Load image from URL
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    profileImage = image
                }
            }
        }.resume()
    }

    // Update profile data
    private func updateProfile() {
        Task {
            do {
                print("DEBUG - ", age)
                try await viewModel.updateProfile(
                    firstname: firstName,
                    lastname: lastName,
                    dob: dob,
                    age: age, // Send age to backend
                    bio: bio,
                    isSmoker: isSmoker,
                    pets: petsOk,
                    gender: selectedGender,
                    partyFrequency: selectedPartyFrequency,
                    guestFrequency: selectedGuestFrequency,
                    noiseTolerance: noiseTolerance,
                    profileImage: profileImage
                )
                errorMessage = nil
                presentationMode.wrappedValue.dismiss() // Dismiss view after successful update
            } catch {
                errorMessage = "Failed to update profile: \(error.localizedDescription)"
            }
        }
    }

    // Helper function to calculate age from date of birth
    private func calculateAge(from dob: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
        return ageComponents.year ?? 0
    }
}
