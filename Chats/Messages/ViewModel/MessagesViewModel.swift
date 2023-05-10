import Foundation
import SwiftUI

class MessagesViewModel: ObservableObject {
    @Published var loading: Bool = false
    @Published var contacts: [Contact] = []

    private let messagesRepository: MessagesRepository
    private var handleEnabled = true

    init(messagesRepository: MessagesRepository) {
        self.messagesRepository = messagesRepository
    }

    func getContacts() {
        messagesRepository.getContacts { contacts in
            if self.handleEnabled {
                self.contacts = contacts
            }
        }
    }

    func logout() {
        messagesRepository.logout()
    }

    func handleEnabled(enabled: Bool) {
        self.handleEnabled = enabled
    }
}
