import Foundation
import FirebaseAuth

class SignInRepository {
    func signIn(
        withEmail email: String,
        password: String,
        completion: @escaping (String?) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) { response, error in
            guard let user = response?.user, error == nil else {
                print("\(String(describing: error?.localizedDescription))")
                completion(error?.localizedDescription)
                return
            }
            print("user is: \(user.uid)")
            completion(nil)
        }
    }
}
