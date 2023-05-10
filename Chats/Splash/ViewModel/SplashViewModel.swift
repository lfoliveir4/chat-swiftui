import Foundation
import FirebaseAuth

class SplashViewModel: ObservableObject {
    @Published var isLogged = Auth.auth().currentUser != nil

    func onAppear() {
        Auth.auth().addStateDidChangeListener { auth, user in
            self.isLogged = user != nil
        }
    }
}
