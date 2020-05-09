import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';

import 'package:isk_aps_calc/constants.dart';

import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_convert_model.dart';

import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';
import 'package:isk_aps_calc/ui/component/custom_appbar.dart';

import 'package:isk_aps_calc/ui/page/main_tabs_page.dart';

class ResultPage extends StatefulWidget {
  static const String tag = '/simulasi/result';

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    MappingRankedConvertModel resultConvert =
        Provider.of<SimulationBloc>(context).resultConvert;

    List<MappingIndicatorModel> accreditation =
        Provider.of<SimulationBloc>(context).mapIndicator;

    Map<String, Map<String, MappingIndicatorModel>> accreditationFiltered =
        Map();

    accreditation.forEach((data) {
      if (accreditationFiltered[data.indicatorCategoryName] == null) {
        accreditationFiltered[data.indicatorCategoryName] = Map();
      }
      if (data.flag != null) {
        if (data.flag == data.indicatorSubcategory) {
          accreditationFiltered[data.indicatorCategoryName]
              .addAll({data.indicatorSubcategory: data});
        }
      } else {
        accreditationFiltered[data.indicatorCategoryName]
            .addAll({data.indicatorSubcategory: data});
      }
    });

    var keys = accreditationFiltered.keys.toList();

    return Scaffold(
      appBar: CustomAppBar(
        canBack: false,
        educationStageName: Provider.of<SimulationBloc>(context)
            .newSimulation
            .educationStageName,
        studyProgramName:
            Provider.of<SimulationBloc>(context).newSimulation.studyProgramName,
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            cardResult(resultConvert),
            SizedBox(height: 4.0),
            Center(
              child: Text(
                Constants.desc1,
                style: Constants.desc1Style,
              ),
            ),
            SizedBox(height: 4.0),
            Column(
              children: List.generate(keys.length, (index) {
                if (keys[index].toLowerCase() != 'data lulusan') {
                  return indicatorContainer(
                    keys[index],
                    accreditationFiltered[keys[index]].values.toList(),
                  );
                } else {
                  return Container();
                }
              }),
            ),
            SizedBox(height: 36.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 140.0,
                  child: CustomRoundedButton(
                    items: <Widget>[
                      Text(
                        'Selesai',
                        style: TextStyle(color: Colors.white),
                      ),
                      Flexible(
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    onPressed: () {
                      Provider.of<SimulationBloc>(context, listen: false)
                          .goToPage(0);
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName(MainTabs.tag));
                    },
                  ),
                ),
                SizedBox(height: 24.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showDrafter(String description, String title) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 16.0,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 48.0, horizontal: 20.0),
            child: Wrap(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 32.0),
                ),
                Text(
                  description,
                ),
              ],
            ),
          );
        });
  }

  Widget cardResult(MappingRankedConvertModel resultConvert) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.5),
          image: DecorationImage(
            image: resultConvert.rankedConvert.length != 0 &&
                    !(resultConvert.rankedConvert
                        .toLowerCase()
                        .contains('belum'))
                ? AssetImage('assets/images/result_card_bg_1.png')
                : AssetImage('assets/images/result_card_bg_2.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16),
        height: 90,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Center(
                child: Container(
                  width: 200,
                  child: BorderedText(
                    strokeWidth: 1.0,
                    strokeColor: Colors.blueAccent,
                    child: Text(
                      resultConvert.rankedConvert ??
                          'Belum Memenuhi Syarat Akreditasi',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget indicatorContainer(String category, List<MappingIndicatorModel> lmap) {
    String formattedLmapValue = '0.0';
    if (!lmap[0].indicatorValue.isNaN) {
      formattedLmapValue =
          '${lmap[0].indicatorValue.toStringAsFixed(2) ?? 0.0}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (lmap[0].flag != null) ...[
          SizedBox(
            height: 24.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  child: Text(
                    category,
                    style: Constants.titleStyle,
                  ),
                ),
              ),
              Flexible(
                flex: lmap[0].description != null ? 2 : 1,
                child: Row(
                  children: <Widget>[
                    if (lmap[0].description != null)
                      IconButton(
                        icon: Icon(
                          Icons.help_outline,
                          color: Color(0xffC4C4C4),
                        ),
                        onPressed: () {
                          showDrafter(lmap[0].description, category);
                        },
                      ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 14.0),
                        child: Text(
                          formattedLmapValue,
                          textAlign: TextAlign.end,
                        ),
                        decoration: BoxDecoration(
                          color: lmap[0].ranked != lmap[0].rankedTarget &&
                                  (lmap[0].rankedCurrentId >=
                                      lmap[0].rankedTargetId)
                              ? Colors.orangeAccent
                              : Color(0xffC4C4C4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24.0,
          ),
        ] else ...[
          SizedBox(
            height: 20.0,
          ),
          Text(
            category,
            style: Constants.titleStyle,
          ),
          SizedBox(
            height: 10.0,
          ),
          ...List.generate(lmap.length, (index) {
            return _indicatorField(
              lmap[index],
            );
          }),
        ]
      ],
    );
  }

  Widget _indicatorField(MappingIndicatorModel mapIndicator) {
    String formattedIndicatorValue = '0.0';
    if (!mapIndicator.indicatorValue.isNaN) {
      formattedIndicatorValue =
          '${mapIndicator.indicatorValue.toStringAsFixed(2) ?? 0.0}';
    }

    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.only(right: 24.0, left: 8.0),
                  child: Text(
                    mapIndicator.indicatorSubcategoryName,
                  ),
                ),
              ),
              Expanded(
                flex: mapIndicator.description != null ? 2 : 1,
                child: Row(
                  children: <Widget>[
                    if (mapIndicator.description != null)
                      IconButton(
                        icon: Icon(
                          Icons.help_outline,
                          color: Color(0xffC4C4C4),
                        ),
                        onPressed: () {
                          showDrafter(mapIndicator.description,
                              mapIndicator.indicatorCategoryName);
                        },
                      ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 14.0),
                        child: Text(
                          formattedIndicatorValue,
                          textAlign: TextAlign.end,
                        ),
                        decoration: BoxDecoration(
                          color: mapIndicator.ranked !=
                                      mapIndicator.rankedTarget &&
                                  (mapIndicator.rankedCurrentId >=
                                      mapIndicator.rankedTargetId)
                              ? Colors.orangeAccent
                              : Color(0xffC4C4C4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
