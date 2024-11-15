import SwiftUI

struct OnboardingPage: View {
    var title: String
    var description: String
    var inputs: [ProgrammaticInput]

    var body: some View {
        VStack {
            Text(title)
                .font(.custom("Outfit-Semibold", size: 34))
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            Text(description)
                .font(.custom("Outfit-Regular", size: 18))
                .foregroundStyle(Color.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 10)

            Form {
                ForEach(inputs) { input in
                    input.render().listRowInsets(.init()).font(.custom("Outfit-Semibold", size: 28)).padding()
                }
            }
            .padding(.horizontal, -15)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
        }
        .padding()
    }
}