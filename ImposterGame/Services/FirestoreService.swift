import Foundation

protocol FirestoreServicing {
    func fetchCategories() async throws -> [Category]
    func fetchCategory(id: String) async throws -> Category
    func fetchRemoteConfigFlags() async throws -> RemoteConfigFlags
    func refreshRemoteConfig() async throws
}
