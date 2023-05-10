struct Message: Hashable {
    let uuid: String
    let text: String
    let isMe: Bool
    let timestamp: UInt
}
