import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  int coins = 0;
  int ship = 1;
  int paws = 0;
  bool ship1 = true;
  bool ship2 = false;
  bool ship3 = false;
  bool ship4 = false;

  getCoins() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var dcoins = pref.getInt('scoins');
    if (dcoins != null) {
      setState(() {
        coins = pref.getInt('scoins');
      });
    }
  }

  getShip2() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var nship = pref.getBool('ship2');
    if (nship != null) {
      setState(() {
        ship2 = pref.getBool('ship2');
      });
    }
  }

  setShip2() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('ship2', ship2);
  }

  getShip3() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var nship = pref.getBool('ship3');
    if (nship != null) {
      setState(() {
        ship3 = pref.getBool('ship3');
      });
    }
  }

  setShip3() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('ship3', ship3);
  }

  getShip4() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var nship = pref.getBool('ship4');
    if (nship != null) {
      setState(() {
        ship4 = pref.getBool('ship4');
      });
    }
  }

  setShip4() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('ship4', ship4);
  }

  void buyPaws() {
    if (coins >= 10) {
      setState(() {
        paws += 1;
        coins -= 10;
      });
      setPaws();
      setCoins();
    } else {
      buyDialog();
    }
  }

  buyDialog() {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Not enough coins."),
              content: new Text(
                  "Collect more coins or watch a video to get more Doge Coins."),
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

  equipDialog() {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Ship not available"),
              content: new Text("You have to buy the ship to equip it."),
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

  boughtDialog() {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Bought"),
              content: new Text("Ship already bought"),
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

  void buyShip2() {
    if (!ship2) {
      if (coins >= 100) {
        setState(() {
          ship2 = true;
          coins -= 100;
        });
        setShip2();
        setCoins();
      } else {
        buyDialog();
      }
    } else {
      boughtDialog();
    }
  }

  void buyShip3() {
    if (!ship3) {
      if (coins >= 100) {
        setState(() {
          ship3 = true;
          coins -= 100;
        });
        setShip3();
        setCoins();
      } else {
        buyDialog();
      }
    } else {
      boughtDialog();
    }
  }

  void buyShip4() {
    if (!ship4) {
      if (coins >= 200) {
        setState(() {
          ship4 = true;
          coins -= 200;
        });
        setShip4();
        setCoins();
      } else {
        buyDialog();
      }
    } else {
      boughtDialog();
    }
  }

  equip(int number) async {
    if (number == 1) {
      ship = number;
      setShip();
    } else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var nship = pref.getBool('ship$number');
      if (nship) {
        ship = number;
        setShip();
      } else {
        equipDialog();
      }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoins();
    getShip();
    getPaws();
    getShip2();
    getShip3();
    getShip4();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff041324),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color(0xff0f4c75),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Store',
                  style: kFinal,
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
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Extra Life: ',
                                style: kScore,
                              ),
                              Text(
                                '10',
                                style: kCoins,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                child: Image.asset('images/coin.png'),
                              ),
                            ],
                          ),
                          Container(
                            child: FaIcon(
                              FontAwesomeIcons.paw,
                              size: 100,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            splashColor: Colors.blue,
                            onPressed: () {
                              buyPaws();
                            },
                            child: Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  'Buy',
                                  style: kScore,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 2,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            'Moon Doge',
                            style: kScore,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 200,
                            child: Image.asset('images/dogeship1.png'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            splashColor: Colors.blue,
                            onPressed: () {
                              equip(1);
                            },
                            child: Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  'Equip',
                                  style: kScore,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 2,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Space Doge: ',
                                style: kScore,
                              ),
                              Text(
                                '100',
                                style: kCoins,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                child: Image.asset('images/coin.png'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 200,
                            child: Image.asset('images/dogeship2.png'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FlatButton(
                                splashColor: Colors.blue,
                                onPressed: buyShip2,
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Buy',
                                      style: kScore,
                                    ),
                                  ),
                                ),
                              ),
                              FlatButton(
                                splashColor: Colors.blue,
                                onPressed: () {
                                  equip(2);
                                },
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: ship2
                                        ? Text(
                                            'Equip',
                                            style: kScore,
                                          )
                                        : Icon(
                                            Icons.lock,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 2,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Mars Doge: ',
                                style: kScore,
                              ),
                              Text(
                                '100',
                                style: kCoins,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                child: Image.asset('images/coin.png'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 200,
                            child: Image.asset('images/dogeship3.png'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FlatButton(
                                splashColor: Colors.blue,
                                onPressed: buyShip3,
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Buy',
                                      style: kScore,
                                    ),
                                  ),
                                ),
                              ),
                              FlatButton(
                                splashColor: Colors.blue,
                                onPressed: () {
                                  equip(3);
                                },
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: ship3
                                        ? Text(
                                            'Equip',
                                            style: kScore,
                                          )
                                        : Icon(
                                            Icons.lock,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 2,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'UFO Doge: ',
                                style: kScore,
                              ),
                              Text(
                                '200',
                                style: kCoins,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                child: Image.asset('images/coin.png'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 200,
                            child: Image.asset('images/dogeship4.png'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FlatButton(
                                splashColor: Colors.blue,
                                onPressed: buyShip4,
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Buy',
                                      style: kScore,
                                    ),
                                  ),
                                ),
                              ),
                              FlatButton(
                                splashColor: Colors.blue,
                                onPressed: () {
                                  equip(4);
                                },
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: ship4
                                        ? Text(
                                            'Equip',
                                            style: kScore,
                                          )
                                        : Icon(
                                            Icons.lock,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 2,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
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
