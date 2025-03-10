//
//  MessageField.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

import SwiftUI

struct MessageField: View {
    @Binding var message: String
    var onSend: (String) -> Void // Notify parent to handle sending logic

    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("Enter your message here"), text: $message)
            Button {
                if !message.isEmpty {
                    onSend(message) // Send the message to the parent view
                    message = "" // Clear the text field after sending
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color("primary"))
                    .cornerRadius(50)
            }
        }
        .animation(.easeInOut, value: message.isEmpty)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color("primaryBackground"))
        .cornerRadius(50)
        .padding()
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

