import SwiftUI

struct OnboardingPageView: View {
    @State private var currentStep = 0

    // Use these when you don't need these types in the input
    // Setting up optional bindings was not working so this is the workaround
    @State private var unusedDate = Date()
    @State private var unusedString = ""
    @State private var unusedBoolean = false
    @State private var unusedDouble = 0.0

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var dob: Date = .init()
    @State private var gender = ""
    @State private var bio = ""
    @State private var roomState = ""
    @State private var smoker = false
    @State private var petsOk = false
    @State private var noise = 0.0
    @State private var partyFreq = ""
    @State private var guestFreq = ""

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
                ]),
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
                        pickerOptions: genders),
                    ProgrammaticInput(
                        id: "bio", type: .multilineText, label: "Bio",
                        stringValue: $bio, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $unusedDouble,
                        placeholder: "Tell us something about yourself"),
                ]),
            OnboardingPage(
                title: "What do you need",
                description: "Tell us what you're looking for",
                inputs: [
                    ProgrammaticInput(
                        id: "roomState", type: .picker, label: "Room",
                        stringValue: $roomState, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $unusedDouble,
                        pickerOptions: ["I have a room", "I need a room"]),
                ]),
            OnboardingPage(
                title: "Your ideal roommate",
                description: "Describe your perfect roommate to us",
                inputs: [
                    ProgrammaticInput(
                        id: "smoker", type: .toggle, label: "Is a Smoker",
                        stringValue: $unusedString, dateValue: $unusedDate,
                        booleanValue: $smoker, doubleValue: $unusedDouble),
                    ProgrammaticInput(
                        id: "petsOk", type: .toggle, label: "Has Pets",
                        stringValue: $unusedString, dateValue: $unusedDate,
                        booleanValue: $petsOk, doubleValue: $unusedDouble),
                    ProgrammaticInput(
                        id: "noise", type: .slider, label: "Noise Level",
                        stringValue: $unusedString, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $noise,
                        sliderConfig: ProgrammaticInput.SliderConfiguration(
                            range: 0 ... 5, step: 0.5, minText: "Quiet", maxText: "Loud")),
                ]),
            OnboardingPage(
                title: "You as a roommate",
                description: "What are you like to live with?",
                inputs: [
                    ProgrammaticInput(
                        id: "partyFreq", type: .picker, label: "How often do you have parties",
                        stringValue: $partyFreq, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $unusedDouble,
                        pickerOptions: frequencies),
                    ProgrammaticInput(
                        id: "guestFreq", type: .picker, label: "How often do you have guests",
                        stringValue: $guestFreq, dateValue: $unusedDate,
                        booleanValue: $unusedBoolean, doubleValue: $unusedDouble,
                        pickerOptions: frequencies),
                ]),
        ]
    }

    func handleSubmit() {
        print("Submitted!")
        print(
            "First Name: \(firstName)", "Last Name: \(lastName)", "DOB: \(dob)", "Gender: \(gender)",
            "Bio: \(bio)", "Room State: \(roomState)", "Smoker: \(smoker)", "Pets OK: \(petsOk)",
            "Noise: \(noise)", "Party Freq: \(partyFreq)", "Guest Freq: \(guestFreq)")
    }

    func isStepComplete() -> Bool {
        switch currentStep {
            case 0:
                return firstName != "" && lastName != ""
            case 1:
                // Time interval is in seconds, we're just checking that the default date was changed to a date in the past
                return dob.timeIntervalSinceNow < -100 && gender != "" && bio != ""
            case 2:
                return roomState != ""
            case 3:
                return true
            case 4:
                return partyFreq != "" && guestFreq != ""
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
                                handleSubmit()
                            }
                        })
                        .disabled(!isStepComplete())
                }
                .padding(.horizontal, 30)
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingPageView()
}
