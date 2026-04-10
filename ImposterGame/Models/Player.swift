import Foundation

struct Player: Identifiable, Hashable {
    let id: UUID
    var name: String
    var isImposter: Bool
    var hasVoted: Bool
    var votedForId: UUID?

    init(
        id: UUID = UUID(),
        name: String,
        isImposter: Bool = false,
        hasVoted: Bool = false,
        votedForId: UUID? = nil
    ) {
        self.id = id
        self.name = name
        self.isImposter = isImposter
        self.hasVoted = hasVoted
        self.votedForId = votedForId
    }
}
