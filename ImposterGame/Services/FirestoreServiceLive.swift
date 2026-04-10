import Foundation

#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif
#if canImport(FirebaseRemoteConfig)
import FirebaseRemoteConfig
#endif

final class FirestoreServiceLive: FirestoreServicing {
    private let fallback: FirestoreServiceFake

    init(fallback: FirestoreServiceFake = FirestoreServiceFake(artificialLatencyMilliseconds: 0)) {
        self.fallback = fallback
    }

    func fetchCategories() async throws -> [Category] {
        #if canImport(FirebaseFirestore)
        // TODO: Epic 3 — query Firestore `categories/` collection, decode into [Category].
        // On failure or timeout, return `try await fallback.fetchCategories()`.
        fatalError("TODO: Epic 3 — implement Firestore fetchCategories()")
        #else
        fatalError("FirestoreServiceLive requires FirebaseFirestore — wire up in Epic 3")
        #endif
    }

    func fetchCategory(id: String) async throws -> Category {
        #if canImport(FirebaseFirestore)
        fatalError("TODO: Epic 3 — implement Firestore fetchCategory(id:)")
        #else
        fatalError("FirestoreServiceLive requires FirebaseFirestore — wire up in Epic 3")
        #endif
    }

    func fetchRemoteConfigFlags() async throws -> RemoteConfigFlags {
        #if canImport(FirebaseRemoteConfig)
        // TODO: Epic 3 — read keys from RemoteConfigKey.*, merge over RemoteConfigFlags.default.
        fatalError("TODO: Epic 3 — implement Remote Config fetchRemoteConfigFlags()")
        #else
        fatalError("FirestoreServiceLive requires FirebaseRemoteConfig — wire up in Epic 3")
        #endif
    }

    func refreshRemoteConfig() async throws {
        #if canImport(FirebaseRemoteConfig)
        fatalError("TODO: Epic 3 — implement refreshRemoteConfig()")
        #else
        fatalError("FirestoreServiceLive requires FirebaseRemoteConfig — wire up in Epic 3")
        #endif
    }
}
