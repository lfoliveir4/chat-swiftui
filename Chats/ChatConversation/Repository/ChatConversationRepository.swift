import Foundation
import FirebaseAuth
import FirebaseFirestore

class ChatConversationRepository {
    var currentUserName = ""
    var currentUserPhoto = ""

    func fetchChat(
        limit: Int,
        contact: Contact,
        lastMessage: Message?,
        completion: @escaping (Message) -> Void
    ) {
        let fromId = Auth.auth().currentUser?.uid ?? ""

        Firestore.firestore().collection("users")
            .document(fromId)
            .getDocument { querySnapshot, error in
                if let error {
                    print("error on fetch documents: \(error)")
                    return
                }

                if let document = querySnapshot?.data() {
                    self.currentUserName = document["name"] as! String
                    self.currentUserPhoto = document["profileUrl"] as! String
                }
            }

        Firestore.firestore().collection("conversations")
            .document(fromId)
            .collection(contact.uuid)
            .order(by: "timestamp", descending: true)
            .start(after: [lastMessage?.timestamp ?? 99999999999999])
            .limit(to: limit)
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    print("error on fetch documents message: \(error)")
                    return
                }

                if let documentChanges = querySnapshot?.documentChanges {
                    documentChanges.forEach { doc in
                        if doc.type == .added {
                            let document = doc.document
                            print("document: \(document.documentID)")

                            let message = Message(
                                uuid: document.documentID,
                                text: document.data()["text"] as! String,
                                isMe: fromId == document.data()["fromId"] as! String,
                                timestamp: document.data()["timestamp"] as! UInt
                            )

                            completion(message)
                        }
                    }
                }
            }
    }

    func sendMessage(text: String, contact: Contact) {
        let fromId = Auth.auth().currentUser?.uid ?? ""
        let timestamp = Date().timeIntervalSince1970

        Firestore.firestore().collection("conversations")
            .document(fromId)
            .collection(contact.uuid)
            .addDocument(data: [
                "text": text,
                "fromId": fromId,
                "toId": contact.uuid,
                "timestamp": UInt(timestamp)
            ]) { error in
                if error != nil {
                    print("error on send message a \(String(describing: error?.localizedDescription))")
                    return
                }

                Firestore.firestore().collection("last-messages")
                    .document(fromId)
                    .collection("contacts")
                    .document(contact.uuid)
                    .setData([
                        "uid": contact.uuid,
                        "username": contact.name,
                        "photoUrl": contact.profileUrl,
                        "timestamp": UInt(timestamp),
                        "lastMessage": text
                    ])
            }

        Firestore.firestore().collection("conversations")
            .document(contact.uuid)
            .collection(fromId)
            .addDocument(data: [
                "text": text,
                "fromId": fromId,
                "toId": contact.uuid,
                "timestamp": UInt(timestamp)
            ]) { error in
                if error != nil {
                    print("error on send message b \(String(describing: error?.localizedDescription))")
                    return
                }

                Firestore.firestore().collection("last-messages")
                    .document(contact.uuid)
                    .collection("contacts")
                    .document(fromId)
                    .setData([
                        "uid": fromId,
                        "username": self.currentUserName,
                        "photoUrl": self.currentUserPhoto,
                        "timestamp": UInt(timestamp),
                        "lastMessage": text
                    ])
            }
    }
}
