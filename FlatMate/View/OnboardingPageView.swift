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
    @State private var location = ""
    @State private var showLocationSearch = false // State to control location search sheet
    
    @EnvironmentObject var viewModel: AuthViewModel
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
    
    func isStepComplete() -> Bool {
        switch currentStep {
        case 0:
            return firstName != "" && lastName != ""
        case 1:
            // Time interval is in seconds, we're just checking that the default date was changed to a date in the past
            guard let age = age else { return false }
            return dob.timeIntervalSinceNow < -100 && gender != Constants.PickerOptions.genders[0] && bio != "" && age > 0
        case 2:
            return roomState != Constants.PickerOptions.roomStates[0]
        case 3:
            return true
        case 4:
            return partyFrequency != Constants.PickerOptions.frequencies[0] && guestFrequency != Constants.PickerOptions.frequencies[0]
        case 5:
            return location != ""
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
                                        onComplete: onComplete
                                    )
                                }
                            }
                        })
                    .disabled(!isStepComplete())
                }
                .padding(.horizontal, 30)
                .sheet(isPresented: $showLocationSearch) {
                    LocationSearchView(selectedLocation: $location)
                }
            }
            .padding()
        }
    }
}
