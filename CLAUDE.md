# Imposter Game — iOS

Local multiplayer social deduction party game for 3–15 players on a single iOS device (pass-and-play). One player is the Imposter and must bluff without knowing the secret word.

## Tech stack

- **Language / UI**: Swift 5.9, SwiftUI (declarative, spring animations)
- **Architecture**: MVVM. Views are dumb; ViewModels own state and expose `@Published` properties; Services are protocol-based for testability.
- **Min deployment target**: iOS 16
- **Backend**: Firebase — Firestore (categories/words), Remote Config (feature flags, ad frequency, paywall A/B), Anonymous Auth, Analytics, Crashlytics
- **Monetization**: StoreKit 2 (subscriptions) + Google AdMob (banners + interstitials)
- **Localization**: Apple String Catalogs (`.xcstrings`). Languages: EN, UK, RU from day one.
- **Dependencies**: Swift Package Manager (preferred over CocoaPods)

## Project layout

Target structure (most folders don't exist yet — create them as features land):

```
ImposterGame/
├── App/                    # ImposterGameApp.swift (entry point)
├── Models/                 # Player, Category, GameSession — plain value types
├── ViewModels/             # GameSetupViewModel, GameSessionViewModel, SubscriptionViewModel
├── Views/
│   ├── Launch/             # SplashView
│   ├── Menu/               # MainMenuView
│   ├── Setup/              # GameSetupView
│   ├── Gameplay/           # PassAndPlayView, RoleRevealView, ActiveGameView, VotingView
│   └── Paywall/            # PaywallView
├── Services/               # FirestoreService, StoreKitService, AdMobService (protocol + impl)
├── Resources/              # Assets.xcassets, Localizable.xcstrings, GoogleService-Info.plist
└── Utils/                  # HapticManager, Extensions/
ImposterGameTests/          # Unit tests for ViewModels and Services
ImposterGameUITests/        # UI flow tests
docs/                       # GAME_PLAN.md, ISSUES_BACKLOG.md
```

## Game flow (canonical)

1. **Setup** — host picks player count (3–15) and a category
2. **Role assignment** — app randomly picks 1+ Imposter(s); others get the secret word
3. **Pass & play reveal** — "Pass to Player X" → hold-to-reveal (prevents accidental peeks) → word shown → hide
4. **Active round** — each player says one word related to the secret word; optional timer
5. **Vote** — tap-to-vote grid, players pick who they think the Imposter is
6. **Reveal** — dramatic animation, win/loss calculated, "Play Again" or "Main Menu"

The hold-to-reveal mechanic and haptic feedback on Imposter reveal are load-bearing UX — do not remove them when refactoring.

## Monetization model

| Tier | What's included |
|---|---|
| Free | 3 basic categories, banner on menu, interstitial every 2 rounds |
| Imposter VIP | 10+ categories (500+ words), custom word lists, no ads, exclusive themes |

**Pricing**: Weekly $1.99 / Monthly $4.99 / Annually $29.99.

Subscription status is checked on app launch via `Product.SubscriptionInfo`. Premium flag must gate: locked categories, custom word lists, ad display, exclusive themes. Ad frequency is **not** hardcoded — read from Firebase Remote Config so it can be tuned without a release.

## Firestore schema

```
categories/                 # collection
  {categoryId}              # document
    name: String            # "Food", "Movies"
    isPremium: Bool
    icon: String            # SF Symbol name
    words: [String]
    localization: Map       # keyed by ISO code → { name, words }
```

Always ship a bundled JSON fallback of the free categories so the app works offline and on first launch before Firestore responds.

## Design system

- **Mode**: dark-first. Light mode is not a v1 requirement.
- **Palette**: neon green, vivid red, electric purple, glassmorphism overlays
- **Typography**: Poppins or Rubik — bold, modern, high-legibility (readable when phone is being passed quickly)
- **Animations**: spring-based transitions (`.animation(.spring())`); heavy haptic + red flash on Imposter reveal; heartbeat + confetti/glitch on voting reveal
- **Accessibility**: respect Dynamic Type, provide haptic alternatives to audio cues, ensure contrast on neon-on-dark combos

## Roadmap (source of truth: docs/ISSUES_BACKLOG.md)

- **v1.0** — core loop (Setup → Reveal → Vote), local word bank
- **v1.1** — Firestore word bank integration
- **v1.2** — StoreKit 2 subscriptions + paywall
- **v1.3** — AdMob integration
- **v1.4** — Localization (EN, UK, RU)
- **v2.0** — Custom categories (Premium)
- **v2.1** — Multiple imposters (7+ players)
- **v2.2** — Special roles (Informant, etc.)
- **v2.3** — Party modes (Rapid Fire, Blind Imposter)

See [docs/GAME_PLAN.md](docs/GAME_PLAN.md) for the full product spec and [docs/ISSUES_BACKLOG.md](docs/ISSUES_BACKLOG.md) for the epic breakdown.

## Conventions

- **Naming**: `*View` for SwiftUI views, `*ViewModel` for MVVM VMs, `*Service` for side-effectful singletons/protocols, `*Model` avoided (use the domain type name directly: `Player`, `Category`)
- **State**: use `@StateObject` at the view that owns the VM, `@ObservedObject` when passing down, `@EnvironmentObject` only for truly app-global state (subscription status, settings)
- **Concurrency**: prefer Swift Concurrency (`async`/`await`, `Task`) over Combine for new code. Services expose `async` APIs.
- **Navigation**: `NavigationStack` with typed routes (not the legacy `NavigationView`)
- **Testability**: services behind protocols so ViewModels can be tested with fakes. No singletons in ViewModels — inject via init.
- **Feature flags**: anything that might need tuning post-release (ad frequency, paywall variant, free category count) goes through Remote Config, not hardcoded constants
- **Localization**: no hardcoded user-facing strings — everything through String Catalogs from the start, even during prototyping
- **Git**: conventional-ish commit messages, one epic's work per PR where practical

## Current state

The repo contains only planning docs and this file — no Xcode project, no Swift sources yet. First task in the backlog is initializing the Xcode project itself (Epic 1 in [docs/ISSUES_BACKLOG.md](docs/ISSUES_BACKLOG.md)). When asked to implement a feature, check whether the foundation it depends on (project skeleton, Firebase config, base navigation) actually exists before writing code against it.
