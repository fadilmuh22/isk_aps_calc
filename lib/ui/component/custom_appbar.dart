import 'package:flutter/material.dart';

import 'package:isk_aps_calc/constants.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final double appBarHeight = 80.0;
  @override
  get preferredSize => Size.fromHeight(appBarHeight);

  final String educationStageName, studyProgramName;
  final bool newSimulation;

  CustomAppBar({
    this.educationStageName = '',
    this.studyProgramName = '',
    this.newSimulation = false,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  isProdiAndNameEmpty() =>
      (widget.educationStageName.isEmpty && widget.studyProgramName.isEmpty);

  @override
  Widget build(context) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      decoration: BoxDecoration(
        color: Constants.primaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.educationStageName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Flexible(
                child: Text(
                  widget.studyProgramName,
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
}
