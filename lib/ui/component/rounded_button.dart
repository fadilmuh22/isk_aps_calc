import 'package:flutter/material.dart';

import 'package:isk_aps_calc/constants.dart';

class RoundedButton extends StatelessWidget {
  
  RoundedButton({
    this.items,
    this.onPressed,
    this.align = MainAxisAlignment.spaceBetween,
    this.padding = const EdgeInsets.fromLTRB(36.0, 16.0, 36.0, 16.0),
    this.color = Constants.accentColor,
  });

  final List<Widget> items;
  final Function onPressed;
  final MainAxisAlignment align;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      onPressed: onPressed,
      padding: padding,
      color: color,
      child: Row(
        mainAxisAlignment: align,
        children: items
      ),
    );
  }
}