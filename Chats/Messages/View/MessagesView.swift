import SwiftUI

struct MessagesView: View {
    @StateObject var viewModel = MessagesViewModel(messagesRepository: MessagesRepository())

    var body: some View {

        NavigationView {
            VStack {
                if viewModel.loading {
                    ProgressView()
                } else {
                    if viewModel.contacts.isEmpty {
                        Text("Você não iniciou nenhuma conversa")
                    } else {
                        List(viewModel.contacts, id: \.self) { contact in
                            NavigationLink(
                                destination: {
                                    ChatConversationView(contact: contact)
                                },
                                label: {
                                    MessagesRow(contact: contact)
                                }
                            )
                        }
                    }
                }
            }
            .onAppear {
                viewModel.handleEnabled(enabled: true)
                viewModel.getContacts()
            }
            .onDisappear {
                viewModel.handleEnabled(enabled: false)
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(
                    id: "contacts",
                    placement: ToolbarItemPlacement.navigationBarTrailing,
                    showsByDefault: true
                ) {
                    NavigationLink(
                        "Contatos",
                        destination: ContactsView()
                    )
                }
                ToolbarItem(
                    id: "logout",
                    placement: ToolbarItemPlacement.navigationBarTrailing,
                    showsByDefault: true
                ) {
                    Button("Sair") {
                        viewModel.logout()
                    }
                }
            }
        }
    }
}

struct MessagesRow: View {
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

            VStack(alignment: .leading) {
                Text(contact.name)
                if let lastMessage = contact.lastMessage {
                    Text(lastMessage).lineLimit(1)
                }
            }

            Spacer()
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
