import 'package:flutter/material.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';
import 'package:isk_aps_calc/data/model/history_model.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_convert_model.dart';
import 'package:isk_aps_calc/data/model/new_simulation_model.dart';
import 'package:isk_aps_calc/ui/component/custom_appbar.dart';
import 'package:isk_aps_calc/ui/page/simulation/result_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static String tag = '/home';
  final Function goToPage;

  HomePage({this.goToPage});

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HistoryModel> histories = [
    HistoryModel(
      id: 0,
      institute: 'user.institute',
      studyProgram: 'studyProgramName',
      educationStage: 1,
      educationStageName: 'S1',
      indicatorDetail: 'indicatorDetail',
      variables: {'NDTPS': 1},
      result: 'Rank',
      resultDetail: 'jsonEncode(mapIndicator)',
      userId: '0',
      updateDateTime: DateTime.now().toString(),
    ),
  ];

  void onTapHistoryItem(int index) {
    NewSimulationModel historySimulation = NewSimulationModel(
      educationStage: histories[index].educationStage,
      educationStageName: histories[index].educationStageName,
      studyProgramName: histories[index].studyProgram,
    );
    Provider.of<SimulationBloc>(context, listen: false).newSimulation =
        historySimulation;

    List<MappingIndicatorModel> mapIndicator = List();
    histories[index].resultDetail.forEach((data) {
      mapIndicator.add(MappingIndicatorModel.fromJson(data));
    });
    Provider.of<SimulationBloc>(context, listen: false).mapIndicator =
        mapIndicator;

    Provider.of<SimulationBloc>(context, listen: false).resultConvert =
        MappingRankedConvertModel(rankedConvert: histories[index].result);

    Navigator.pushNamed(context, ResultPage.tag);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SimulationBloc>(context, listen: false)
        .getHistories()
        .then((data) {
      setState(() {
        histories = data;
      });
    });
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
        child: new Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(
                    bottom: 0, left: 16, right: 16, top: 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      newSimulationCard(),
                    ])),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 0, left: 16, right: 16, top: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _simulationHistoryTitle(),
                  ]),
            ),
            new Expanded(
              child: new ListView(
                padding:
                    const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 0),
                children: <Widget>[
                  cardSimulationHistoryContainer(),
                ],
              ),
            ),
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
                padding: const EdgeInsets.only(right: 8),
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

  Widget cardSimulationHistoryContainer() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(
        top: 8,
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0),
            ...List.generate(histories.length, (index) {
              return _simulationHistoryItem(
                index: index,
                title:
                    '${histories[index].educationStageName} ${histories[index].studyProgram}',
                description: 'Lorem Ipsum',
              );
            })
          ],
        ),
      ),
    );
  }

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
    int index,
    String title,
    String description,
  }) =>
      Container(
        key: UniqueKey(),
        margin: EdgeInsets.symmetric(vertical: 4.0),
        child: SizedBox(
          width: double.infinity,
          height: 65,
          child: OutlineButton(
            onPressed: () {
              onTapHistoryItem(index);
            },
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
