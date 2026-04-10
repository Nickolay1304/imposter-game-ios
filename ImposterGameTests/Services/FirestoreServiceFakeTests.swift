import XCTest
@testable import ImposterGame

final class FirestoreServiceFakeTests: XCTestCase {

    func testFetchCategoriesReturnsBundledFallback() async throws {
        let sut = FirestoreServiceFake(artificialLatencyMilliseconds: 0)
        let categories = try await sut.fetchCategories()
        XCTAssertGreaterThanOrEqual(categories.count, 3)
        XCTAssertTrue(categories.allSatisfy { !$0.isPremium })
    }

    func testFetchCategoryByIdReturnsMatch() async throws {
        let sut = FirestoreServiceFake(artificialLatencyMilliseconds: 0)
        let food = try await sut.fetchCategory(id: "food")
        XCTAssertEqual(food.id, "food")
        XCTAssertFalse(food.words.isEmpty)
    }

    func testFetchCategoryByIdThrowsNotFound() async {
        let sut = FirestoreServiceFake(artificialLatencyMilliseconds: 0)
        do {
            _ = try await sut.fetchCategory(id: "nonexistent")
            XCTFail("Expected ServiceError.notFound")
        } catch {
            XCTAssertEqual(error as? ServiceError, .notFound)
        }
    }

    func testNetworkFailureMode() async {
        let sut = FirestoreServiceFake(
            artificialLatencyMilliseconds: 0,
            failureMode: .network
        )
        do {
            _ = try await sut.fetchCategories()
            XCTFail("Expected ServiceError.network")
        } catch {
            XCTAssertEqual(error as? ServiceError, .network)
        }
    }

    func testDecodingFailureMode() async {
        let sut = FirestoreServiceFake(
            artificialLatencyMilliseconds: 0,
            failureMode: .decoding
        )
        do {
            _ = try await sut.fetchCategories()
            XCTFail("Expected ServiceError.decoding")
        } catch let ServiceError.decoding(message) {
            XCTAssertFalse(message.isEmpty)
        } catch {
            XCTFail("Expected .decoding, got \(error)")
        }
    }

    func testRemoteConfigFlagsOverride() async throws {
        let override = RemoteConfigFlags(
            adFrequencyRounds: 5,
            freeTierCategoryCount: 7,
            paywallVariant: "variant_b"
        )
        let sut = FirestoreServiceFake(
            artificialLatencyMilliseconds: 0,
            flags: override
        )
        let fetched = try await sut.fetchRemoteConfigFlags()
        XCTAssertEqual(fetched, override)
    }

    func testRemoteConfigUnavailableOnNetworkFailure() async {
        let sut = FirestoreServiceFake(
            artificialLatencyMilliseconds: 0,
            failureMode: .network
        )
        do {
            _ = try await sut.fetchRemoteConfigFlags()
            XCTFail("Expected .remoteConfigUnavailable")
        } catch {
            XCTAssertEqual(error as? ServiceError, .remoteConfigUnavailable)
        }
    }

    func testInjectedBundledJSONDecodesCorrectly() async throws {
        let json = FirestoreServiceFake.embeddedFallback.data(using: .utf8)!
        let sut = FirestoreServiceFake(
            artificialLatencyMilliseconds: 0,
            bundledJSON: json
        )
        let categories = try await sut.fetchCategories()
        XCTAssertEqual(categories.map(\.id), ["food", "animals", "movies"])
    }
}
