import Foundation
import FirebaseAuth

class MessagesViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var isLoading: Bool = false
    @Published var currentUserID: String? // Store the current user ID
    
    init() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Error: No authenticated user found during initialization.")
            self.currentUserID = nil
            return
        }
        self.currentUserID = uid
        loadMatches()
    }
    
    // Fetches matches and updates state
    func loadMatches() {
        guard let currentUserID = self.currentUserID else {
            print("Error: currentUserID is nil")
            isLoading = false
            return
        }
        
        isLoading = true
        
        Match.fetchMatches { [weak self] fetchedMatches in
            DispatchQueue.global().async {
                let updatedMatches = fetchedMatches.map { match -> Match in
                    var matchWithChatID = match
                    
                    // Use MatchModel's fetchChatID directly
                    Match.fetchChatID(user1: currentUserID, user2: match.id) { chatID in
                        DispatchQueue.main.async {
                            matchWithChatID.chatID = chatID
                        }
                    }
                    
                    return matchWithChatID
                }
                
                DispatchQueue.main.async {
                    self?.matches = updatedMatches
                    self?.isLoading = false
                }
            }
        }
    }
}
