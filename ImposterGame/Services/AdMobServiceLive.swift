import Foundation

#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

final class AdMobServiceLive: AdMobServicing {
    var isPremium: Bool = false {
        didSet {
            if isPremium {
                _bannerVisible = false
            }
        }
    }

    private var _bannerVisible: Bool = false
    var bannerVisible: Bool { _bannerVisible }

    private var counter: AdRoundCounter

    init(roundsBetweenInterstitials: Int = 2) {
        self.counter = AdRoundCounter(threshold: roundsBetweenInterstitials)
    }

    func configure(roundsBetweenInterstitials: Int) {
        counter = AdRoundCounter(threshold: roundsBetweenInterstitials)
    }

    func showBanner() {
        guard !isPremium else { return }
        #if canImport(GoogleMobileAds)
        // TODO: Epic 4 — create GADBannerView, attach to view hierarchy, loadRequest.
        fatalError("TODO: Epic 4 — implement showBanner()")
        #else
        fatalError("AdMobServiceLive requires GoogleMobileAds — wire up in Epic 4")
        #endif
    }

    func hideBanner() {
        _bannerVisible = false
        #if canImport(GoogleMobileAds)
        // TODO: Epic 4 — remove banner from view hierarchy.
        #endif
    }

    func preloadInterstitial() async {
        guard !isPremium else { return }
        #if canImport(GoogleMobileAds)
        // TODO: Epic 4 — GADInterstitialAd.load(with:request:completionHandler:).
        fatalError("TODO: Epic 4 — implement preloadInterstitial()")
        #else
        fatalError("AdMobServiceLive requires GoogleMobileAds — wire up in Epic 4")
        #endif
    }

    func trackRoundCompleted() async -> Bool {
        guard !isPremium else { return false }
        if counter.registerRound() {
            return await showInterstitialIfReady()
        }
        return false
    }

    func showInterstitialIfReady() async -> Bool {
        guard !isPremium else { return false }
        #if canImport(GoogleMobileAds)
        // TODO: Epic 4 — present loaded GADInterstitialAd from top view controller.
        fatalError("TODO: Epic 4 — implement showInterstitialIfReady()")
        #else
        fatalError("AdMobServiceLive requires GoogleMobileAds — wire up in Epic 4")
        #endif
    }

    func resetRoundCounter() {
        counter.reset()
    }
}
