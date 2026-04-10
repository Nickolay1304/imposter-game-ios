# 🎭 Imposter Game — iOS

> A local multiplayer social deduction party game for 3–15 players on a single iOS device.

![Platform](https://img.shields.io/badge/Platform-iOS%2016%2B-blue?style=flat-square&logo=apple)
![Language](https://img.shields.io/badge/Language-Swift%205.9-orange?style=flat-square&logo=swift)
![Framework](https://img.shields.io/badge/UI-SwiftUI-purple?style=flat-square)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-green?style=flat-square)
![License](https://img.shields.io/github/license/Nickolay1304/imposter-game-ios?style=flat-square)

---

## 📖 About

**Imposter Game** is a pass-and-play party game inspired by social deduction mechanics. Players take turns viewing a secret word on a single device — except one player (the Imposter) who must bluff their way through conversation without knowing the word.

### How It Works
1. **Setup** — Choose the number of players (3–15) and a category.
2. **Role Reveal** — Pass the device around. Each player secretly taps to see their role: *Secret Word* or *You are the Imposter*.
3. **Discussion** — Players take turns saying one word related to the secret word. The Imposter bluffs based on context clues.
4. **Vote** — Players vote on who they think the Imposter is.
5. **Reveal** — Dramatic reveal of the Imposter with win/loss calculation.

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| UI Framework | SwiftUI |
| Architecture | MVVM |
| Backend | Firebase (Firestore, Remote Config) |
| Auth | Firebase Anonymous Auth |
| Monetization | StoreKit 2 + Google AdMob |
| Analytics | Firebase Analytics & Crashlytics |
| Localization | Apple String Catalogs |

---

## 📁 Project Structure

```
imposter-game-ios/
├── ImposterGame/
│   ├── App/
│   │   └── ImposterGameApp.swift          # App entry point
│   ├── Models/
│   │   ├── Player.swift
│   │   ├── Category.swift
│   │   └── GameSession.swift
│   ├── ViewModels/
│   │   ├── GameSetupViewModel.swift
│   │   ├── GameSessionViewModel.swift
│   │   └── SubscriptionViewModel.swift
│   ├── Views/
│   │   ├── Launch/
│   │   │   └── SplashView.swift
│   │   ├── Menu/
│   │   │   └── MainMenuView.swift
│   │   ├── Setup/
│   │   │   └── GameSetupView.swift
│   │   ├── Gameplay/
│   │   │   ├── PassAndPlayView.swift
│   │   │   ├── RoleRevealView.swift
│   │   │   ├── ActiveGameView.swift
│   │   │   └── VotingView.swift
│   │   └── Paywall/
│   │       └── PaywallView.swift
│   ├── Services/
│   │   ├── FirestoreService.swift
│   │   ├── StoreKitService.swift
│   │   └── AdMobService.swift
│   ├── Resources/
│   │   ├── Assets.xcassets
│   │   └── Localizable.xcstrings
│   └── Utils/
│       ├── HapticManager.swift
│       └── Extensions/
├── ImposterGameTests/
├── ImposterGameUITests/
├── docs/
│   └── GAME_PLAN.md
└── README.md
```

---

## 🎮 Features

### Free Tier
- 3 basic word categories
- Up to 15 players
- Ad-supported (banner + interstitials every 2 rounds)

### 🌟 Imposter VIP (Premium)
- 10+ word categories with 500+ words
- Custom word lists (your own inside jokes!)
- Ad-free experience
- Exclusive animations & themes

**Pricing:**
| Plan | Price |
|---|---|
| Weekly | $1.99 |
| Monthly | $4.99 |
| Annually | $29.99 |

---

## 🎨 Design System

- **Mode**: Dark-first design
- **Colors**: Neon green, vivid red, electric purple, glassmorphism overlays
- **Typography**: Poppins / Rubik (bold, modern, high-legibility)
- **Animations**: Spring-based transitions, haptic feedback on role reveal, dramatic voting reveals

---

## 🗺 Roadmap

- [ ] v1.0 — Core gameplay loop (Setup → Reveal → Vote)
- [ ] v1.1 — Firebase word bank integration
- [ ] v1.2 — StoreKit 2 subscriptions & paywall
- [ ] v1.3 — AdMob integration
- [ ] v1.4 — Localization (UA, RU, EN)
- [ ] v2.0 — Custom categories (Premium)
- [ ] v2.1 — Multiple imposters mode
- [ ] v2.2 — Special roles (Informant, etc.)
- [ ] v2.3 — Party modes (Rapid Fire, Blind Imposter)

---

## 🚀 Getting Started

### Prerequisites
- Xcode 15+
- iOS 16+ deployment target
- CocoaPods or Swift Package Manager
- A Firebase project with Firestore enabled
- Google AdMob account

### Setup
```bash
# Clone the repo
git clone https://github.com/Nickolay1304/imposter-game-ios.git
cd imposter-game-ios

# Install dependencies (if using CocoaPods)
pod install

# Open in Xcode
open ImposterGame.xcworkspace
```

Add your `GoogleService-Info.plist` to the `ImposterGame/Resources/` folder.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  Made with ❤️ by <a href="https://github.com/Nickolay1304">Nickolay</a>
</div>
