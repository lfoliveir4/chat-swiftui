import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class SignUpRepository {
    func signUp(
        withEmail email: String,
        password: String,
        selectedImage: UIImage,
        name: String,
        completion: @escaping (String?) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { response, error in
            guard let user = response?.user, error == nil else {
                print("\(String(describing: error?.localizedDescription))")
                completion(error?.localizedDescription)
                return
            }

            print("user criado \(String(describing: user.email)) \(user.uid)")

            self.uploadUserPicture(selectedImage: selectedImage, name: name) { err in
                if let err = err {
                    completion(err)
                }
            }
        }
    }

    private func uploadUserPicture(
        selectedImage: UIImage,
        name: String,
        completion: @escaping (String?) -> Void
    ) {
        let filename = UUID().uuidString

        guard let data = selectedImage.jpegData(compressionQuality: 0.2) else { return }

        let newMetadata = StorageMetadata()
        newMetadata.contentType = "image/jpeg"

        let storageReference = Storage.storage().reference(withPath: "/images/\(filename).jpg")

        storageReference.putData(data, metadata: newMetadata) { metadata, error in
            print("\(String(describing: error?.localizedDescription))")
            storageReference.downloadURL { url, error in
                print("photo url \(String(describing: url))")
                guard let url else { return }
                self.createUser(photoURL: url, name: name, completion: completion)
            }
        }
    }

    private func createUser(
        photoURL: URL,
        name: String,
        completion: @escaping (String?) -> Void
    ) {
        let uid = Auth.auth().currentUser?.uid ?? ""

        Firestore.firestore().collection("users")
            .document(uid)
            .setData([
                "name": name,
                "uuid": uid,
                "profileUrl": photoURL.absoluteString
            ]) { error in
                if error != nil {
                    print("error on create user: \(String(describing: error?.localizedDescription))")
                    completion(error?.localizedDescription)
                    return
                }
            }
    }
}
