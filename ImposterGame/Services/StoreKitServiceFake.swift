import Foundation

final class StoreKitServiceFake: StoreKitServicing {
    enum PurchaseBehavior {
        case succeeds
        case cancels
        case pending
        case fails(ServiceError)
    }

    private var status: SubscriptionStatus
    private let scriptedProducts: [StoreProduct]
    var purchaseBehavior: PurchaseBehavior
    private let artificialLatencyNanos: UInt64

    private var continuation: AsyncStream<SubscriptionStatus>.Continuation?
    private lazy var stream: AsyncStream<SubscriptionStatus> = {
        AsyncStream { continuation in
            self.continuation = continuation
            continuation.yield(self.status)
        }
    }()

    init(
        initialStatus: SubscriptionStatus = .free,
        scriptedProducts: [StoreProduct] = .defaultImposterVIP,
        purchaseBehavior: PurchaseBehavior = .succeeds,
        artificialLatencyMilliseconds: Int = 400
    ) {
        self.status = initialStatus
        self.scriptedProducts = scriptedProducts
        self.purchaseBehavior = purchaseBehavior
        self.artificialLatencyNanos = UInt64(max(0, artificialLatencyMilliseconds)) * 1_000_000
    }

    var currentStatus: SubscriptionStatus {
        get async { status }
    }

    var statusUpdates: AsyncStream<SubscriptionStatus> {
        stream
    }

    func setStatus(_ newStatus: SubscriptionStatus) {
        status = newStatus
        continuation?.yield(newStatus)
    }

    func loadProducts() async throws -> [StoreProduct] {
        try await simulateLatency()
        guard !scriptedProducts.isEmpty else {
            throw ServiceError.productsUnavailable
        }
        return scriptedProducts
    }

    func purchase(productId: String) async throws -> SubscriptionStatus {
        try await simulateLatency()
        guard let product = scriptedProducts.first(where: { $0.id == productId }) else {
            throw ServiceError.productsUnavailable
        }

        switch purchaseBehavior {
        case .succeeds:
            let newStatus = SubscriptionStatus(
                tier: product.tier,
                expiresAt: Date().addingTimeInterval(TimeInterval(product.periodDays * 86_400)),
                willAutoRenew: true,
                inGracePeriod: false
            )
            setStatus(newStatus)
            return newStatus
        case .cancels:
            throw ServiceError.purchaseCancelled
        case .pending:
            throw ServiceError.purchasePending
        case .fails(let error):
            throw error
        }
    }

    func restorePurchases() async throws -> SubscriptionStatus {
        try await simulateLatency()
        return status
    }

    func refreshStatus() async throws -> SubscriptionStatus {
        try await simulateLatency()
        return status
    }

    func startTransactionListener() {}

    func stopTransactionListener() {
        continuation?.finish()
        continuation = nil
    }

    private func simulateLatency() async throws {
        if artificialLatencyNanos > 0 {
            try await Task.sleep(nanoseconds: artificialLatencyNanos)
        }
    }
}
