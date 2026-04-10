## GitHub Issues — Imposter Game iOS

Use these as the initial backlog. Copy each block into a GitHub Issue.

---

### 🏗 Epic 1: Core Architecture & Setup
**Labels:** `setup`, `architecture`

- [ ] Initialize Xcode project (iOS 16+, SwiftUI, MVVM)
- [ ] Set up Firebase project & add `GoogleService-Info.plist`
- [ ] Configure Swift Package Manager dependencies
- [ ] Set up app icon, launch screen, and Info.plist
- [ ] Create base navigation flow (NavigationStack)

---

### 🎮 Epic 2: Gameplay Core Loop
**Labels:** `feature`, `gameplay`

- [ ] `GameSetupView` — player count stepper + category picker
- [ ] `GameSessionViewModel` — role assignment logic (random Imposter)
- [ ] `PassAndPlayView` — "Pass to Player X" screen
- [ ] `RoleRevealView` — hold-to-reveal mechanic with haptics
- [ ] `ActiveGameView` — timer + player list
- [ ] `VotingView` — tap-to-vote grid
- [ ] Results reveal — animation + score

---

### 🔥 Epic 3: Firebase Integration
**Labels:** `backend`, `firebase`

- [ ] Firestore schema setup (categories, words, isPremium)
- [ ] `FirestoreService.swift` — fetch categories & words
- [ ] Firebase Remote Config — ad frequency flags
- [ ] Offline fallback with local bundled word bank JSON

---

### 💰 Epic 4: Monetization
**Labels:** `monetization`

- [ ] StoreKit 2 — define subscription products in App Store Connect
- [ ] `StoreKitService.swift` — purchase, restore, subscription status
- [ ] `PaywallView.swift` — 3-tier pricing UI
- [ ] AdMob — banner ads on menu, interstitials after rounds
- [ ] Premium gate on locked categories

---

### 🎨 Epic 5: Design & Animations
**Labels:** `design`, `animation`

- [ ] Design system: colors, fonts (Poppins/Rubik), spacing tokens
- [ ] Dark mode glassmorphism card components
- [ ] Role reveal animation (flash red for Imposter)
- [ ] Voting reveal dramatic animation
- [ ] Micro-interactions on all interactive elements

---

### 🌍 Epic 6: Localization
**Labels:** `localization`

- [ ] String Catalogs setup
- [ ] English (EN)
- [ ] Ukrainian (UK)
- [ ] Russian (RU)
