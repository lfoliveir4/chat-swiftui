import Foundation

class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorAlert: String = ""
    @Published var formInvalid = false
    @Published var loading = false

    private let signInRepository: SignInRepository

    init(signInRepository: SignInRepository) {
        self.signInRepository = signInRepository
    }

    func signIn() {
        loading = true

        signInRepository.signIn(withEmail: email, password: password) { error in
            if let error {
                self.formInvalid = true
                self.errorAlert = error
            }
            self.loading = false
        }
    }
}
