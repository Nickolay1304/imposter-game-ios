import Foundation

protocol StoreKitServicing: AnyObject {
    var currentStatus: SubscriptionStatus { get async }
    var statusUpdates: AsyncStream<SubscriptionStatus> { get }

    func loadProducts() async throws -> [StoreProduct]
    func purchase(productId: String) async throws -> SubscriptionStatus
    func restorePurchases() async throws -> SubscriptionStatus
    func refreshStatus() async throws -> SubscriptionStatus
    func startTransactionListener()
    func stopTransactionListener()
}
