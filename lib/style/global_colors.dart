import 'package:flutter/material.dart';

/*
--shark: #24282c;
--iron: #e6e7e8;
--nevada: #696b6d;
--abbey: #4d4f52;
--corduroy: #586565;
--mid-gray: #5b5b64;
--cape-cod: #394646;
--granny-smith: #8ea1a3;
--manatee: #91939c;
*/

class MyColor {
  final Color color;

  const MyColor._(this.color);

  factory MyColor.black() {
    return const MyColor._(Color(0xFF000000));
  }

  factory MyColor.white() {
    return const MyColor._(Color(0xFFFFFFFF));
  }
  
  factory MyColor.shark() {
    return const MyColor._(Color(0xFF24282C));
  }

  factory MyColor.iron() {
    return const MyColor._(Color(0xFFE6E7E8));
  }

  factory MyColor.nevada() {
    return const MyColor._(Color(0xFF696B6D));
  }

  factory MyColor.abbey() {
    return const MyColor._(Color(0xFF4D4F52));
  }

  factory MyColor.corduroy() {
    return const MyColor._(Color(0xFF586565));
  }

  factory MyColor.midGray() {
    return const MyColor._(Color(0xFF5B5B64));
  }

  factory MyColor.capeCod() {
    return const MyColor._(Color(0xFF394646));
  }

  factory MyColor.grannySmith() {
    return const MyColor._(Color(0xFF8EA1A3));
  }

  factory MyColor.manatee() {
    return const MyColor._(Color(0xFF91939C));
  }
}
