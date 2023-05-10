import Foundation
import UIKit

class SignUpViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var alertText = ""
    @Published var formInvalid = false
    @Published var loading = false
    @Published var selectedImage = UIImage()

    private let signUpRepository: SignUpRepository

    init(signUpRepository: SignUpRepository) {
        self.signUpRepository = signUpRepository
    }

    func signUp() {
        if (selectedImage.size.width <= 0) {
            formInvalid = true
            alertText = "Para prosseguir é necessário uma foto"
            return
        }

        loading = true

        signUpRepository.signUp(
            withEmail: email,
            password: password,
            selectedImage: selectedImage,
            name: name
        ) { error in
            if let error {
                self.formInvalid = true
                self.alertText = error
                print(error)
            }
            self.loading = false
        }
    }
}
