import 'package:flutter/material.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/ui/component/custom_appbar.dart';

class HomePage extends StatefulWidget {
  static String tag = '/home';

  HomePage({this.goToPage});

  final Function goToPage;

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
  Widget build(context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            newSimulationCard(),
            cardSimulationHistoryContainer(),
          ],
        ),
      ),
    );
  }

  Widget newSimulationCard() => GestureDetector(
        onTap: () {
          widget.goToPage(1);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.5),
            image: DecorationImage(
              image: AssetImage('assets/images/new_simulation_card_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(16),
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  maxRadius: 16.0,
                  backgroundColor: Constants.primaryColor,
                  child: Icon(Icons.add_circle, color: Constants.accentColor),
                ),
              ),
              Flexible(
                child: Row(
                  children: <Widget>[
                    Text(
                      Constants.newSimulation,
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
      );

  Widget cardSimulationHistoryContainer() => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(
          top: 32,
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _simulationHistoryTitle(),
              SizedBox(height: 10.0),
              for (var i = 0; i < 4; i++)
                _simulationHistoryItem(
                  id: '1',
                  title: '1',
                  description:
                      'fadil aja asldjasldjasldjlasjdlasjldjaslo asdhjasldhaskhdkashdkashkdhsakhdkashdkashdkashdkashkdhask',
                )
            ],
          ),
        ),
      );

  Widget _simulationHistoryTitle() => Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Flexible(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      Constants.simulationHistory,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Divider(
                      thickness: 2,
                      color: Constants.accentColor,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );

  Widget _simulationHistoryItem({
    String title,
    String description,
    String id,
  }) =>
      Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          width: double.infinity,
          height: 85,
          child: OutlineButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.assignment,
                            color: Constants.accentColor,
                            size: 36.0,
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                description,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
        ),
      );
}
