import SwiftUI

struct ContactsView: View {
    @StateObject var viewModel = ContactsViewModel(contactsRepository: ContactsRepository())

    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
            } else {
                List(viewModel.contacts, id: \.self) { contact in
                    NavigationLink {
                        ChatConversationView(contact: contact)
                    } label: {
                        ContactRow(contact: contact)
                    }
                }
            }
        }
        .onAppear {
            viewModel.getContacts()
        }
        .navigationTitle("Contatos")
        .navigationBarTitleDisplayMode(.large)
    }
}


struct ContactRow: View {
    var contact: Contact

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: contact.profileUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .cornerRadius(50)

            Text(contact.name)
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(viewModel: ContactsViewModel(contactsRepository: ContactsRepository()))
    }
}
