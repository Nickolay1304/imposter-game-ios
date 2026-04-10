import Combine
import Foundation

@MainActor
final class MainMenuViewModel: ObservableObject {
    @Published var isPremium: Bool = false
}
