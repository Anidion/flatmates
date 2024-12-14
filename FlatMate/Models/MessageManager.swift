//
//  MessageManager.swift
//  FlatMate
//
//  Created by Joey on 2024-11-20.
//

import Foundation
import FirebaseFirestore

private let db = Firestore.firestore()

class MessageManager: ObservableObject {
    
    // Adds a message to the database
    func sendMessage(chatID: String, senderID:String, receiverID: String, messageText: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // Organize message data to be sent
        let messageData: [String: Any] = [
            "senderID": senderID,
            "receiverID": receiverID,
            "messageText": messageText,
            "timestamp": FieldValue.serverTimestamp(), // Automatically set the timestamp
            "read": false] // Mark the message as unread
        
        // Add message to chat's collection
        db.collection("chats").document(chatID).collection("messages")
            .addDocument(data: messageData) {
                error in
                if let error = error {
                    completion(.failure(error))
                    print("Message error")
                } else {
                    completion(.success(()))
                }
            }
    }
    
    
    func observeMessages(chatID: String, completion: @escaping (Result<[Message], Error>) -> Void) -> ListenerRegistration {
        let query = db.collection("chats")
            .document(chatID)
            .collection("messages")
            .order(by: "timestamp", descending: false)

        return query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let documents = snapshot?.documents {
                let messages: [Message] = documents.compactMap { doc in
                    guard
                        let senderID = doc["senderID"] as? String,
                        let receiverID = doc["receiverID"] as? String,
                        let messageText = doc["messageText"] as? String,
                        let timestamp = doc["timestamp"] as? Timestamp,
                        let read = doc["read"] as? Bool
                    else { return nil }

                    return Message(
                        id: doc.documentID,
                        senderID: senderID,
                        receiverID: receiverID,
                        text: messageText,
                        read: read,
                        timestamp: timestamp.dateValue()
                    )
                }
                completion(.success(messages))
            }
        }
    }    
}
