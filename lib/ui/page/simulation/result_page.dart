import 'package:flutter/material.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_convert_model.dart';
import 'package:isk_aps_calc/data/model/subcategory_model.dart';
import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';
import 'package:isk_aps_calc/ui/page/main_tabs_page.dart';
import 'package:provider/provider.dart';

import 'package:isk_aps_calc/constants.dart';

import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';

import 'package:isk_aps_calc/data/model/indicator_model.dart';
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
            SizedBox(height: 48),
            Column(
              children: List.generate(accreditation.length, (index) {
                return indicatorContainer(accreditation[index]);
              }),
            ),
            SizedBox(height: 36.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 200.0,
                  child: CustomRoundedButton(
                    items: <Widget>[
                      Text(
                        'Kembali',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                    onPressed: () {
                      Navigator.of(context).popUntil((route) {
                        if (route.settings.name == MainTabs.tag) {
                          return true;
                        } else {
                          return false;
                        }
                      });
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
              image: AssetImage('assets/images/result_card_bg_1.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(16),
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  resultConvert.rankedConvert ?? 'Akreditasi',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Widget indicatorContainer(MappingIndicatorModel indicator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          indicator.indicatorCategoryName,
          style: Constants.titleStyle,
        ),
        SizedBox(height: 16.0),
        ...List.generate(indicator.subcategory.length, (index) {
          return _indicatorFieldContainer(
            indicator.subcategory[index],
            indicator.indicator[index],
          );
        }),
      ],
    );
  }

  Widget _indicatorFieldContainer(
    SubcategoryModel subcategory,
    IndicatorModel indicator,
  ) {
    return Container(
      padding: EdgeInsets.only(bottom: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _indicatorField(
            subcategory,
            indicator,
          ),
        ],
      ),
    );
  }

  Widget _indicatorField(
    SubcategoryModel subcategory,
    IndicatorModel indicator,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.only(right: 24.0, left: 8.0),
            child: Text(subcategory.name),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '${indicator.value != null ? indicator.value : 0.0}',
              textAlign: TextAlign.end,
            ),
            decoration: BoxDecoration(
              color: Color(0xffC4C4C4),
            ),
          ),
        ),
      ],
    );
  }
}
