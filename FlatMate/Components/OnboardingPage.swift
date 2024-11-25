import SwiftUI

struct OnboardingPage: View {
    var title: String
    var description: String
    var inputs: [ProgrammaticInput]
    @Binding var showLocationSearch: Bool // Add this for location-specific pages
    
    // Add a default value for showLocationSearch
    init(
        title: String,
        description: String,
        inputs: [ProgrammaticInput],
        showLocationSearch: Binding<Bool> = .constant(false) // Default to false
    ) {
        self.title = title
        self.description = description
        self.inputs = inputs
        self._showLocationSearch = showLocationSearch
    }
    
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
                    input.render()
                        .listRowInsets(.init())
                        .font(.custom("Outfit-Semibold", size: 28))
                        .padding()
                        .onTapGesture {
                            // If the input is for location, trigger the location search sheet
                            if input.id == "location" {
                                print("Tapped location field") // Debugging log
                                showLocationSearch = true
                            }
                        }
                }
            }
            .padding(.horizontal, -15)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
        }
        .padding()
    }
}
