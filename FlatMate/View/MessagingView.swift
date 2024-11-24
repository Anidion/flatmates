//
//  MessagingView.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

// TODO: Change colours to match UI. Was not sure about colour choice as our theme is pretty dark.

import SwiftUI

struct MessagingView: View {
    @StateObject var viewModel: MessageViewModel // Dynamically created with currentUserID
    var chatID: String
    var currentUserID: String
    var receiverID: String

    @State private var newMessageText: String = ""

    init(chatID: String, currentUserID: String, receiverID: String) {
        self.chatID = chatID
        self.currentUserID = currentUserID
        self.receiverID = receiverID
        _viewModel = StateObject(wrappedValue: MessageViewModel())
    }

    var body: some View {
        VStack {
            // Title row at the top
            TitleRow()

            // Scrollable messages list
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.messages, id: \.id) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .onChange(of: viewModel.messages) { _ in // New message sends screen to bottom
                        if let lastMessage = viewModel.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                    .padding(.top, 10)
                    .background(Color.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                }
                .background(Color(.white))
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }

            // Message input field
            MessageField(message: $newMessageText) { text in
                viewModel.sendMessage(
                    chatID: chatID,
                    senderID: currentUserID,
                    receiverID: receiverID,
                    messageText: text
                )
            }
        }
        .background(Color("Gray"))
        // Displays all messages on appear
        .onAppear {
            print("MessagingView appeared for chatID: \(chatID)")
            viewModel.loadMessages(for: chatID)
        }
    }
}

// Preview for MessagingView
#Preview {
    MessagingView(chatID: "Test", currentUserID: "ruI196nXC1e06whgCwpBJiwOnNX2", receiverID: "1")
}
