import Foundation

protocol AdMobServicing: AnyObject {
    var isPremium: Bool { get set }
    var bannerVisible: Bool { get }

    func configure(roundsBetweenInterstitials: Int)
    func showBanner()
    func hideBanner()
    func preloadInterstitial() async
    func trackRoundCompleted() async -> Bool
    func showInterstitialIfReady() async -> Bool
    func resetRoundCounter()
}

struct AdRoundCounter {
    private(set) var roundsSinceLastInterstitial: Int = 0
    var threshold: Int

    init(threshold: Int) {
        self.threshold = max(1, threshold)
    }

    mutating func registerRound() -> Bool {
        roundsSinceLastInterstitial += 1
        if roundsSinceLastInterstitial >= threshold {
            roundsSinceLastInterstitial = 0
            return true
        }
        return false
    }

    mutating func reset() {
        roundsSinceLastInterstitial = 0
    }
}
