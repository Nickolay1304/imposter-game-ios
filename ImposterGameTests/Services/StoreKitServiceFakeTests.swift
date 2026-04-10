import XCTest
@testable import ImposterGame

final class StoreKitServiceFakeTests: XCTestCase {

    func testLoadProductsReturnsThreeTiers() async throws {
        let sut = StoreKitServiceFake(artificialLatencyMilliseconds: 0)
        let products = try await sut.loadProducts()
        XCTAssertEqual(products.count, 3)
        XCTAssertEqual(Set(products.map(\.tier)), [.weekly, .monthly, .annual])
    }

    func testLoadProductsThrowsWhenEmpty() async {
        let sut = StoreKitServiceFake(
            scriptedProducts: [],
            artificialLatencyMilliseconds: 0
        )
        do {
            _ = try await sut.loadProducts()
            XCTFail("Expected productsUnavailable")
        } catch {
            XCTAssertEqual(error as? ServiceError, .productsUnavailable)
        }
    }

    func testPurchaseSucceedsUpdatesStatus() async throws {
        let sut = StoreKitServiceFake(artificialLatencyMilliseconds: 0)
        let initial = await sut.currentStatus
        XCTAssertFalse(initial.isPremium)

        let newStatus = try await sut.purchase(productId: StoreProductID.monthly)
        XCTAssertTrue(newStatus.isPremium)
        XCTAssertEqual(newStatus.tier, .monthly)

        let current = await sut.currentStatus
        XCTAssertEqual(current, newStatus)
    }

    func testPurchaseCancelledThrows() async {
        let sut = StoreKitServiceFake(
            purchaseBehavior: .cancels,
            artificialLatencyMilliseconds: 0
        )
        do {
            _ = try await sut.purchase(productId: StoreProductID.weekly)
            XCTFail("Expected purchaseCancelled")
        } catch {
            XCTAssertEqual(error as? ServiceError, .purchaseCancelled)
        }
    }

    func testPurchasePendingThrows() async {
        let sut = StoreKitServiceFake(
            purchaseBehavior: .pending,
            artificialLatencyMilliseconds: 0
        )
        do {
            _ = try await sut.purchase(productId: StoreProductID.annual)
            XCTFail("Expected purchasePending")
        } catch {
            XCTAssertEqual(error as? ServiceError, .purchasePending)
        }
    }

    func testPurchaseFailsWithCustomError() async {
        let sut = StoreKitServiceFake(
            purchaseBehavior: .fails(.network),
            artificialLatencyMilliseconds: 0
        )
        do {
            _ = try await sut.purchase(productId: StoreProductID.weekly)
            XCTFail("Expected .network")
        } catch {
            XCTAssertEqual(error as? ServiceError, .network)
        }
    }

    func testPurchaseUnknownProductIdThrows() async {
        let sut = StoreKitServiceFake(artificialLatencyMilliseconds: 0)
        do {
            _ = try await sut.purchase(productId: "com.unknown.product")
            XCTFail("Expected productsUnavailable")
        } catch {
            XCTAssertEqual(error as? ServiceError, .productsUnavailable)
        }
    }

    func testSetStatusBroadcastsToStream() async throws {
        let sut = StoreKitServiceFake(artificialLatencyMilliseconds: 0)
        var iterator = sut.statusUpdates.makeAsyncIterator()

        let first = await iterator.next()
        XCTAssertEqual(first, .free)

        let premium = SubscriptionStatus(
            tier: .annual,
            expiresAt: Date().addingTimeInterval(86_400 * 365),
            willAutoRenew: true,
            inGracePeriod: false
        )
        sut.setStatus(premium)
        let second = await iterator.next()
        XCTAssertEqual(second, premium)
    }

    func testRestorePurchasesReturnsCurrentStatus() async throws {
        let sut = StoreKitServiceFake(artificialLatencyMilliseconds: 0)
        sut.setStatus(SubscriptionStatus(
            tier: .weekly,
            expiresAt: nil,
            willAutoRenew: false,
            inGracePeriod: false
        ))
        let restored = try await sut.restorePurchases()
        XCTAssertEqual(restored.tier, .weekly)
    }
}
