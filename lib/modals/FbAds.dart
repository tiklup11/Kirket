import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:umiperer/modals/constants.dart';

class FbAds {
  bool _isInterstitialAdLoaded = false;

  Future<void> initFbAudienceNetwork() {
    return FacebookAudienceNetwork.init(
      testingId: "2312433698835503_2964944860251047",
    );
  }

  void showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else
      print("Interstial Ad not yet loaded!");
  }

  bool loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: K_INTERSTIAL_ID,
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;
        else
          print(InterstitialAdResult.ERROR);

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          loadInterstitialAd();
        }
      },
    );
    return _isInterstitialAdLoaded;
  }
}
