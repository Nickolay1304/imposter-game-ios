import SwiftUI

struct RootView: View {
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            MainMenuView(path: $path)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .setup:
                        GameSetupView()
                    case .session:
                        Text("Session — TBD")
                    case .paywall:
                        Text("Paywall — TBD")
                    }
                }
        }
    }
}

#Preview {
    RootView()
        .preferredColorScheme(.dark)
}
