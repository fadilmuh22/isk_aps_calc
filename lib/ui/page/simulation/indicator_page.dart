import 'package:flutter/material.dart';
import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';
import 'package:isk_aps_calc/data/model/indicator_model.dart';

import 'package:isk_aps_calc/ui/component/custom_appbar.dart';
import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';
import 'package:isk_aps_calc/ui/page/simulation/result_page.dart';
import 'package:provider/provider.dart';

enum IndicatorField {
  number,
  text,
  radio,
  checkbox,
  multiple_number,
}

class IndicatorPage extends StatefulWidget {
  static String tag = '/indicator';

  @override
  _IndicatorPageState createState() => _IndicatorPageState();
}

class _IndicatorPageState extends State<IndicatorPage>
    with SingleTickerProviderStateMixin {
  var indicator;

  Map<String, dynamic> map = Map<String, dynamic>();
  final _formKey = GlobalKey<FormState>();

  var _activeTabIndex;

  TabController _tabController;

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
    _tabController = TabController(vsync: this, length: indicator.length);
    _tabController.addListener((_setActiveTabIndex));
  }

  @override
  void dispose() {
    _formKey.currentState.dispose();
    _tabController.dispose();
    super.dispose();
  }

  _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController.index;
    });
  }

  handleTabNext() {
    _formKey.currentState.save();
    if (_tabController.index != null) {
      if (_activeTabIndex == (indicator.length - 1)) {
        Provider.of<SimulationBloc>(context, listen: false).accreditate(map);
        Navigator.of(context).pushNamed(ResultPage.tag);
      } else {
        _tabController.animateTo((_tabController.index + 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        educationStageName: Provider.of<SimulationBloc>(context)
            .newSimulation
            .educationStageName,
        studyProgramName:
            Provider.of<SimulationBloc>(context).newSimulation.studyProgramName,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: TabBarView(
            controller: _tabController,
            children: List.generate(indicator.length, (index) {
              return indicatorContainer(indicator[index]);
            }),
          ),
        ),
      ),
    );
  }

  Widget indicatorContainer(Map<String, dynamic> indicator) {
    return ListView(
      children: [
        Text(
          indicator['indicator_category_name'],
          style: Constants.titleStyle,
        ),
        SizedBox(height: 24.0),
        ...List.generate(indicator['indicator'].length, (index) {
          return indicatorFieldContainer(indicator['indicator'][index]);
        }),
        SizedBox(height: 36.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            nextButton(),
            SizedBox(height: 24.0),
            Text(
                '${_activeTabIndex == null ? 1 : _activeTabIndex + 1} dari ${this.indicator.length}'),
          ],
        ),
      ],
    );
  }

  Widget indicatorFieldContainer(IndicatorModel indicator) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (IndicatorField.values[indicator.type - 1] !=
              IndicatorField.radio) ...[
            Text(
              indicator.name,
            ),
          ],
          _indicatorField(indicator),
        ],
      ),
    );
  }

  Widget nextButton() => SizedBox(
        width: 200.0,
        child: CustomRoundedButton(
          items: <Widget>[
            Text('Lanjutkan',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            Icon(Icons.keyboard_arrow_right)
          ],
          onPressed: handleTabNext,
        ),
      );

  Widget _indicatorField(IndicatorModel indicator) {
    switch (IndicatorField.values[indicator.type - 1]) {
      case IndicatorField.number:
        return Theme(
          child: TextFormField(
            key: UniqueKey(),
            keyboardType: TextInputType.number,
            autofocus: false,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please provide value';
              }
              return null;
            },
            onSaved: (value) => map[indicator.variable] = value,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.edit),
              border: new UnderlineInputBorder(
                borderSide: new BorderSide(
                    color: Colors.white, style: BorderStyle.solid),
              ),
            ),
          ),
          data: Theme.of(context).copyWith(primaryColor: Constants.accentColor),
        );
        break;
      case IndicatorField.text:
        return Theme(
          child: TextFormField(
            key: UniqueKey(),
            keyboardType: TextInputType.number,
            autofocus: false,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please provide value';
              }
              return null;
            },
            onSaved: (value) => map[indicator.variable] = value,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.edit),
              border: new UnderlineInputBorder(
                borderSide: new BorderSide(
                    color: Colors.white, style: BorderStyle.solid),
              ),
            ),
          ),
          data: Theme.of(context).copyWith(primaryColor: Constants.accentColor),
        );
        break;
      case IndicatorField.radio:
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: RadioListTile(
                key: UniqueKey(),
                groupValue: map[indicator.variable],
                value: indicator.defaultValue,
                onChanged: (value) {
                  setState(() {
                    map[indicator.variable] = value;
                  });
                },
              ),
            ),
            Flexible(
              flex: 3,
              child: Text(
                indicator.name,
                // overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
        break;
      case IndicatorField.checkbox:
        List defaultValue = indicator.defaultValue;
        return Column(
          key: UniqueKey(),
          children: List.generate(defaultValue.length, (index) {
            return Checkbox(
                key: UniqueKey(),
                value: map[indicator.variable],
                onChanged: (value) {
                  setState(() {
                    map[indicator.variable] = value;
                  });
                });
          }),
        );
        break;
      case IndicatorField.multiple_number:
        map[indicator.variable] = new List(4);
        List defaultValue = indicator.defaultValue.split('/');
        return Row(
          key: UniqueKey(),
          children: List.generate(defaultValue.length, (index) {
            return Flexible(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Theme(
                  child: TextFormField(
                    key: UniqueKey(),
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      map[indicator.variable][index] = value;
                    },
                    decoration: InputDecoration(
                      labelText: defaultValue[index],
                    ),
                  ),
                  data: Theme.of(context).copyWith(
                    primaryColor: Constants.accentColor,
                  ),
                ),
              ),
            );
          }),
        );
        break;
      default:
        return Container();
    }
  }
}
