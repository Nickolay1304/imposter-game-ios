import Foundation

#if canImport(StoreKit)
import StoreKit
#endif

final class StoreKitServiceLive: StoreKitServicing {
    private var continuation: AsyncStream<SubscriptionStatus>.Continuation?
    private lazy var stream: AsyncStream<SubscriptionStatus> = {
        AsyncStream { self.continuation = $0 }
    }()

    init() {}

    var currentStatus: SubscriptionStatus {
        get async {
            #if canImport(StoreKit)
            fatalError("TODO: Epic 4 — derive SubscriptionStatus from Product.SubscriptionInfo")
            #else
            fatalError("StoreKitServiceLive requires StoreKit — wire up in Epic 4")
            #endif
        }
    }

    var statusUpdates: AsyncStream<SubscriptionStatus> { stream }

    func loadProducts() async throws -> [StoreProduct] {
        #if canImport(StoreKit)
        // TODO: Epic 4 — call Product.products(for: StoreProductID.all), map → StoreProduct.
        fatalError("TODO: Epic 4 — implement loadProducts()")
        #else
        fatalError("StoreKitServiceLive requires StoreKit — wire up in Epic 4")
        #endif
    }

    func purchase(productId: String) async throws -> SubscriptionStatus {
        #if canImport(StoreKit)
        // TODO: Epic 4 — Product.purchase(), verify transaction, finish(), update status.
        fatalError("TODO: Epic 4 — implement purchase(productId:)")
        #else
        fatalError("StoreKitServiceLive requires StoreKit — wire up in Epic 4")
        #endif
    }

    func restorePurchases() async throws -> SubscriptionStatus {
        #if canImport(StoreKit)
        // TODO: Epic 4 — AppStore.sync(), then refreshStatus().
        fatalError("TODO: Epic 4 — implement restorePurchases()")
        #else
        fatalError("StoreKitServiceLive requires StoreKit — wire up in Epic 4")
        #endif
    }

    func refreshStatus() async throws -> SubscriptionStatus {
        #if canImport(StoreKit)
        fatalError("TODO: Epic 4 — implement refreshStatus()")
        #else
        fatalError("StoreKitServiceLive requires StoreKit — wire up in Epic 4")
        #endif
    }

    func startTransactionListener() {
        #if canImport(StoreKit)
        // TODO: Epic 4 — Task { for await update in Transaction.updates { ... yield status } }
        #endif
    }

    func stopTransactionListener() {
        continuation?.finish()
        continuation = nil
    }
}
