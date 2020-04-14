import 'package:flutter/material.dart';

import 'package:isk_aps_calc/constants.dart';

class CustomRoundedButton extends StatelessWidget {
  CustomRoundedButton({
    this.items,
    this.onPressed,
    this.align = MainAxisAlignment.spaceBetween,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
    this.color = Constants.accentColor,
  });

  final List<Widget> items;
  final Function onPressed;
  final MainAxisAlignment align;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: onPressed,
      padding: padding,
      color: color,
      child: Row(
        mainAxisAlignment: align,
        children: items,
      ),
    );
  }
}
