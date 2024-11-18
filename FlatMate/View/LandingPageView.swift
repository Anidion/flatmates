import SwiftUI
import FirebaseFirestore

<<<<<<<< HEAD:FlatMate/View/LandingPageView.swift
private let landingSteps = [
    LandingPageStep(imageName: "landing1", title: "Live with like-minded people.", description: "It’s easier than you think."),
    LandingPageStep(imageName: "landing2", title: "Your Perfect Roommate is a Swipe Away", description: "Swipe right to like, left to pass. It’s that simple!"),
    LandingPageStep(imageName: "landing3", title: "Say Goodbye to Roommate Drama", description: "Find roommates who share your habits and lifestyle choices."),
    LandingPageStep(imageName: "landing4", title: "Meet Your Perfect Roommate Today", description: "FlatMate makes it easy to find the right person, fast.")
]

struct LandingPageView: View {
========
struct OnboardingPageView: View {
>>>>>>>> main:FlatMate/View/OnboardingPageView.swift
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
    @EnvironmentObject var viewModel: AuthViewModel
    var onComplete: () -> Void

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
        guard let userID = viewModel.userSession?.uid else { return }
        let data: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "dob": dob,
            "gender": gender,
            "bio": bio,
            "roomState": roomState,
            "smoker": smoker,
            "petsOk": petsOk,
            "noise": noise,
            "partyFreq": partyFreq,
            "guestFreq": guestFreq
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
<<<<<<<< HEAD:FlatMate/View/LandingPageView.swift
                Image("Logo Straight Blue")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 103)
                    .padding(.top, 15)
                    .padding(.bottom, 15)
                    .padding(.horizontal, 35)

                // Use the array-based ForEach
                TabView(selection: $currentStep) {
                    ForEach(Array(landingSteps.enumerated()), id: \.offset) { index, step in
                        step
                            .tag(index) // Assign the index as the tag
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack {
                    ForEach(landingSteps.indices, id: \.self) { index in
                        if index == currentStep {
                            Rectangle()
                                .frame(width: 20, height: 10)
                                .cornerRadius(10)
                                .foregroundStyle(Color("primary"))
                        } else {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(Color("primaryBackground"))
                        }
                    }
                }
========
                ZStack {
                    ForEach(0 ..< onboardingSteps.count, id: \.self) { index in
                        onboardingSteps[index]
                            .tag(index)
                            .opacity(index == self.currentStep ? 1 : 0)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
>>>>>>>> main:FlatMate/View/OnboardingPageView.swift

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

<<<<<<<< HEAD:FlatMate/View/LandingPageView.swift
                    // Next or Get Started Button
                    ButtonView(title: currentStep < landingSteps.count - 1 ? "Next" : "Get started", action: {
                        if self.currentStep < landingSteps.count - 1 {
                            self.currentStep += 1
                        } else {
                            // Trigger navigation to LoginView
                            self.showLogin = true
                        }
                    })
========
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
>>>>>>>> main:FlatMate/View/OnboardingPageView.swift
                }
                .padding(.horizontal, 30)
            }
            .padding()
        }
    }
}
