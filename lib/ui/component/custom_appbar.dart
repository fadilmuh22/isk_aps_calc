import 'package:flutter/material.dart';

import 'package:isk_aps_calc/constants.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final double appBarHeight = 80.0;
  @override
  get preferredSize => Size.fromHeight(appBarHeight);

  final String tingkat, prodiName;
  final bool newSimulation;

  CustomAppBar({
    this.newSimulation = false,
    this.tingkat = '',
    this.prodiName = '',
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  Widget newSimulaionTitle(int flex) => Expanded(
        flex: flex,
        child: Text(
          'Simulasi Baru',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Constants.accentColor),
        ),
      );

  Expanded newSimulationProdiAndTingkat() => Expanded(
        flex: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Constants.accentColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.tingkat,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Flexible(
                child: Text(
                  widget.prodiName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  isProdiAndNameEmpty() => (widget.prodiName.isEmpty && widget.tingkat.isEmpty);

  @override
  Widget build(context) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        // borderRadius: BorderRadius.only(
        //   topRight: Radius.circular(10.0),
        // ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Constants.accentColor,
              ),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).maybePop();
                }
              },
            ),
          ),
          if (widget.newSimulation) ...[
            Expanded(
              child: Container(),
            ),
            newSimulaionTitle(3),
            Expanded(
              child: Container(),
            ),
          ] else if (!isProdiAndNameEmpty()) ...[
            newSimulaionTitle(2),
            newSimulationProdiAndTingkat()
          ] else
            Expanded(
              flex: 5,
              child: Container(),
            ),
        ],
      ),
    );
  }
}
