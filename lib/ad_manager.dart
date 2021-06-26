import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7998703838603722~6875778190";
      // } else if (Platform.isIOS) {
      //   return "ca-app-pub-3940256099942544~2594085930";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  // static String get bannerAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-3940256099942544/8865242552";
  //     // } else if (Platform.isIOS) {
  //     //   return "ca-app-pub-3940256099942544/4339318960";
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7998703838603722/2936533186";
      // } else if (Platform.isIOS) {
      //   return "ca-app-pub-3940256099942544/3964253750";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7998703838603722/5484828993";
      // } else if (Platform.isIOS) {
      //   return "ca-app-pub-3940256099942544/7552160883";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
