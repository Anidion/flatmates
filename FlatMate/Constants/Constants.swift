//
//  Constants.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-11-23.
//

import Foundation

struct Constants {
    struct PickerOptions {
        static let genders = ["Select an option", "Male", "Female", "Non-binary", "Other"]
        static let frequencies = ["Select an option", "Never", "Sometimes", "Always"]
        static let roomStates = ["Select an option", "I have a room", "I need a room"]
    }
    
    struct SliderRanges {
        static let noiseLevels: ClosedRange<Double> = 0.0...5.0
    }
}
