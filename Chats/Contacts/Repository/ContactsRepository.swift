import Foundation
import FirebaseFirestore

class ContactsRepository {
    func getContacts(completion: @escaping ([Contact]) -> Void) {
        var contacts: [Contact] = []
        Firestore.firestore().collection("users").getDocuments { querySnapshot, error in
            if let error {
                print("erro ao buscar contatos \(error.localizedDescription)")
                return
            }

            guard let querySnapshot else {
                print("Erro ao buscar querySnapshot: \(String(describing: error?.localizedDescription))")
                return
            }

            querySnapshot.documents.forEach { document in
                let contact = Contact(
                    uuid: document.documentID,
                    name: document.data()["name"] as! String,
                    profileUrl: document.data()["profileUrl"] as! String
                )

                contacts.append(contact)
            }

            completion(contacts)
        }
    }
}
