import Foundation

final class FirestoreServiceFake: FirestoreServicing {
    enum FailureMode: Equatable {
        case none
        case network
        case decoding
        case notFound
        case timeout
    }

    private let artificialLatencyNanos: UInt64
    private var failureMode: FailureMode
    private let bundledJSON: Data?
    private var flags: RemoteConfigFlags
    private var cachedCategories: [Category]?

    init(
        artificialLatencyMilliseconds: Int = 150,
        failureMode: FailureMode = .none,
        bundledJSON: Data? = nil,
        flags: RemoteConfigFlags = .default
    ) {
        self.artificialLatencyNanos = UInt64(max(0, artificialLatencyMilliseconds)) * 1_000_000
        self.failureMode = failureMode
        self.bundledJSON = bundledJSON
        self.flags = flags
    }

    func setFailureMode(_ mode: FailureMode) {
        failureMode = mode
    }

    func setFlags(_ newFlags: RemoteConfigFlags) {
        flags = newFlags
    }

    func fetchCategories() async throws -> [Category] {
        try await simulateLatency()
        try throwIfFailureConfigured()

        if let cached = cachedCategories {
            return cached
        }

        let data = try loadJSONData()
        do {
            let decoded = try JSONDecoder().decode([Category].self, from: data)
            cachedCategories = decoded
            return decoded
        } catch {
            throw ServiceError.decoding(String(describing: error))
        }
    }

    func fetchCategory(id: String) async throws -> Category {
        let all = try await fetchCategories()
        guard let match = all.first(where: { $0.id == id }) else {
            throw ServiceError.notFound
        }
        return match
    }

    func fetchRemoteConfigFlags() async throws -> RemoteConfigFlags {
        try await simulateLatency()
        if failureMode == .network || failureMode == .timeout {
            throw ServiceError.remoteConfigUnavailable
        }
        return flags
    }

    func refreshRemoteConfig() async throws {
        try await simulateLatency()
        if failureMode == .network || failureMode == .timeout {
            throw ServiceError.remoteConfigUnavailable
        }
    }

    private func simulateLatency() async throws {
        if artificialLatencyNanos > 0 {
            try await Task.sleep(nanoseconds: artificialLatencyNanos)
        }
    }

    private func throwIfFailureConfigured() throws {
        switch failureMode {
        case .none: return
        case .network: throw ServiceError.network
        case .decoding: throw ServiceError.decoding("simulated decoding failure")
        case .notFound: throw ServiceError.notFound
        case .timeout: throw ServiceError.timeout
        }
    }

    private func loadJSONData() throws -> Data {
        if let injected = bundledJSON {
            return injected
        }
        #if canImport(ObjectiveC)
        if let url = Bundle.main.url(forResource: "categories_fallback", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            return data
        }
        #endif
        return Self.embeddedFallback.data(using: .utf8) ?? Data()
    }

    static let embeddedFallback: String = """
    [
      {
        "id": "food",
        "name": "Food",
        "isPremium": false,
        "icon": "fork.knife",
        "words": ["Pizza", "Sushi", "Burger", "Pasta", "Taco"],
        "localization": {
          "en": { "name": "Food", "words": ["Pizza", "Sushi", "Burger", "Pasta", "Taco"] },
          "uk": { "name": "Їжа", "words": ["Піца", "Суші", "Бургер", "Паста", "Тако"] },
          "ru": { "name": "Еда", "words": ["Пицца", "Суши", "Бургер", "Паста", "Тако"] }
        }
      },
      {
        "id": "animals",
        "name": "Animals",
        "isPremium": false,
        "icon": "pawprint.fill",
        "words": ["Lion", "Tiger", "Elephant", "Giraffe", "Zebra"],
        "localization": {
          "en": { "name": "Animals", "words": ["Lion", "Tiger", "Elephant", "Giraffe", "Zebra"] },
          "uk": { "name": "Тварини", "words": ["Лев", "Тигр", "Слон", "Жираф", "Зебра"] },
          "ru": { "name": "Животные", "words": ["Лев", "Тигр", "Слон", "Жираф", "Зебра"] }
        }
      },
      {
        "id": "movies",
        "name": "Movies",
        "isPremium": false,
        "icon": "film.fill",
        "words": ["Titanic", "Avatar", "Inception", "Gladiator", "Matrix"],
        "localization": {
          "en": { "name": "Movies", "words": ["Titanic", "Avatar", "Inception", "Gladiator", "Matrix"] },
          "uk": { "name": "Фільми", "words": ["Титанік", "Аватар", "Початок", "Гладіатор", "Матриця"] },
          "ru": { "name": "Фильмы", "words": ["Титаник", "Аватар", "Начало", "Гладиатор", "Матрица"] }
        }
      }
    ]
    """
}
