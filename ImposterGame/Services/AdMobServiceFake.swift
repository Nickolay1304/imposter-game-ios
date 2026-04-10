import Foundation

final class AdMobServiceFake: AdMobServicing {
    var isPremium: Bool {
        didSet {
            if isPremium {
                _bannerVisible = false
            }
        }
    }

    private var _bannerVisible: Bool = false
    var bannerVisible: Bool { _bannerVisible }

    private var counter: AdRoundCounter
    private(set) var interstitialsShown: Int = 0
    private(set) var preloadCallCount: Int = 0
    private(set) var showInterstitialCallCount: Int = 0
    private var interstitialReady: Bool = false
    private let preloadLatencyNanos: UInt64

    init(
        initialIsPremium: Bool = false,
        roundsBetweenInterstitials: Int = 2,
        preloadLatencyMilliseconds: Int = 100
    ) {
        self.isPremium = initialIsPremium
        self.counter = AdRoundCounter(threshold: roundsBetweenInterstitials)
        self.preloadLatencyNanos = UInt64(max(0, preloadLatencyMilliseconds)) * 1_000_000
    }

    func configure(roundsBetweenInterstitials: Int) {
        counter = AdRoundCounter(threshold: roundsBetweenInterstitials)
    }

    func showBanner() {
        guard !isPremium else { return }
        _bannerVisible = true
    }

    func hideBanner() {
        _bannerVisible = false
    }

    func preloadInterstitial() async {
        preloadCallCount += 1
        if preloadLatencyNanos > 0 {
            try? await Task.sleep(nanoseconds: preloadLatencyNanos)
        }
        if !isPremium {
            interstitialReady = true
        }
    }

    func trackRoundCompleted() async -> Bool {
        guard !isPremium else { return false }
        let shouldShow = counter.registerRound()
        if shouldShow {
            return await showInterstitialIfReady()
        }
        return false
    }

    func showInterstitialIfReady() async -> Bool {
        showInterstitialCallCount += 1
        guard !isPremium else { return false }
        guard interstitialReady else { return false }
        interstitialsShown += 1
        interstitialReady = false
        return true
    }

    func resetRoundCounter() {
        counter.reset()
    }
}
