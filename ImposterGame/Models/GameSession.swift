import Foundation

enum GamePhase: String, Hashable, Codable {
    case setup
    case roleReveal
    case active
    case voting
    case results
}

struct GameSession: Identifiable {
    let id: UUID
    var players: [Player]
    var category: Category
    var secretWord: String
    var phase: GamePhase
    var currentPlayerIndex: Int
    var roundNumber: Int
    var startedAt: Date

    init(
        id: UUID = UUID(),
        players: [Player],
        category: Category,
        secretWord: String,
        phase: GamePhase = .setup,
        currentPlayerIndex: Int = 0,
        roundNumber: Int = 1,
        startedAt: Date = Date()
    ) {
        self.id = id
        self.players = players
        self.category = category
        self.secretWord = secretWord
        self.phase = phase
        self.currentPlayerIndex = currentPlayerIndex
        self.roundNumber = roundNumber
        self.startedAt = startedAt
    }

    var imposterIds: [UUID] {
        players.filter(\.isImposter).map(\.id)
    }
}
