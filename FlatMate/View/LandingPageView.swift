import SwiftUI

private let onboardingSteps = [
    LandingPageStep(imageName: "landingPageImage-1", title: "Live with like-minded people.", description: "It’s easier than you think."),
    LandingPageStep(imageName: "landingPageImage-2", title: "Your Perfect Roommate is a Swipe Away", description: "Swipe right to like, left to pass. It’s that simple!"),
    LandingPageStep(imageName: "landingPageImage-3", title: "Say Goodbye to Roommate Drama", description: "Find roommates who share your habits and lifestyle choices."),
    LandingPageStep(imageName: "landingPageImage-4", title: "Meet Your Perfect Roommate Today", description: "FlatMate makes it easy to find the right person, fast.")
]

struct LandingPageView: View {
    @State private var currentStep = 0
    @State private var showLogin = false // State variable to control navigation

    var body: some View {
        NavigationStack {
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 103)
                    .padding(.bottom, 20)

                // Use the array-based ForEach
                TabView(selection: $currentStep) {
                    ForEach(Array(onboardingSteps.enumerated()), id: \.offset) { index, step in
                        step
                            .tag(index) // Assign the index as the tag
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack {
                    ForEach(onboardingSteps.indices, id: \.self) { index in
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

                HStack(spacing: 30) {
                    // Previous Button
                    ButtonView(title: "Previous", action: {
                        if self.currentStep > 0 {
                            self.currentStep -= 1
                        }
                    }, type: .standard)
                    .disabled(currentStep == 0) // Disable on the first page

                    // Next or Get Started Button
                    ButtonView(title: currentStep < onboardingSteps.count - 1 ? "Next" : "Get started", action: {
                        if self.currentStep < onboardingSteps.count - 1 {
                            self.currentStep += 1
                        } else {
                            // Trigger navigation to LoginView
                            self.showLogin = true
                        }
                    })
                }
                .padding(.horizontal, 30)

                // Use the new navigationDestination method
                .navigationDestination(isPresented: $showLogin) {
                    LoginView().navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    LandingPageView()
}
