import 'package:flutter/material.dart';

class MyDoge extends StatelessWidget {
  final int number;
  MyDoge(this.number);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 90,
      child: Image.asset('images/dogeship$number.png'),
    );
  }
}
