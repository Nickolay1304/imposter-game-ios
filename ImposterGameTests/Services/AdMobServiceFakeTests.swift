import XCTest
@testable import ImposterGame

final class AdMobServiceFakeTests: XCTestCase {

    func testShowBannerRevealsWhenNotPremium() {
        let sut = AdMobServiceFake(preloadLatencyMilliseconds: 0)
        sut.showBanner()
        XCTAssertTrue(sut.bannerVisible)
    }

    func testShowBannerIgnoredWhenPremium() {
        let sut = AdMobServiceFake(initialIsPremium: true, preloadLatencyMilliseconds: 0)
        sut.showBanner()
        XCTAssertFalse(sut.bannerVisible)
    }

    func testTogglingPremiumHidesBanner() {
        let sut = AdMobServiceFake(preloadLatencyMilliseconds: 0)
        sut.showBanner()
        XCTAssertTrue(sut.bannerVisible)
        sut.isPremium = true
        XCTAssertFalse(sut.bannerVisible)
    }

    func testRoundCounterShowsInterstitialAtThreshold() async {
        let sut = AdMobServiceFake(
            roundsBetweenInterstitials: 2,
            preloadLatencyMilliseconds: 0
        )
        await sut.preloadInterstitial()

        let first = await sut.trackRoundCompleted()
        XCTAssertFalse(first)
        XCTAssertEqual(sut.interstitialsShown, 0)

        await sut.preloadInterstitial()
        let second = await sut.trackRoundCompleted()
        XCTAssertTrue(second)
        XCTAssertEqual(sut.interstitialsShown, 1)
    }

    func testRoundCounterResets() async {
        let sut = AdMobServiceFake(
            roundsBetweenInterstitials: 2,
            preloadLatencyMilliseconds: 0
        )
        await sut.preloadInterstitial()
        _ = await sut.trackRoundCompleted()
        sut.resetRoundCounter()
        let result = await sut.trackRoundCompleted()
        XCTAssertFalse(result)
    }

    func testPremiumBlocksInterstitials() async {
        let sut = AdMobServiceFake(
            initialIsPremium: true,
            roundsBetweenInterstitials: 1,
            preloadLatencyMilliseconds: 0
        )
        await sut.preloadInterstitial()
        let shown = await sut.trackRoundCompleted()
        XCTAssertFalse(shown)
        XCTAssertEqual(sut.interstitialsShown, 0)
    }

    func testShowInterstitialIfReadyReturnsFalseWithoutPreload() async {
        let sut = AdMobServiceFake(preloadLatencyMilliseconds: 0)
        let shown = await sut.showInterstitialIfReady()
        XCTAssertFalse(shown)
    }

    func testPreloadCountTracked() async {
        let sut = AdMobServiceFake(preloadLatencyMilliseconds: 0)
        await sut.preloadInterstitial()
        await sut.preloadInterstitial()
        XCTAssertEqual(sut.preloadCallCount, 2)
    }

    func testConfigureChangesThreshold() async {
        let sut = AdMobServiceFake(
            roundsBetweenInterstitials: 3,
            preloadLatencyMilliseconds: 0
        )
        sut.configure(roundsBetweenInterstitials: 1)
        await sut.preloadInterstitial()
        let shown = await sut.trackRoundCompleted()
        XCTAssertTrue(shown)
    }
}
