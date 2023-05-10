import Foundation
import FirebaseFirestore

class ContactsViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var loading: Bool = false

    var contactsLoaded: Bool = false

    private let contactsRepository: ContactsRepository

    init(contactsRepository: ContactsRepository) {
        self.contactsRepository = contactsRepository
    }

    func getContacts() {
        if contactsLoaded { return }
        loading = true
        contactsLoaded = true

        contactsRepository.getContacts { contacts in
            self.contacts.append(contentsOf: contacts)
            self.loading = false
        }
    }
}
