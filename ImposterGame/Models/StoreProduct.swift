import Foundation

struct StoreProduct: Identifiable, Hashable {
    let id: String
    let displayName: String
    let description: String
    let priceString: String
    let priceDecimal: Decimal
    let tier: SubscriptionTier
    let periodDays: Int
}

extension Array where Element == StoreProduct {
    static let defaultImposterVIP: [StoreProduct] = [
        StoreProduct(
            id: StoreProductID.weekly,
            displayName: "Imposter VIP — Weekly",
            description: "Unlock all categories and remove ads.",
            priceString: "$1.99",
            priceDecimal: Decimal(string: "1.99") ?? 0,
            tier: .weekly,
            periodDays: 7
        ),
        StoreProduct(
            id: StoreProductID.monthly,
            displayName: "Imposter VIP — Monthly",
            description: "Unlock all categories and remove ads.",
            priceString: "$4.99",
            priceDecimal: Decimal(string: "4.99") ?? 0,
            tier: .monthly,
            periodDays: 30
        ),
        StoreProduct(
            id: StoreProductID.annual,
            displayName: "Imposter VIP — Annual",
            description: "Unlock all categories and remove ads.",
            priceString: "$29.99",
            priceDecimal: Decimal(string: "29.99") ?? 0,
            tier: .annual,
            periodDays: 365
        )
    ]
}

enum StoreProductID {
    static let weekly = "com.imposter.vip.weekly"
    static let monthly = "com.imposter.vip.monthly"
    static let annual = "com.imposter.vip.annual"

    static let all: [String] = [weekly, monthly, annual]
}
