
//
//  Edit_Profile.swift
//
//
//  Created by Anshi on 2024-10-22.
//

import SwiftUI

let genders = ["Female", "Male", "Non-binary"]
let frequencies = ["Never", "Sometimes", "Always"]

struct EditProfileView: View {
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var age: String = ""
    @State private var bio: String = ""
    @State private var isSmoker: Bool = false
    @State private var pets: Bool = false
    @State private var selectedGender: String = genders[0]
    @State private var selectedPartyFrequency: String = frequencies[0]
    @State private var selectedGuestFrequency: String = frequencies[0]
    @State private var noiseTolerance: Double = 0.0 // Range from 0.0 to 1.0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 17) {
                    // Profile Picture
                    HStack {
                        
                        VStack{
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 80, height: 80)
                            
                            Button("+"){
                                
                            }
                            .frame(maxWidth: 20, maxHeight: 20)
                            .background(Color.gray)
                            .cornerRadius(20)
                        }
                        
                        // First Name, Last Name, Age
                        VStack(alignment: .leading) {
                            
                            HStack{
                                Text("First Name")
                                    .font(.custom("Outfit-Bold", fixedSize:15))
                                TextField("", text: $firstname)
                                    .textFieldStyle(.automatic)
                            }
                            Divider()
                            
                            HStack{
                                Text("Last Name")
                                    .font(.custom("Outfit-Bold", fixedSize:15))
                                TextField("", text: $lastname)
                                    .textFieldStyle(.automatic)
                            }
                            Divider()
                            
                            HStack{
                                Text("Age")
                                    .font(.custom("Outfit-Bold", fixedSize:15))
                                TextField("", text: $age)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(.automatic)
                                
                            }
                            Divider()
                        }
                    }
                    
                    // Gender Picker
                    VStack(alignment: .leading) {
                        Text(" Gender")
                            .font(.custom("Outfit-bold", fixedSize:15))
                        Picker("Select Gender", selection: $selectedGender) {
                            ForEach(genders, id: \.self) { gender in
                                Text(gender).tag(gender)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Divider()
                    }
                    
                    // Personal Bio
                    VStack(alignment: .leading) {
                        Text(" Personal Bio")
                            .font(.custom("Outfit-Bold", fixedSize:15))
                        TextEditor(text: $bio)
                            .frame(height: 30)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white))
                    }
                    Divider()
                    
                    // Smoker Toggle
                    Toggle("  I am a smoker.", isOn: $isSmoker)
                        .font(.custom("Outfit-Bold", fixedSize:15))
           
                    // Pets Allowed Toggle
                    Toggle("  I am a pet owner.", isOn: $pets)
                        .font(.custom("Outfit-Bold", fixedSize:15))
              
                    
                    // Party Frequency
                    VStack(alignment: .leading) {
                        Text("  How often do you host parties?")
                            .font(.custom("Outfit-Bold", fixedSize:15))
                        Picker("Parties", selection: $selectedPartyFrequency) {
                            ForEach(frequencies, id: \.self) { frequency in
                                Text(frequency).tag(frequency)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
              
                    
                    // Guest Frequency
                    VStack(alignment: .leading) {
                        Text("  How often do you have guests over?")
                            .font(.custom("Outfit-Bold", fixedSize:15))
                        Picker(" Guests", selection: $selectedGuestFrequency) {
                            ForEach(frequencies, id: \.self) { frequency in
                                Text(frequency).tag(frequency)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Noise Tolerance Slider
                    VStack(alignment: .leading) {
                        Text("  Noise Tolerance")
                            .font(.custom("Outfit-Bold", fixedSize:15))
                        HStack {
                            Text("Quiet")
                            Slider(value: $noiseTolerance, in: 0...1, step: 0.1)
                                .accentColor(.blue)
                            Text("Loud")
                        }
                    }
                   
                    
                    // Buttons
                    HStack {
                        ButtonView(title: "Ignore Changes", action: {})
                            .padding(.horizontal, 16)  // Reduce horizontal padding
                                
                               .font(.custom("Outfit-Bold", fixedSize:15))
                                .padding(10)

                        ButtonView(title: "Update Profile", action: {})
                             .padding(.horizontal, 16)
                               .font(.custom("Outfit-Bold", fixedSize:15))
                               .padding(10)
                        
                    }
                    .offset(y: -7)
                    
                }
                .navigationBarTitle("Edit Profile", displayMode: .large)
                
            }
        }
    }
    
    struct EditProfileView_Preview: PreviewProvider {
        static var previews: some View {
            EditProfileView()
        }
    }
}
