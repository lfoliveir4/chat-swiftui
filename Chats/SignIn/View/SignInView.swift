import SwiftUI

struct SignInView: View {
    @StateObject var viewModel: SignInViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Entre com seu email", text: $viewModel.email)
                    .padding()
                    .border(Color(UIColor.separator))
                    .autocapitalization(.none)
                    .autocorrectionDisabled(false)
                    .keyboardType(.emailAddress)

                SecureField("Entre com sua senha", text: $viewModel.password)
                    .padding()
                    .border(Color(UIColor.separator))

                if viewModel.loading {
                    ProgressView()
                        .padding()
                } else {
                    Button(action: {
                        viewModel.signIn()
                    }, label: {
                        Text("Entrar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("greenColor"))
                            .foregroundColor(Color.white)
                            .cornerRadius(10.0)
                    })
                    .padding()

                    Divider()

                    NavigationLink(
                        destination: { SignUpView(viewModel: SignUpViewModel(signUpRepository: SignUpRepository())) },
                        label: {
                            Text("Não tem uma conta? Clique aqui")
                                .foregroundColor(Color.black)
                        }
                    ).padding()
                }
            }
            .navigationTitle("Login")
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding()
            .alert(isPresented: $viewModel.formInvalid) {
                Alert(title: Text(viewModel.errorAlert))
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel(signInRepository: SignInRepository()))
    }
}
