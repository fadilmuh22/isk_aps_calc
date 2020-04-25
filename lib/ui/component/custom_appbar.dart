import 'package:flutter/material.dart';

import 'package:isk_aps_calc/constants.dart';

const normalHeight = 56.0;
const extendedHeight = 72.0;

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  double appBarHeight = normalHeight;

  @override
  get preferredSize => Size.fromHeight(appBarHeight);

  final bool canBack, newSimulation;
  final String educationStageName, studyProgramName;
  final Function onBackButton;

  CustomAppBar({
    this.canBack = true,
    this.educationStageName = '',
    this.studyProgramName = '',
    this.newSimulation = false,
    this.onBackButton,
  }) {
    if (studyProgramName.isNotEmpty) {
      if (studyProgramName.trim().split(' ').length > 1) {
        appBarHeight = extendedHeight;
      }
    }
  }

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  isProdiAndNameEmpty() =>
      (widget.educationStageName.isEmpty && widget.studyProgramName.isEmpty);

  handleBackButton() async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(context) {
    return Container(
      margin: EdgeInsets.only(top: 27.0),
      decoration: BoxDecoration(
        color: Constants.primaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (widget.canBack) ...[
            Expanded(
              child: IconButton(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10.0),
                icon: Icon(
                  Icons.arrow_back,
                  color: Constants.accentColor,
                ),
                onPressed: widget.onBackButton != null
                    ? widget.onBackButton
                    : handleBackButton,
              ),
            ),
          ] else
            Expanded(
              child: Container(),
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
            color: Constants.accentColor,
          ),
        ),
      );

  Expanded newSimulationProdiAndTingkat() => Expanded(
        flex: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Constants.accentColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5.0),
            ),
          ),
          padding: EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.educationStageName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: Text(
                  widget.studyProgramName,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
