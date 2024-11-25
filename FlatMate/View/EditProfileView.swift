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

    // Profile fields
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var dob: Date = Date()
    @State private var age: String = "" // This will be calculated from dob
    @State private var bio: String = ""
    @State private var isSmoker: Bool = false
    @State private var pets: Bool = false
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
                                .onChange(of: selectedItem) { newItem in
                                    Task {
                                        if let data = try? await newItem?.loadTransferable(type: Data.self),
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
                            ProfileField(title: "First Name", text: $firstname)
                            ProfileField(title: "Last Name", text: $lastname)
                            DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                                .onChange(of: dob) { _ in
                                    age = calculateAge(from: dob)
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
                    Divider()
                    Toggle("I am a pet owner.", isOn: $pets)
                        .font(.custom("Outfit-Bold", fixedSize: 15))
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
                            Slider(value: $noiseTolerance, in: 0...1, step: 0.1)
                                .accentColor(.blue)
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
                .onAppear { loadProfileData() }
            }
        }
    }

    // Load user data from ViewModel
    private func loadProfileData() {
        if let user = viewModel.currentUser {
            firstname = user.firstName ?? ""
            lastname = user.lastName ?? ""
            dob = user.dob ?? Date()
            age = calculateAge(from: dob)
            bio = user.bio ?? ""
            isSmoker = user.isSmoker ?? false
            pets = user.pets ?? false
            selectedGender = user.gender ?? genders[0]
            selectedPartyFrequency = user.partyFrequency ?? frequencies[0]
            selectedGuestFrequency = user.guestFrequency ?? frequencies[0]
            noiseTolerance = user.noiseTolerance ?? 0.0
        }
    }

    // Update profile data
    private func updateProfile() {
        Task {
            do {
                try await viewModel.updateProfile(
                    firstname: firstname,
                    lastname: lastname,
                    dob: dob,
                    bio: bio,
                    isSmoker: isSmoker,
                    pets: pets,
                    gender: selectedGender,
                    partyFrequency: selectedPartyFrequency,
                    guestFrequency: selectedGuestFrequency,
                    noiseTolerance: noiseTolerance,
                    profileImage: profileImage
                )
                errorMessage = nil
            } catch {
                errorMessage = "Failed to update profile: \(error.localizedDescription)"
            }
        }
    }

    // Helper function to calculate age from date of birth
    private func calculateAge(from dob: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
        return "\(ageComponents.year ?? 0)"
    }
}

