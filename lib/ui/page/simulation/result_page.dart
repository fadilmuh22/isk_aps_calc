import 'package:flutter/material.dart';
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
  var indicator;

  @override
  void initState() {
    super.initState();
    indicator = [
      {
        'indicator_category_id': 'ic1',
        'indicator_category_name': 'Dosen Tetap',
        'indicator': [
          IndicatorModel(
            id: 1,
            category: 'ic1',
            subcategory: 'is1',
            name:
                'Jumlah dosen tetap yang ditugaskan sebagai pengampu mata kuliah dengan bidang keahlian yang sesuai dengan kompetensi inti program studi yang diakreditasi',
            variable: 'NDTPS',
            type: 1,
            defaultValue: '',
          ),
          IndicatorModel(
            id: 2,
            category: 'ic1',
            subcategory: 'is2',
            name:
                'Jumlah DTPS yang berpendidikan tertinggi Doktor/Doktor Terapan/Subspesialis',
            variable: 'NDS3',
            type: 1,
            defaultValue: '',
          ),
          IndicatorModel(
            id: 3,
            category: 'ic1',
            subcategory: 'is3',
            name: 'Jumlah DTPS yang memiliki jabatan akademik Guru Besar',
            variable: 'NDGB',
            type: 1,
            defaultValue: '',
          ),
        ],
      },
      {
        'indicator_category_id': 'ic2',
        'indicator_category_name': 'Kurikulum',
        'indicator': [
          IndicatorModel(
            id: 6,
            category: 'ic2',
            subcategory: 'is4',
            name:
                'Evaluasi dan pemutakhiran kurikulum secara berkala tiap 4 s.d. 5 tahun yang melibatkan pemangku kepentingan internal dan eksternal, serta direview oleh pakar bidang ilmu program studi, industri, asosiasi, serta sesuai perkembangan ipteks dan kebutuhan pengguna',
            variable: 'A',
            type: 3,
            defaultValue: 4,
          ),
          IndicatorModel(
            id: 7,
            category: 'ic2',
            subcategory: 'is4',
            name:
                'Evaluasi dan pemutakhiran kurikulum secara berkala tiap 4 s.d. 5 tahun yang melibatkan pemangku kepentingan internal dan eksternal',
            variable: 'A',
            type: 3,
            defaultValue: 3,
          ),
          IndicatorModel(
            id: 8,
            category: 'ic2',
            subcategory: 'is4',
            name:
                'Evaluasi dan pemutakhiran kurikulum melibatkan pemangku kepentingan internal',
            variable: 'A',
            type: 3,
            defaultValue: 2,
          ),
        ],
      },
      {
        'indicator_category_id': 'ic8',
        'indicator_category_name': 'Kepuasan Pengguna',
        'indicator': [
          IndicatorModel(
            id: 33,
            category: 'ic8',
            subcategory: 'is12',
            name: 'Edsad',
            variable: 'G',
            type: 5,
            defaultValue: 'Sangat Baik/Baik/Cukup/Kurang',
          ),
          IndicatorModel(
            id: 34,
            category: 'ic8',
            subcategory: 'is12',
            name: 'Keahlian pada bidsad',
            variable: 'H',
            type: 5,
            defaultValue: 'Sangat Baik/Baik/Cukup/Kurang',
          ),
          IndicatorModel(
            id: 35,
            category: 'ic8',
            subcategory: 'is12',
            name: 'Etika',
            variable: 'G',
            type: 5,
            defaultValue: 'Sangat Baik/Baik/Cukup/Kurang',
          ),
          IndicatorModel(
            id: 36,
            category: 'ic8',
            subcategory: 'is12',
            name: 'Keahlian pada bidang ilmu (kompetensi utama)',
            variable: 'H',
            type: 5,
            defaultValue: 'Sangat Baik/Baik/Cukup/Kurang',
          ),
          IndicatorModel(
            id: 39,
            category: 'ic8',
            subcategory: 'is12',
            name: 'Keahlian pada bidang ilmu (kompetensi utama)',
            variable: 'I',
            type: 5,
            defaultValue: 'Sangat Baik/Baik/Cukup/Kurang',
          ),
        ],
      },
    ];
  }

  @override
  Widget build(context) {
    var accrediation = Provider.of<SimulationBloc>(context).indicator;
    print(accrediation);
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
              children: List.generate(indicator.length, (index) {
                return indicatorContainer(indicator[index]);
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

  Widget indicatorContainer(Map<String, dynamic> indicator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          indicator['indicator_category_name'],
          style: Constants.titleStyle,
        ),
        SizedBox(height: 16.0),
        ...List.generate(indicator['indicator'].length, (index) {
          return _indicatorFieldContainer(indicator['indicator'][index]);
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
