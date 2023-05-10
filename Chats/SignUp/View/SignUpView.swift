import SwiftUI

struct SignUpView: View {
    @StateObject var viewModel: SignUpViewModel

    @State var openGallery: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                Button(
                    action: { openGallery = true },
                    label: {
                        if viewModel.selectedImage.size.width > 0  {
                            Image(uiImage: viewModel.selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(
                                        Color("greenColor"),
                                        lineWidth: 4
                                    )
                                )
                        } else {
                            Text("Sua foto")
                                .frame(width: 130, height: 130)
                                .padding()
                                .background(Color("greenColor"))
                                .foregroundColor(Color.white)
                                .cornerRadius(100.0)
                            }
                        }
                )
                .padding(.bottom, 32)
                .sheet(isPresented: $openGallery) {
                    ImagePicker(selectedImage: $viewModel.selectedImage)
                }
                
                TextField("Entre com seu nome", text: $viewModel.name)
                    .padding()
                    .border(Color(UIColor.separator))
                    .autocapitalization(.none)
                    .autocorrectionDisabled(false)
                    .keyboardType(.emailAddress)

                TextField("Entre com seu email", text: $viewModel.email)
                    .padding()
                    .border(Color(UIColor.separator))
                    .autocapitalization(.none)
                    .autocorrectionDisabled(false)
                    .keyboardType(.emailAddress)

                SecureField("Entre com sua senha", text: $viewModel.password)
                    .padding()
                    .border(Color(UIColor.separator))


                Button(action: {
                    viewModel.signUp()
                }, label: {
                    if viewModel.loading {
                        ProgressView()
                    } else {
                        Text("Cadastrar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("greenColor"))
                            .foregroundColor(Color.white)
                            .cornerRadius(10.0)
                    }
                })
                .alert(isPresented: $viewModel.formInvalid) {
                    Alert(title: Text(viewModel.alertText))
                }
                .padding()
                .navigationTitle("Cadastro")
            }
            .padding()
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )

        }
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
            )
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(
            viewModel: SignUpViewModel(signUpRepository: SignUpRepository())
        )
    }
}
