import Foundation

struct RemoteConfigFlags: Equatable, Hashable {
    var adFrequencyRounds: Int
    var freeTierCategoryCount: Int
    var paywallVariant: String

    static let `default` = RemoteConfigFlags(
        adFrequencyRounds: 2,
        freeTierCategoryCount: 3,
        paywallVariant: "control"
    )
}

enum RemoteConfigKey {
    static let adFrequencyRounds = "ad_frequency_rounds"
    static let freeTierCategoryCount = "free_tier_category_count"
    static let paywallVariant = "paywall_variant"
}
