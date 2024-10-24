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
    @State private var isSmoker: Bool = false
    @State private var pets: Bool = false
    @State private var selectedGender: String = genders[0]
    @State private var selectedPartyFrequency: String = frequencies[0] // Default frequency
    @State private var selectedGuestFrequency: String = frequencies[0] // Default frequency
    @State private var noiseTolerance: Double = 0.0 // Range from 0.0 to 1.0
    
    var body: some View {
        NavigationView {
            
            Form{
                // First Name Text Field
                TextField("First Name", text: $firstname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Last Name", text: $lastname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Age", text: $age)
                    .keyboardType(.numberPad) // age is typed using number pad
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Picker("Gender", selection: $selectedGender){
                    Text("Female").tag("Female")
                    Text("Male").tag("Male")
                    Text("Non-binary").tag("Non-binary")
                }
                TextField("Personal Bio", text: $age)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 50) // Set the height of the text field
               
                Toggle("Smoker", isOn: $isSmoker)
                    .padding()
                Toggle("Pets Allowed", isOn: $pets)
                    .padding()
                
                Picker("Parties", selection: $selectedPartyFrequency){
                    Text("Never").tag("Never")
                    Text("Sometimes").tag("Sometimes")
                    Text("Always").tag("Always")
                }
                Text("How often do you host parties?")
                    .font(.footnote)
                    .padding(.horizontal)
                
                
                Picker("Guests", selection: $selectedGuestFrequency){
                    Text("Never").tag("Never")
                    Text("Sometimes").tag("Sometimes")
                    Text("Always").tag("Always")
                }
                
                Text("How often do you have guests over?")
                    .font(.footnote)
                    .padding(.horizontal)
                
                VStack {
                    Text("Noise Tolerance")
                    .font(.headline) // Set a larger font for the title
                    HStack {
                    Slider(value: $noiseTolerance, in: 0...1, step: 0.1)
                    .accentColor(.blue)
                    }
                    .padding()
                
                
            }
            .naviagtionBarTitle("Edit Profile", displayMode: .large)
        }
        
    }
}



struct EditProfileView_Preview: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


