import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutOfStockeWidget extends StatelessWidget {
  final double fontSize;
  final bool isStore;
  OutOfStockeWidget({this.fontSize = 8, this.isStore = false});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            color: Colors.black.withOpacity(0.2)),
        child: Text(
          "Out of stock",
          textAlign: TextAlign.center,
          style:
              robotoRegular.copyWith(color: Colors.white, fontSize: fontSize),
        ),
      ),
    );
  }
}
