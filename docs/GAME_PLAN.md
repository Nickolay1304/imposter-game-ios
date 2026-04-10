# Imposter Game: Complete App Plan & Architecture

## Overview
"Imposter Game" is a local-multiplayer party game for 3–15 players on a single iOS device. It utilizes social deduction where players describe a secret word, and one player (the imposter) bluffs to avoid detection. The core user flow involves passing a single device around in a circle, reading a role, and taking turns speaking aloud.

---

## 1. Suggested Technologies
- **Frontend / UI**: Swift & SwiftUI (Declarative UI, perfect for rapid prototyping and fluid, responsive animations).
- **Architecture**: MVVM (Model-View-ViewModel) or TCA (The Composable Architecture) for state management.
- **Backend & Database**: Firebase (Firestore for fetching/updating word banks, Firebase Auth for optional anonymous sign-in, Firebase Functions for backend logic).
- **Monetization**: StoreKit 2 (for subscriptions/IAP) + Google AdMob (for Ads).
- **Analytics / Crashlytics**: Firebase Analytics & Crashlytics.
- **Localization**: Apple's native String Catalogs for multi-language support from Day 1.

---

## 2. Features & Workflow

### Gameplay Mechanics Workflow
1. **Game Setup**: Host selects number of players (1-15), category (e.g., Food, Movies), and round length. No user accounts required.
2. **Role Assignment**: App randomly assigns "Imposter" to 1 (or more) players and fetches a secret word from the backend/local DB for the rest.
3. **Pass & Play Reveal**: 
    - Device displays "Pass to Player 1".
    - Player 1 taps to reveal. Sees the secret word (or "You are the Imposter").
    - Hides the word. Device says "Pass to Player 2".
4. **Gameplay Loop**: 
    - Timer starts (optional).
    - Players take turns saying one word related to the secret word.
    - Imposter must bluff based on context clues from other players.
5. **Voting & Resolution**:
    - Once round ends, players vote on who the Imposter is.
    - Reveal Imposter. Win/Loss calculated.

### Subscription & Monetization Setup
- **Freemium Model**: 
    - Free tier includes 3 basic categories and ad breaks (interstitials after every 2 rounds, banner ads on the menu).
- **Premium Tier (Imposter VIP)**: 
    - Unlocks all 10+ categories and 500+ words.
    - Removes all ads.
    - Suggested Pricing: Weekly ($1.99), Monthly ($4.99), Annually ($29.99).
- **Handling**: Use StoreKit 2 `Product.SubscriptionInfo` to check active status on app launch and seamlessly toggle premium UI/data.

---

## 3. Screen Structure & Wireframe Plan

1. **Launch / Splash Screen**
   - High-contrast imposter character animation (e.g., an eye looking around shiftily).
2. **Main Menu**
   - Play Button (prominent block color).
   - "Get Premium" banner (if free tier).
   - Settings (Language, Sound/Haptics).
   - Ad Banner at bottom.
3. **Lobby / Game Setup**
   - Stepper for Player Count (3-15).
   - Grid of Categories (Locked categories show padlock icon).
   - "Start Game" button.
4. **Pass & Play Screen**
   - "Pass to Player X" instruction.
   - "Hold to Reveal" button to prevent accidental glimpses.
5. **Role Reveal Screen**
   - Secret Word (or Imposter status) shown clearly.
   - "Hide" button to confirm receipt.
6. **Active Gameplay Screen**
   - Minimalist screen showing category, timer (optional), and player list.
7. **Voting & Results Screen**
   - Grid of player buttons for voting.
   - Dramatic animation revealing the imposter.
   - "Play Again" or "Main Menu".
8. **Paywall / Subscription Screen**
   - Benefit list (Unlock 500+ words, No Ads).
   - 3-tier pricing boxes (Weekly, Monthly, Annual).
   - Restore Purchases, TOS, and Privacy Policy links.

---

## 4. Backend Structure & APIs

While local play doesn't *require* a heavy backend, a cloud setup allows seamless scaling and live updates for words without constantly pushing App Store updates.

- **Firestore Database Structure**:
    - `categories` (Collection)
        - `categoryId` (Document)
            - `name` (String: e.g., "Food", "Places")
            - `isPremium` (Boolean)
            - `words` (Array of Strings)
            - `icon` (String: Name of SF Symbol)
            - `localization` (Map for multi-language support, keyed by ISO code)
- **Firebase Remote Config**: 
    - Use this for Feature Flags, controlling ad frequency (e.g., show ad every 3 games instead of 2), and A/B testing paywall pricing/designs.
- **APIs**:
    - AdMob SDK for Ads.
    - Apple StoreKit API for purchasing.

---

## 5. UI/UX Suggestions & Animations

- **Aesthetics**: Dark mode dominant, vibrant neon colors (neon green, vivid red, electric purple) to give a secretive, "undercover spy" or "among us" vibe. Glassmorphism for cards and overlays.
- **Animations**:
    - *Role Reveal*: Gentle haptic feedback when holding the reveal button. The screen dissolves into the secret word, but flashes red aggressively with a heavy vibration if the player is the Imposter.
    - *Timer*: A ticking bomb or shrinking circle for added tension.
    - *Voting Reveal*: Dramatic pause with heartbeat sound effects, followed by a confetti burst (if crew wins) or a menacing shadow/glitch animation (if imposter wins).
    - *Micro-interactions*: Smooth spring-based `.animation(.spring())` transitions when tapping player avatars or moving between setup steps.
- **Typography**: A bold, modern sans-serif font (e.g., Poppins, Rubik, or a custom playful font) to maintain high legibility even when passing the phone quickly.

---

## 6. Optional Enhancements for Replayability

1. **Multiple Imposters**: For groups of 7+, allow 2 or more imposters who don't know each other.
2. **Custom Categories**: Let premium users type in their own custom secret words (e.g., inside jokes) and save lists.
3. **Power-ups & Roles**: Introduce special roles (e.g., "The Informant" who knows who the imposter is but shouldn't reveal themselves too obviously, otherwise the imposter can guess their identity to win).
4. **Party Modes**: 'Rapid Fire' (5 seconds to say a word) or 'Blind Imposter' (imposter doesn't even know they are the imposter until they reveal it live).
