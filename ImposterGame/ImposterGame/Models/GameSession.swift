import Foundation

struct GameSession: Identifiable, Hashable {
    let id: UUID
    var players: [Player]
    var category: Category?
    var imposterIDs: Set<UUID>
    var secretWord: String?

    init(
        id: UUID = UUID(),
        players: [Player] = [],
        category: Category? = nil,
        imposterIDs: Set<UUID> = [],
        secretWord: String? = nil
    ) {
        self.id = id
        self.players = players
        self.category = category
        self.imposterIDs = imposterIDs
        self.secretWord = secretWord
    }
}
