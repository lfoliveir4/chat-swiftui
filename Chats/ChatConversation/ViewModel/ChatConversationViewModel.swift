import Foundation

class ChatConversationViewModel: ObservableObject {
    @Published var messages: [Message] = []

    @Published var text = ""

    @Published var currentUserName = ""
    @Published var currentUserPhoto = ""

    let limit = 20
    var inserting = false
    var newCount = 0

    private let chatConversationRepository: ChatConversationRepository

    init(chatConversationRepository: ChatConversationRepository) {
        self.chatConversationRepository = chatConversationRepository
    }

    func onAppear(contact: Contact) {
        chatConversationRepository.fetchChat(
            limit: limit,
            contact: contact,
            lastMessage: self.messages.last
        ) { message in

            if self.inserting || message.timestamp > self.messages.last?.timestamp ?? 0 {
                self.messages.insert(message, at: 0)
            } else {
                self.messages.append(message)
            }

            self.inserting = false
            self.newCount = self.messages.count
        }
    }

    func sendMessage(contact: Contact) {
        let text = self.text.trimmingCharacters(in: .whitespacesAndNewlines)
        newCount = newCount + 1
        self.text = ""
        self.inserting = true

        chatConversationRepository.sendMessage(text: text, contact: contact)
    }
}
