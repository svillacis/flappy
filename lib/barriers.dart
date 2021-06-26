import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final size;

  MyBarrier({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: size,
      decoration: BoxDecoration(
        color: Color(0xffA8A9AD),
        border: Border.all(
          width: 5,
          color: Color(0xff757575),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
