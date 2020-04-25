import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';
import 'package:isk_aps_calc/data/model/history_model.dart';
import 'package:isk_aps_calc/data/model/indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_convert_model.dart';
import 'package:isk_aps_calc/data/model/new_simulation_model.dart';
import 'package:isk_aps_calc/ui/component/custom_appbar.dart';
import 'package:isk_aps_calc/ui/page/simulation/indicator_page.dart';
import 'package:isk_aps_calc/ui/page/simulation/result_page.dart';
import 'package:provider/provider.dart';

final List<Map<String, dynamic>> educationStages = [
  {
    'id': 1,
    'name': 'D3',
    'desc': 'Diploma 3',
  },
  {
    'id': 2,
    'name': 'D4',
    'desc': 'Sarjana Terapan',
  },
  {
    'id': 3,
    'name': 'S1',
    'desc': 'Sarjana',
  },
  {
    'id': 4,
    'name': 'S2',
    'desc': 'Magister',
  },
  {
    'id': 5,
    'name': 'S2',
    'desc': 'Magister Terapan',
  },
  {
    'id': 6,
    'name': 'S3',
    'desc': 'Doktor',
  },
  {
    'id': 7,
    'name': 'S3',
    'desc': 'Doktor Terapan',
  },
  {
    'id': 8,
    'name': 'PT',
    'desc': 'Perguruan Tinggi',
  },
  {
    'id': 9,
    'name': 'PT',
    'desc': 'Perguruan Tinggi Vokasi',
  },
];

class HomePage extends StatefulWidget {
  static String tag = '/home';
  final Function goToPage;

  HomePage({this.goToPage});

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HistoryModel> histories;

  Future<Null> getHistories() {
    try {
      return Provider.of<SimulationBloc>(context, listen: false)
          .getHistories()
          .then((data) {
        setState(() {
          histories = data;
          isLoadingHistory = false;
        });
      });
    } catch (e) {
      return null;
    }
  }

  void bindDataHistory(int index) {
    Provider.of<SimulationBloc>(context, listen: false).clear();
    Provider.of<SimulationBloc>(context, listen: false).historyId =
        histories[index].id;
    NewSimulationModel historySimulation = NewSimulationModel(
      educationStage: histories[index].educationStage,
      educationStageName: histories[index].educationStageName,
      studyProgramName: histories[index].studyProgram,
      currentAccreditation: histories[index].currentAccreditation,
    );
    Provider.of<SimulationBloc>(context, listen: false).newSimulation =
        historySimulation;

    Map<String, dynamic> mapVariable = histories[index]
        .variables
        .map((k, v) => MapEntry(k, double.parse('$v').toInt()));

    Provider.of<SimulationBloc>(context, listen: false).mapVariable =
        mapVariable;

    List<MappingIndicatorModel> mapIndicator = List();
    histories[index].resultDetail.forEach((data) {
      var mapInd = MappingIndicatorModel.fromJson(data);
      mapInd.indicator =
          mapInd.indicator.map((ind) => IndicatorModel.fromJson(ind)).toList();
      mapIndicator.add(mapInd);
    });
    Provider.of<SimulationBloc>(context, listen: false).mapIndicator =
        mapIndicator;

    Provider.of<SimulationBloc>(context, listen: false).resultConvert =
        MappingRankedConvertModel(rankedConvert: histories[index].result);
  }

  void onTapResultHistory(int index) {
    bindDataHistory(index);

    Navigator.pushNamed(context, ResultPage.tag);
  }

  onTapEditHistory(int index) {
    bindDataHistory(index);

    Navigator.pushNamed(context, IndicatorPage.tag);
  }

  Future deleteHistory(int index) async {
    messageDialog(
      title: 'Konfirmasi',
      message:
          '''Apakah anda yakin ingin menghapus [${histories[index].id}] ${histories[index].educationStageName} ${histories[index].studyProgram}
      ''',
      actions: [
        FlatButton(
          child: Text('Tidak'),
          onPressed: () {
            Navigator.of(context).pop();

            getHistories();
          },
        ),
        FlatButton(
          child: Text('Ya'),
          onPressed: () async {
            Navigator.of(context).pop();
            int count =
                await Provider.of<SimulationBloc>(context, listen: false)
                    .deleteHistory(histories[index].id);
            if (count > 0) {
              messageDialog(
                  title: 'Sukses', message: 'History berhasil dihapus');
            } else {
              messageDialog(title: 'Gagal', message: 'History gagal dihapus');
            }

            getHistories();
          },
        ),
      ],
    );
  }

  bool isLoadingHistory = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    isLoadingHistory = true;
    getHistories();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: getHistories,
        child: Column(
          children: [
            Padding(
                padding:
                    EdgeInsets.only(bottom: 0, left: 16, right: 16, top: 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      newSimulationCard(),
                    ])),
            Padding(
              padding: EdgeInsets.only(bottom: 0, left: 16, right: 16, top: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _simulationHistoryTitle(),
                  ]),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 0),
                children: <Widget>[
                  histories == null || histories.isEmpty
                      ? emptyHistory()
                      : cardSimulationHistoryContainer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loading() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Color(0xffC82247),
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xffffffff)),
      ),
    );
  }

  messageDialog({String title, String message, List<Widget> actions}) async {
    return await showDialog(
      context: context,
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: actions ??
            [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
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
                padding: EdgeInsets.only(right: 8),
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
            if (isLoadingHistory) ...[
              loading(),
            ] else
              ...List.generate(histories.length, (index) {
                return _simulationHistoryItem(
                  index: index,
                  title:
                      '${histories[index].educationStageName} ${histories[index].studyProgram}',
                  description:
                      '(${educationStages[histories[index].educationStage - 1]['desc']}) ${histories[index].updateDateTime}',
                );
              })
          ],
        ),
      ),
    );
  }

  Widget emptyHistory() {
    return Container(
      margin: EdgeInsets.only(top: 72.0),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        'assets/images/empty_history.svg',
      ),
    );
  }

  Widget _simulationHistoryTitle() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
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
  }

  Widget _simulationHistoryItem({
    int index,
    String title,
    String description,
  }) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Constants.accentColor,
      ),
      onDismissed: (direction) async {
        await deleteHistory(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        child: SizedBox(
          width: double.infinity,
          height: 65,
          child: OutlineButton(
            onPressed: () {
              onTapResultHistory(index);
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
                          padding: EdgeInsets.only(right: 16.0),
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
                IconButton(
                  icon: Icon(Icons.mode_edit),
                  onPressed: () {
                    onTapEditHistory(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.receipt),
                  onPressed: () {
                    onTapResultHistory(index);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
