import Foundation

struct Category: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let isPremium: Bool
    let icon: String
    let words: [String]
    let localization: [String: CategoryLocalization]

    func localizedName(for languageCode: String) -> String {
        localization[languageCode]?.name ?? name
    }

    func localizedWords(for languageCode: String) -> [String] {
        localization[languageCode]?.words ?? words
    }
}

struct CategoryLocalization: Codable, Hashable {
    let name: String
    let words: [String]
}
