import SwiftUI

struct MainMenuView: View {
    @Binding var path: [Route]
    @StateObject private var viewModel = MainMenuViewModel()

    var body: some View {
        ZStack {
            Color.surfaceBlack
                .ignoresSafeArea()

            VStack(spacing: Spacing.xl) {
                Spacer()

                Text("main_menu.title")
                    .font(.displayTitle)
                    .foregroundStyle(Color.neonGreen)
                    .shadow(color: Color.neonGreen.opacity(0.6), radius: 20)

                Text("main_menu.tagline")
                    .font(.bodyRegular)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)

                Spacer()

                Button {
                    HapticManager.impact(.medium)
                    path.append(.setup)
                } label: {
                    Text("main_menu.new_game")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, Spacing.l)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        MainMenuView(path: .constant([]))
    }
    .preferredColorScheme(.dark)
}
