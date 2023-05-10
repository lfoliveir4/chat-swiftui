import SwiftUI

struct ChatConversationView: View {
    @StateObject var viewModel = ChatConversationViewModel(
        chatConversationRepository: ChatConversationRepository()
    )

    let contact: Contact

    @State var textSize: CGSize = .zero

    @Namespace var scrollToBottom

    var body: some View {
        VStack {
            ScrollViewReader { value in
                ScrollView(showsIndicators: false) {
                    Color.clear
                        .frame(height: 1)
                        .id(scrollToBottom)

                    LazyVStack {
                        ForEach(viewModel.messages, id: \.self) { message in
                            MessageRow(message: message)
                                .scaleEffect(x: 1.0, y: -1.0, anchor: .center)
                                .onAppear {
                                    if message == viewModel.messages.last && viewModel.messages.count >= viewModel.limit {
                                        viewModel.onAppear(contact: contact)
                                    }
                                }
                        }
                    }
                    .onChange(of: viewModel.newCount) { newValue in
                        if newValue > viewModel.messages.count {
                            withAnimation {
                                value.scrollTo(scrollToBottom)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .gesture(DragGesture().onChanged({ _ in
                    UIApplication.shared.endEdition()
                }))
                .rotationEffect(Angle(degrees: 180))
                .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            }

            Spacer()

            HStack {
                ZStack {
                    TextEditor(text: $viewModel.text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray)
                        )
                        .frame(maxHeight: (textSize.height + 50) > 100 ? 100 : textSize.height + 50)

                    Text(viewModel.text)
                        .opacity(0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(GeometryReaderView())
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 21)
                        .onPreferenceChange(ViewSizeKey.self) { size in
                            print("textSize is \(size)")
                            textSize = size
                        }
                }

                Button(action: {
                    viewModel.sendMessage(contact: contact)
                }, label: {
                    Text("Enviar")
                        .padding()
                        .background(Color("greenColor"))
                        .foregroundColor(Color.white)
                        .cornerRadius(12.0)
                })
            }
            .padding()
        }
        .navigationTitle(contact.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.onAppear(contact: contact)
        }
    }
}

struct MessageRow: View {
    let message: Message

    var body: some View {
        Text(message.text)
            .background(Color(white: 0.95))
            .frame(
                maxWidth: .infinity,
                alignment: message.isMe ? .trailing : .leading
            )
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading, message.isMe ? 50 : 0)
            .padding(.trailing, message.isMe ? 0 : 170)
            .padding(.vertical, 5)
    }
}

struct GeometryReaderView: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ViewSizeKey.self, value: geometry.size)
        }
    }
}

struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        print("newValue is \(value)")
        value = nextValue()
    }
}

struct ChatConversationView_Previews: PreviewProvider {
    static var previews: some View {
        let contact = Contact(
            uuid: "ksjhf2s",
            name: "fornao",
            profileUrl: "https://"
        )

        ChatConversationView(contact: contact)
    }
}
