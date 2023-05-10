import Foundation
import FirebaseAuth
import FirebaseFirestore

class MessagesRepository {
    func getContacts(completion: @escaping ([Contact]) -> Void) {
        var contacts: [Contact] = []
        let fromId = Auth.auth().currentUser?.uid ?? ""

        Firestore.firestore().collection("last-messages")
            .document(fromId)
            .collection("contacts")
            .addSnapshotListener { querySnapshot, error in
                if let documentsChanges = querySnapshot?.documentChanges {
                    documentsChanges.forEach { doc in
                        if doc.type == .added {
                            let (document) = doc.document
                            contacts.removeAll()

                            let contact = Contact(
                                uuid: document.documentID,
                                name: document.data()["username"] as! String,
                                profileUrl: document.data()["photoUrl"] as! String,
                                lastMessage: document.data()["lastMessage"] as! String,
                                timestamp: document.data()["timestamp"] as! UInt
                            )
                            contacts.append(contact)
                        }
                    }
                    completion(contacts)
                }
            }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("erro ao efetuar logout \(error.localizedDescription)")
        }
    }
}
