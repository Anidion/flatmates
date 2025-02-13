import SwiftUI
import FirebaseFirestore

import SwiftUI
import FirebaseFirestore

struct OnboardingPageView: View {
    @State private var currentStep = 0
    
    // Use these when you don't need these types in the input
    @State private var unusedDate = Date()
    @State private var unusedString = ""
    @State private var unusedBoolean = false
    @State private var unusedDouble = 0.0
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var dob: Date = .init()
    @State private var gender = Constants.PickerOptions.genders[0] // Default value: "Select an option"
    @State private var bio = ""
    @State private var roomState = Constants.PickerOptions.roomStates[0] // Default value: "Select an option"
    @State private var isSmoker = false
    @State private var petsOk = false
    @State private var noise = 0.0
    @State private var partyFrequency = Constants.PickerOptions.frequencies[0] // Default value: "Select an option"
    @State private var guestFrequency = Constants.PickerOptions.frequencies[0] // Default value: "Select an option"
    @State private var location = "" // The selected location's name
    @State private var city = ""     // The selected city
    @State private var province = "" // The selected province/state
    @State private var country = ""  // The selected country
    @State private var showLocationSearch = false // State to control location search sheet
    @EnvironmentObject var viewModel: AuthViewModel
    
    //Alerts for invalid input
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var onComplete: () -> Void
    private var age: Int? {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
        return ageComponents.year
    }
    
    private var onboardingSteps: [OnboardingPage] {
        [
            OnboardingPage(
                title: "Name",
                description: "What do people call you?",
                inputs: [
                    ProgrammaticInput(
                        id: "firstName", type: .text, label: "First Name",
                        stringValue: $firstName, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $unusedDouble),
                    ProgrammaticInput(
                        id: "lastName", type: .text, label: "Last Name",
                        stringValue: $lastName, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $unusedDouble),
                ]
            ),
            OnboardingPage(
                title: "Personal Details",
                description: "Let's get to know you a little better",
                inputs: [
                    ProgrammaticInput(
                        id: "dob", type: .date, label: "Birthday",
                        stringValue: $unusedString, dateValue: $dob,
                        booleanValue: $unusedBoolean, doubleValue: $unusedDouble),
                    ProgrammaticInput(
                        id: "gender", type: .picker, label: "Gender",
                        stringValue: $gender, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $unusedDouble,
                        pickerOptions: Constants.PickerOptions.genders),
                    ProgrammaticInput(
                        id: "bio", type: .multilineText, label: "Bio",
                        stringValue: $bio, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $unusedDouble,
                        placeholder: "Tell us something about yourself"),
                ]
            ),
            OnboardingPage(
                title: "What do you need",
                description: "Tell us what you're looking for",
                inputs: [
                    ProgrammaticInput(
                        id: "roomState", type: .picker, label: "Room",
                        stringValue: $roomState, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $unusedDouble,
                        pickerOptions: Constants.PickerOptions.roomStates),
                ]
            ),
            OnboardingPage(
                title: "Your ideal roommate",
                description: "Describe your perfect roommate to us",
                inputs: [
                    ProgrammaticInput(
                        id: "smoker", type: .toggle, label: "Is a Smoker",
                        stringValue: $unusedString, dateValue: $unusedDate,
                        booleanValue: $isSmoker, doubleValue: $unusedDouble),
                    ProgrammaticInput(
                        id: "petsOk", type: .toggle, label: "Has Pets",
                        stringValue: $unusedString, dateValue: $unusedDate,
                        booleanValue: $petsOk, doubleValue: $unusedDouble),
                    ProgrammaticInput(
                        id: "noise", type: .slider, label: "Noise Level",
                        stringValue: $unusedString, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $noise,
                        sliderConfig: ProgrammaticInput.SliderConfiguration(
                            range: Constants.SliderRanges.noiseLevels,
                            step: 0.5, minText: "Quiet", maxText: "Loud")),
                ]
            ),
            OnboardingPage(
                title: "You as a roommate",
                description: "What are you like to live with?",
                inputs: [
                    ProgrammaticInput(
                        id: "partyFreq", type: .picker, label: "How often do you have parties",
                        stringValue: $partyFrequency, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $unusedDouble,
                        pickerOptions: Constants.PickerOptions.frequencies),
                    ProgrammaticInput(
                        id: "guestFreq", type: .picker, label: "How often do you have guests",
                        stringValue: $guestFrequency, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $unusedDouble,
                        pickerOptions: Constants.PickerOptions.frequencies),
                ]
            ),
            OnboardingPage(
                title: "Location",
                description: "Where are you currently located?",
                inputs: [
                    ProgrammaticInput(
                        id: "location",
                        type: .text,
                        label: "City",
                        stringValue: $location,
                        dateValue: $unusedDate,
                        booleanValue: $unusedBoolean,
                        doubleValue: $unusedDouble,
                        placeholder: "Tap to select your city",
                        onTap: {
                            showLocationSearch = true // Trigger the location search sheet
                        }
                    ),
                ]
            )
        ]
    }
    
    func handleSubmit() {
        guard let userID = viewModel.userSession?.uid else { return }
        let data: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "dob": dob,
            "gender": gender,
            "bio": bio,
            "roomState": roomState,
            "isSmoker": isSmoker,
            "petsOk": petsOk,
            "noise": noise,
            "partyFrequency": partyFrequency,
            "guestFrequency": guestFrequency
        ]
        Firestore.firestore().collection("users").document(userID).updateData(data) { error in
            if let error = error {
                print("DEBUG: Failed to save onboarding data with error \(error.localizedDescription)")
            } else {
                onComplete()
            }
        }
    }

    func isStepComplete() -> Bool {
        switch currentStep {
            case 0:
                if(firstName == "" || lastName == ""){
                    alertMessage = "Please enter your first and last name."
                    return false
                }
                return true
            case 1: // Verify age > 18YO.
                let calendar = Calendar.current
                let now = Date()
                let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
                let age = ageComponents.year ?? 0
            
                if (age <= 18){
                    alertMessage = "Must be over 18 to sign up"
                    return false
                }
                else if (gender == Constants.PickerOptions.genders[0]){
                    alertMessage = "Please specify gender"
                    return false
                }
                else if (bio == ""){
                    alertMessage = "Please fill out bio"
                    return false
                }
                return true
            case 2:
                if (roomState == Constants.PickerOptions.roomStates[0]){
                    alertMessage = "Please select an option"
                    return false
                }
                return true
            case 3:
                return true
            case 4:
                if (partyFrequency == Constants.PickerOptions.frequencies[0]){
                    alertMessage = "Please select a party frequency option"
                    return false
                }
                else if (guestFrequency == Constants.PickerOptions.frequencies[0]){
                    alertMessage = "Please select a guest frequency option"
                    return false
                }
                return true
            case 5:
                if (location == ""){
                    alertMessage = "Please select a location"
                    return false
                }
                return true
            default:
                return false
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    ForEach(0 ..< onboardingSteps.count, id: \.self) { index in
                        onboardingSteps[index]
                            .tag(index)
                            .opacity(index == self.currentStep ? 1 : 0)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 30) {
                    // Previous Button
                    ButtonView(
                        title: "Previous",
                        action: {
                            if self.currentStep > 0 {
                                self.currentStep -= 1
                            }
                        }, type: .outline)
                    .opacity(self.currentStep == 0 ? 0 : 1) // Hide on first page
                    
                    ButtonView(
                        title: self.currentStep == onboardingSteps.count - 1 ? "Submit" : "Next",
                        action: {
                            if !isStepComplete() {
                                showAlert = true
                                return
                            }
                            if self.currentStep < onboardingSteps.count - 1 {
                                self.currentStep += 1
                            } else {
                                Task {
                                    try? await viewModel.submitOnboardingData(
                                        firstName: firstName,
                                        lastName: lastName,
                                        dob: dob,
                                        gender: gender,
                                        bio: bio,
                                        roomState: roomState,
                                        isSmoker: isSmoker,
                                        petsOk: petsOk,
                                        noise: noise,
                                        partyFrequency: partyFrequency,
                                        guestFrequency: guestFrequency,
                                        location: location,
                                        city: city,          // Add city
                                        province: province,  // Add province
                                        country: country,    // Add country
                                        onComplete: onComplete
                                    )
                                }
                            }
                        })
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Incomplete Step"),
                              message:Text(alertMessage),
                              dismissButton: .default(Text("OK")))
                    }
                }
                .padding(.horizontal, 30)
                .sheet(isPresented: $showLocationSearch) {
                    LocationSearchView(
                        selectedLocation: $location,
                        city: $city,
                        province: $province,
                        country: $country
                    )
                }
            }
            .padding()
        }
    }
}

