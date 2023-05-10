import SwiftUI

struct SplashView: View {
    @StateObject var viewModel = SplashViewModel()

    var body: some View {
        ZStack {
            if viewModel.isLogged {
                MessagesView()
            } else {
                SignInView(viewModel: SignInViewModel(signInRepository: SignInRepository()))
            }
        }.onAppear { viewModel.onAppear() }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(viewModel: SplashViewModel())
    }
}
