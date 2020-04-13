import 'package:flutter/material.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
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
            cardResult(),
            SizedBox(height: 48),
            Column(
              children: List.generate(accreditation.length, (index) {
                return indicatorContainer(accreditation[index]);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardResult() => GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.5),
            image: DecorationImage(
              image: AssetImage('assets/images/result_card_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(16),
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'TERAKREDITASI',
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

  Widget indicatorContainer(MappingIndicatorModel indicator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          indicator.indicatorCategoryName,
          style: Constants.titleStyle,
        ),
        SizedBox(height: 16.0),
        ...List.generate(indicator.indicator.length, (index) {
          return _indicatorFieldContainer(indicator.indicator[index]);
        }),
        SizedBox(height: 36.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(),
            SizedBox(height: 24.0),
          ],
        ),
      ],
    );
  }

  Widget _indicatorFieldContainer(IndicatorModel indicator) {
    return Container(
      padding: EdgeInsets.only(bottom: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _indicatorField(indicator),
        ],
      ),
    );
  }

  Widget _indicatorField(IndicatorModel indicator) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.only(right: 24.0, left: 8.0),
            child: Text(indicator.name),
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
