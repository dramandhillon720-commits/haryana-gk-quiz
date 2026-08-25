import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdService {
  static const String _adUnitId =
      'ca-app-pub-282749442435072/8841184447';

  InterstitialAd? _ad;

  void load() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _ad = ad,
        onAdFailedToLoad: (_) => _ad = null,
      ),
    );
  }

  void show() {
    final ad = _ad;
    if (ad == null) {
      load();
      return;
    }
    _ad = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        load();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        load();
      },
    );
    ad.show();
  }

  void dispose() {
    _ad?.dispose();
  }
}
