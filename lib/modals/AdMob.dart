// import 'package:firebase_admob/firebase_admob.dart';
//
// class CustomAdMob{
//
//   MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//     keywords: <String>['flutterio', 'beautiful apps'],
//     contentUrl: 'https://flutter.io',
//     childDirected: false,
//     testDevices: <String>[], // Android emulators are considered test devices
//   );
//
//   BannerAd bannerAd(){
//     return BannerAd(
//       adUnitId: BannerAd.testAdUnitId,
//       size: AdSize.smartBanner,
//       targetingInfo: targetingInfo,
//       listener: (MobileAdEvent event) {
//         print("BannerAd event is $event");
//       },
//     );
//   }
//
//   InterstitialAd interstitialAd(){
//     return InterstitialAd(
//       adUnitId: InterstitialAd.testAdUnitId,
//       targetingInfo: targetingInfo,
//       listener: (MobileAdEvent event) {
//         print("InterstitialAd event is $event");
//       },
//     );
//   }
// }