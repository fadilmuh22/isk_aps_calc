import 'package:flutter/material.dart';
import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';
import 'package:isk_aps_calc/data/model/indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';

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
      MappingIndicatorModel(
        educationStage: 1,
        indicatorCategory: 'ic1',
        indicatorSubcategory: 'is1',
        indicatorCategoryName: 'Dosen Tetap',
        indicator: [
          IndicatorModel(
            id: 1,
            category: 'ic1',
            subcategory: 'is1',
            name:
                'Jumlah dosen tetap yang ditugaskan sebagai pengampu mata kuliah dengan bidang keahlian yang sesuai dengan kompetensi inti program studi yang diakreditasi',
            variable: 'NDTPS',
            type: 4,
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
      ),
      MappingIndicatorModel(
        educationStage: 2,
        indicatorCategory: 'ic2',
        indicatorSubcategory: 'is2',
        indicatorCategoryName: 'Dosen Aja',
        indicator: [
          IndicatorModel(
            id: 1,
            category: 'ic1',
            subcategory: 'is1',
            name: 'Jumlah dosen tetap yang iakreditasi',
            variable: 'NDTPS',
            type: 3,
            defaultValue: '',
          ),
          IndicatorModel(
            id: 2,
            category: 'ic1',
            subcategory: 'is2',
            name: 'Jumlah DTPS yang berpendidikan',
            variable: 'NDS3',
            type: 3,
            defaultValue: '',
          ),
          IndicatorModel(
            id: 3,
            category: 'ic1',
            subcategory: 'is3',
            name: 'Jumlah DTPS yang memiliki jabatan akademik Guru Besar',
            variable: 'NDGB',
            type: 3,
            defaultValue: '',
          ),
        ],
      ),
      MappingIndicatorModel(
        educationStage: 1,
        indicatorCategory: 'ic1',
        indicatorSubcategory: 'is1',
        indicatorCategoryName: 'Dosen Tetap',
        indicator: [
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
      ),
      MappingIndicatorModel(
        educationStage: 1,
        indicatorCategory: 'ic1',
        indicatorSubcategory: 'is1',
        indicatorCategoryName: 'Dosen Tetap',
        indicator: [
          IndicatorModel(
            id: 1,
            category: 'ic1',
            subcategory: 'is1',
            name:
                'Jumlah dosen tetap yang ditugaskan sebagai pengampu mata kuliah dengan bidang keahlian yang sesuai dengan kompetensi inti program studi yang diakreditasi',
            variable: 'NDTPS',
            type: 4,
            defaultValue: '',
          ),
          IndicatorModel(
            id: 2,
            category: 'ic1',
            subcategory: 'is2',
            name:
                'Jumlah DTPS yang berpendidikan tertinggi Doktor/Doktor Terapan/Subspesialis',
            variable: 'NDS3',
            type: 4,
            defaultValue: '',
          ),
          IndicatorModel(
            id: 3,
            category: 'ic1',
            subcategory: 'is3',
            name: 'Jumlah DTPS yang memiliki jabatan akademik Guru Besar',
            variable: 'NDGB',
            type: 4,
            defaultValue: '',
          ),
        ],
      ),
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

  Widget indicatorContainer(MappingIndicatorModel mappingIndicator) {
    return ListView(
      children: [
        Text(
          mappingIndicator.indicatorCategoryName,
          style: Constants.titleStyle,
        ),
        ...List.generate(mappingIndicator.indicator.length, (index) {
          return _indicatorFieldContainer(mappingIndicator.indicator[index]);
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

  Widget _indicatorFieldContainer(IndicatorModel indicator) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (indicator.type != 3 && indicator.type != 4) ...[
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
            Text(
              _activeTabIndex == (indicator.length - 1)
                  ? 'Selesai'
                  : 'Lanjutkan',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
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
                title: Text(
                  indicator.name,
                  style: TextStyle(fontSize: 12.0),
                ),
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
          ],
        );
        break;
      case IndicatorField.checkbox:
        map[indicator.variable] = false;
        return CheckboxListTile(
          key: UniqueKey(),
          title: Text(indicator.name),
          value: map[indicator.variable],
          onChanged: (value) {
            setState(() {
              map[indicator.variable] = value;
            });
          },
        );
      case IndicatorField.multiple_number:
        map[indicator.variable] = new List(4);
        List defaultValue = indicator.defaultValue.split('/');
        return Row(
          key: UniqueKey(),
          children: List.generate(defaultValue.length, (index) {
            return Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 5.0, top: 8.0),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      labelText: defaultValue[index],
                      labelStyle: TextStyle(
                        fontSize: 8.0,
                      ),
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
