import SwiftUI

struct GameSetupView: View {
    var body: some View {
        ZStack {
            Color.surfaceBlack
                .ignoresSafeArea()

            VStack(spacing: Spacing.m) {
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Color.electricPurple)

                Text("game_setup.placeholder")
                    .font(.headlineBold)
                    .foregroundStyle(Color.white)
            }
        }
    }
}

#Preview {
    GameSetupView()
        .preferredColorScheme(.dark)
}
