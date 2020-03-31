import 'package:flutter/material.dart';

import 'package:isk_aps_calc/contants.dart';

class HomePage extends StatefulWidget {
  static String tag = "home-page";

  Function goToPage;

  HomePage({Function goToPage = null}) {
    this.goToPage = goToPage;
  }


  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final cardNewSimulation = GestureDetector(
      onTap: () {
        widget.goToPage(1);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.5)),
        color: Color.fromRGBO(130, 130, 130, 0.8),
        child: Container(
          padding: EdgeInsets.all(16),
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  maxRadius: 16.0,
                  backgroundColor: Constants.PRIMARY_COLOR,
                  child: Icon(
                    Icons.add_circle,
                    color: Constants.ACCENT_COLOR
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      Constants.NEW_SIMULATION,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
    
    final _txtSimulationHistory = Text(
      Constants.SIMULATION_HISTORY,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );

    final _btnSimulationHistoryItem = Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: SizedBox(
        width: double.infinity,
        height: 85,
        child: OutlineButton(
          onPressed: () {},
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.assignment,
                        color: Constants.ACCENT_COLOR,
                        size: 36.0,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Judul Simulasi",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Ringkasan Simulasi",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ),
      ),
    );

    final cardSimulationHistoryContainer = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(
        top: 32,
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _txtSimulationHistory,
              _btnSimulationHistoryItem
            ]),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[cardNewSimulation, cardSimulationHistoryContainer],
        ),
      ),
    );
  }
}
