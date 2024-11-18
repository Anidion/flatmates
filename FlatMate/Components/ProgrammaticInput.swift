import SwiftUI

enum InputType {
    case text
    case multilineText
    case date
    case picker
    case toggle
    case slider
}

struct ProgrammaticInput: Identifiable {
    struct SliderConfiguration {
        let range: ClosedRange<Double>
        let step: Double
        let minText: String
        let maxText: String
    }

    var id: String
    var type: InputType
    var label: String
    @Binding var stringValue: String
    @Binding var dateValue: Date
    @Binding var booleanValue: Bool
    @Binding var doubleValue: Double
    var pickerOptions: [String]? = nil
    var placeholder: String? = nil
    var sliderConfig: SliderConfiguration? = nil

    @ViewBuilder func render() -> some View {
        switch type {
            case .text:
                TextField(placeholder ?? label, text: $stringValue)
                    .textFieldStyle(DefaultTextFieldStyle())
            case .multilineText:
                TextField(placeholder ?? label, text: $stringValue, axis: .vertical)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .lineLimit(2 ... 10)
            case .date:
                DatePicker(label, selection: $dateValue, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
            case .picker:
                Picker(label, selection: $stringValue) {
                    ForEach(pickerOptions ?? [], id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
            case .toggle:
                Toggle(label, isOn: $booleanValue)
                    .toggleStyle(.switch)
                    .tint(Color("primary"))
            case .slider:
                VStack {
                    Text(label).frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text(sliderConfig?.minText ?? "").font(.custom("Outfit-Regular", size: 18))
                        Slider(value: $doubleValue, in: sliderConfig?.range ?? 0 ... 1, step: sliderConfig?.step ?? 0.1)
                            .accentColor(Color("primary"))
                        Text(sliderConfig?.maxText ?? "").font(.custom("Outfit-Regular", size: 18))
                    }
                }
                .frame(alignment: .topTrailing)
        }
    }
}
