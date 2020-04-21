import 'package:flutter/material.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_convert_model.dart';
import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';
import 'package:isk_aps_calc/ui/page/main_tabs_page.dart';
import 'package:provider/provider.dart';

import 'package:isk_aps_calc/constants.dart';

import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';

import 'package:isk_aps_calc/ui/component/custom_appbar.dart';

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

    Map<String, List<MappingIndicatorModel>> accreditationFiltered = new Map();
    accreditation.forEach((data) {
      accreditationFiltered[data.indicatorCategoryName] =
          List<MappingIndicatorModel>();
    });

    accreditation.reduce((a, b) {
      if (a.indicatorCategory == b.indicatorCategory) {
        accreditationFiltered[a.indicatorCategoryName].addAll([a, b]);
        return a;
      }
      accreditationFiltered[b.indicatorCategoryName].add(b);
      return a;
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
            Column(
              children: List.generate(keys.length, (index) {
                return indicatorContainer(
                  keys[index],
                  accreditationFiltered[keys[index]],
                );
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
                      Icon(Icons.keyboard_arrow_right, color: Colors.white),
                    ],
                    onPressed: () {
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

  Widget cardResult(MappingRankedConvertModel resultConvert) => GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.5),
            image: DecorationImage(
              image: resultConvert.rankedConvert.length != 0
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
              )
            ],
          ),
        ),
      );

  Widget indicatorContainer(String category, List<MappingIndicatorModel> lmap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        Text(
          category,
          style: Constants.titleStyle,
        ),
        SizedBox(
          height: 16.0,
        ),
        ...List.generate(lmap.length, (index) {
          return _indicatorField(
            lmap[index].indicatorSubcategoryName,
            lmap[index].indicatorValue,
          );
        }),
      ],
    );
  }

  Widget _indicatorField(
      String indicatorSubcategoryName, double indicatorValue) {
    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(right: 24.0, left: 8.0),
                  child: Text(
                    indicatorSubcategoryName,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    '${indicatorValue.toStringAsFixed(2) ?? 0.0}',
                    textAlign: TextAlign.end,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffC4C4C4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
