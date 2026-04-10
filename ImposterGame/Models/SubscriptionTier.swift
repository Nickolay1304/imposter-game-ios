import Foundation

enum SubscriptionTier: String, Codable, CaseIterable, Hashable {
    case free
    case weekly
    case monthly
    case annual
}

struct SubscriptionStatus: Equatable, Hashable {
    let tier: SubscriptionTier
    let expiresAt: Date?
    let willAutoRenew: Bool
    let inGracePeriod: Bool

    var isPremium: Bool { tier != .free }

    static let free = SubscriptionStatus(
        tier: .free,
        expiresAt: nil,
        willAutoRenew: false,
        inGracePeriod: false
    )
}
