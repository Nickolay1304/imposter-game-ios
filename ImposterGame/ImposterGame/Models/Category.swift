import Foundation

struct Category: Identifiable, Hashable {
    let id: String
    let nameKey: String
    let isPremium: Bool
    let iconSystemName: String
    let words: [String]
}
