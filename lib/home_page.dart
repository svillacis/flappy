import 'package:firebase_admob/firebase_admob.dart';
import 'package:flappy_doge/doge.dart';
import 'package:flutter/material.dart';
import 'store.dart';
import 'size_config.dart';
import 'barriers.dart';
import 'constants.dart';
import 'coin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers_with_rate/audio_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'doge.dart';
import 'dart:async';
import 'dart:math';
import 'ad_manager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static AudioCache player = new AudioCache();
  static AudioCache player2 = new AudioCache();
  static AudioCache player3 = new AudioCache();
  var random = new Random();
  static double yaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = yaxis;
  bool started = false;
  static double xone = 1.5;
  double xtwo = xone + 2.5;
  double xcoin = xone + 1.25;
  double xCoinHeight;
  double xOneHeight;
  double xTwoHeight;
  double size;
  double xsize;
  double gCoinHeight;
  double gShipHeight;
  bool crashed = false;
  int score = 0;
  int best = 0;
  int coins = 0;
  int ship = 1;
  int paws = 0;
  bool lost = false;
  bool store = false;
  bool notPlayed = true;
  bool _isInterstitialAdReady;
  bool _isRewardedAdReady;

  Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  InterstitialAd _interstitialAd;

  void _loadRewardedAd() {
    RewardedVideoAd.instance.load(
      targetingInfo: MobileAdTargetingInfo(),
      adUnitId: AdManager.rewardedAdUnitId,
    );
  }

  void _onRewardedAdEvent(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        setState(() {
          _isRewardedAdReady = true;
        });
        break;
      case RewardedVideoAdEvent.closed:
        setState(() {
          _isRewardedAdReady = false;
        });
        _loadRewardedAd();
        break;
      case RewardedVideoAdEvent.failedToLoad:
        setState(() {
          _isRewardedAdReady = false;
        });
        print('Failed to load a rewarded ad');
        break;
      case RewardedVideoAdEvent.rewarded:
        getDoge();
        break;
      default:
      // do nothing
    }
  }

  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        // _moveToHome();
        break;
      default:
      // do nothing
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoins();
    getShip();
    getHScore();
    getPaws();
    setState(() {
      setOneHeight();
      setTwoHeight();
      setCoinHeight();
    });
    _isInterstitialAdReady = false;
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );
    _loadInterstitialAd();
    _isRewardedAdReady = false;
    RewardedVideoAd.instance.listener = _onRewardedAdEvent;
    _loadRewardedAd();
  }

  @override
  void dispose() {
    // TODO: Dispose InterstitialAd object
    _interstitialAd?.dispose();
    RewardedVideoAd.instance.listener = null;
    super.dispose();
  }

  getCoins() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var dcoins = pref.getInt('scoins');
    if (dcoins != null) {
      setState(() {
        coins = pref.getInt('scoins');
      });
    }
  }

  setCoins() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('scoins', coins);
  }

  getShip() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var nship = pref.getInt('nship');
    if (nship != null) {
      setState(() {
        ship = pref.getInt('nship');
      });
    }
  }

  setShip() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('nship', ship);
  }

  getHScore() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var hScore = pref.getInt('hscore');
    if (hScore != null) {
      setState(() {
        best = pref.getInt('hscore');
      });
    }
  }

  setHScore() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('hscore', best);
  }

  getPaws() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var sPaws = pref.getInt('paws');
    if (sPaws != null) {
      setState(() {
        paws = pref.getInt('paws');
      });
    }
  }

  setPaws() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('paws', paws);
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = yaxis;
    });
    player.play('tap.wav');
  }

  void playCrash() {
    if (notPlayed) {
      player2.play('crash.wav');
      notPlayed = false;
    }
  }

  // Future playLocalAsset(String name) async {
  //   AudioCache cache = new AudioCache();
  //   //At the next line, DO NOT pass the entire reference such as assets/yes.mp3. This will not work.
  //   //Just pass the file name only.
  //   return await cache.play("$name.mp3");
  // }

  double generateRandomIncludingNegative() {
    var positive = random.nextBool();
    var randInt = random.nextDouble() / 1.1;

    var result = positive ? randInt : 0 - randInt;
    return result;
  }

  void setOneHeight() {
    xOneHeight = random.nextInt(71).toDouble();
  }

  void setTwoHeight() {
    xTwoHeight = random.nextInt(71).toDouble();
  }

  void setCoinHeight() {
    xCoinHeight = generateRandomIncludingNegative();
  }

  void getCoinHeight() {
    gCoinHeight = size / 2 - size / 2 * xCoinHeight;
  }

  void getShipHeight() {
    gShipHeight = size / 2 - size / 2 * yaxis;
  }

  void checkCrash() {
    if (xone > -1 && xone < 0.14) {
      getShipHeight();
      double bot1 = size / 100 * xOneHeight;
      double top1 = size - size / 100 * (71 - xOneHeight) + 2;
      if (gShipHeight < bot1 || gShipHeight > top1) {
        crashed = true;
        playCrash();
      }
    }
    if (xtwo > -1 && xtwo < 0.14) {
      getShipHeight();
      double bot2 = size / 100 * xTwoHeight;
      double top2 = size - size / 100 * (71 - xTwoHeight) + 2;
      if (gShipHeight < bot2 || gShipHeight > top2) {
        crashed = true;
        playCrash();
      }
    }
  }

  void checkCoin() {
    if (xcoin > -0.6 && xcoin < 0.10) {
      getCoinHeight();
      getShipHeight();
      if (gShipHeight > gCoinHeight - 40 && gShipHeight < gCoinHeight + 40) {
        setState(() {
          coins += 1;
          xCoinHeight = -2;
        });
        player3.play('ding.wav');
        setCoins();
        // incrementCoins();
        // saveIntInLocalMemory('savedCoins', coins);
      }
    }
  }

  void updateScore() {
    score += 1;
    if (score > best) {
      best = score;
      setHScore();
    }
  }

  void revive() {
    // getShip();
    if (paws >= 1) {
      setState(() {
        paws -= 1;
        yaxis = 0;
        time = 0;
        height = 0;
        initialHeight = yaxis;
        started = false;
        xone = 1.5;
        xtwo = xone + 2.5;
        xcoin = xone + 1.25;
        crashed = false;
        lost = false;
        notPlayed = true;
      });
      setPaws();
      startGame();
    } else {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("Not enough paws."),
                content: new Text("Buy more paws with Doge Coin to revive."),
                actions: <Widget>[
                  FlatButton(
                    child: Text('X'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
  }

  void getDoge() {
    setState(() {
      coins += 10;
    });
    setCoins();
  }

  void restart() {
    //getShip();
    setState(() {
      yaxis = 0;
      time = 0;
      height = 0;
      initialHeight = yaxis;
      started = false;
      xone = 1.5;
      xtwo = xone + 2.5;
      xcoin = xone + 1.25;
      crashed = false;
      score = 0;
      lost = false;
      notPlayed = true;
    });
  }

  void startGame() {
    setCoins();
    started = true;
    Timer.periodic(Duration(milliseconds: 40), (timer) {
      checkCrash();
      checkCoin();
      time += 0.033;
      height = -3.5 * time * time + 2 * time;
      if (crashed) {
        setState(() {
          yaxis += 0.1;
        });
      }
      if (!crashed) {
        setState(
          () {
            setState(() {
              yaxis = initialHeight - height;
            });
            if (xone < -2.5) {
              setOneHeight();
              xone += 5;
              updateScore();
            } else {
              xone -= 0.047;
            }
            if (xtwo < -2.5) {
              setTwoHeight();
              xtwo += 5;
              updateScore();
            } else {
              xtwo -= 0.047;
            }
            if (xcoin < -2.5) {
              setCoinHeight();
              xcoin += 5;
            } else {
              xcoin -= 0.047;
            }
          },
        );
      }

      if (yaxis > 1.1) {
        timer.cancel();
        started = false;
        lost = true;
        player2.play('crash.wav');
        if (_isInterstitialAdReady) {
          _interstitialAd.show();
        }
      }
    });
  }

  void refreshData() {
    getShip();
    getCoins();
    getPaws();
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    size = SizeConfig.blockSizeVertical * 100;
    xsize = SizeConfig.blockSizeHorizontal * 100;
    return GestureDetector(
      onTap: () {
        if (started) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    color: Color(0xff041324),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    child: Image.asset('images/earth.png'),
                    alignment: Alignment(0, -0.8),
                    width: 100,
                  ),
                  AnimatedContainer(
                    alignment: Alignment(-0.5, yaxis),
                    duration: Duration(milliseconds: 0),
                    child: MyDoge(ship),
                  ),
                  Container(
                    alignment: Alignment(0, -0.4),
                    child: started
                        ? Text('')
                        : Text(
                            'TAP TO PLAY',
                            style: kTitle,
                          ),
                  ),
                  Coin(xcoin, xCoinHeight),
                  BottomBarrier(size / 100 * xOneHeight, xone),
                  TopBarrier(size / 100 * (71 - xOneHeight), xone),
                  BottomBarrier(size / 100 * xTwoHeight, xtwo),
                  TopBarrier(size / 100 * (71 - xTwoHeight), xtwo),
                  Container(
                      alignment: Alignment(0, 0),
                      child: lost
                          ? Container(
                              decoration: BoxDecoration(
                                color: Color(0xff0f4c75),
                                // border: Border.all(
                                //   width: 5,
                                //   color: Colors.white10,
                                // ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: size * 70 / 100,
                              width: xsize * 95 / 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Score: $score',
                                    style: kFinal,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FlatButton(
                                        child: Container(
                                          width: xsize * 35 / 100,
                                          height: size * 20 / 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Revive',
                                                  style: kButton,
                                                ),
                                                FaIcon(
                                                  FontAwesomeIcons.paw,
                                                  color: Colors.black,
                                                  size: 50,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onPressed: revive,
                                      ),
                                      FlatButton(
                                        child: Container(
                                          width: xsize * 35 / 100,
                                          height: size * 20 / 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Replay',
                                                  style: kButton,
                                                ),
                                                Icon(
                                                  Icons.replay,
                                                  color: Colors.black,
                                                  size: 50,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onPressed: restart,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FlatButton(
                                        child: Container(
                                          width: xsize * 35 / 100,
                                          height: size * 20 / 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Store',
                                                  style: kButton,
                                                ),
                                                FaIcon(
                                                  FontAwesomeIcons.store,
                                                  color: Colors.black,
                                                  size: 40,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) => Store(),
                                          ).then(onGoBack);
                                        },
                                      ),
                                      FlatButton(
                                        child: Container(
                                          width: xsize * 35 / 100,
                                          height: size * 20 / 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Doge Coins',
                                                  style: kButton,
                                                ),
                                                Text(
                                                  '(View rewarded ad)',
                                                  style: kButton2,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .video_collection_outlined,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                    Icon(
                                                      Icons.compare_arrows,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                    Container(
                                                      child: Image.asset(
                                                          'images/coin.png'),
                                                      height: 25,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_isRewardedAdReady) {
                                            RewardedVideoAd.instance.show();
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          : Text('')),
                ],
              ),
            ),
            Container(
              height: 10,
              color: Color(0xff5e5853),
            ),
            Expanded(
              child: Container(
                color: Color(0xff94908d),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SCORE',
                              style: kScore,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              score.toString(),
                              style: kScore,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'BEST',
                              style: kScore,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              best.toString(),
                              style: kScore,
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          child: Image.asset('images/coin.png'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          coins.toString(),
                          style: kCoins,
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        FaIcon(
                          FontAwesomeIcons.paw,
                          color: Colors.black38,
                          size: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          paws.toString(),
                          style: kCoins,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopBarrier extends StatelessWidget {
  final double size;
  final double x;

  TopBarrier(this.size, this.x);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment(x, -1.01),
      duration: Duration(milliseconds: 0),
      child: MyBarrier(
        size: size,
      ),
    );
  }
}

class BottomBarrier extends StatelessWidget {
  final double size;
  final double x;

  BottomBarrier(this.size, this.x);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment(x, 1.01),
      duration: Duration(milliseconds: 0),
      child: MyBarrier(
        size: size,
      ),
    );
  }
}

class Coin extends StatelessWidget {
  final double x;
  final double y;

  Coin(this.x, this.y);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment(x, y),
      duration: Duration(milliseconds: 0),
      child: MyCoin(),
    );
  }
}
