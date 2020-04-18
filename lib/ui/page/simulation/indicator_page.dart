import 'package:flutter/material.dart';
import 'package:isk_aps_calc/util/validator.dart';
import 'package:provider/provider.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';

import 'package:isk_aps_calc/data/model/indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';

import 'package:isk_aps_calc/ui/component/custom_appbar.dart';
import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';
import 'package:isk_aps_calc/ui/page/simulation/result_page.dart';

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
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<IndicatorPage> {
  List<MappingIndicatorModel> indicator;
  final Map<String, dynamic> map = Map<String, dynamic>();

  final _formKey = GlobalKey<FormState>();
  TabController _tabController;
  int _activeTabIndex;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    indicator =
        Provider.of<SimulationBloc>(context, listen: false).mapIndicator;
    map.addAll(Provider.of<SimulationBloc>(context, listen: false)
        .newSimulation
        .getJumlahLulusan());

    _tabController = TabController(vsync: this, length: indicator.length);
    _tabController.addListener((_setActiveTabIndex));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _setActiveTabIndex() {
    _formKey.currentState.save();
    print(map);
    setState(() {
      _activeTabIndex = _tabController.index;
    });
  }

  handleTabNext() async {
    _formKey.currentState.save();
    if (_tabController.index != null) {
      if (_activeTabIndex == (indicator.length - 1)) {
        await Provider.of<SimulationBloc>(context, listen: false)
            .accreditate(map, indicator);

        Navigator.of(context).pushNamed(ResultPage.tag);
      } else {
        _tabController.animateTo((_tabController.index + 1));
      }
    }
  }

  Future<bool> handleBackButton() {
    _formKey.currentState.save();
    if (_tabController.index != null) {
      if (_tabController.index == 0) {
        return showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                      title: new Text('Konfirmasi'),
                      content: new Text(
                          'Apakah Anda Yakin Ingin Keluar Dari Simulasi?'),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: new Text('Tidak'),
                        ),
                        new FlatButton(
                          onPressed: () {
                            print('masuk4');
                            Navigator.of(context).pop(true);
                          },
                          child: new Text('Ya'),
                        ),
                      ],
                    )) ??
            false;
      } else if (_tabController.index < indicator.length) {
        _tabController.animateTo((_tabController.index - 1));
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: handleBackButton,
      child: Scaffold(
        appBar: CustomAppBar(
          educationStageName: Provider.of<SimulationBloc>(context)
              .newSimulation
              .educationStageName,
          studyProgramName: Provider.of<SimulationBloc>(context)
              .newSimulation
              .studyProgramName,
        ),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
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
        ),
      ),
    );
  }

  Widget indicatorContainer(MappingIndicatorModel mappingIndicator) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            mappingIndicator.indicatorCategoryName,
            style: Constants.titleStyle,
          ),
          if (mappingIndicator.indicator[0].type == 3) ...[
            Text(
              Constants.tipe3Subtitle,
            ),
          ] else if (mappingIndicator.indicator[0].type == 4) ...[
            Text(
              Constants.tipe4Subtitle,
            ),
          ],
          ...List.generate(mappingIndicator.indicator.length, (index) {
            if (mappingIndicator.indicator[index].type == 3) {}
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
      ),
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
        width: 140.0,
        child: CustomRoundedButton(
          items: <Widget>[
            Text(
              _activeTabIndex == (indicator.length - 1)
                  ? 'Selesai'
                  : 'Lanjutkan',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
            )
          ],
          onPressed: handleTabNext,
        ),
      );

  Widget _indicatorField(IndicatorModel indicator) {
    switch (IndicatorField.values[indicator.type - 1]) {
      case IndicatorField.number:
        return Theme(
          child: TextFormField(
            keyboardType: TextInputType.number,
            autofocus: false,
            validator: Validator.numberValidator,
            initialValue: map[indicator.variable] != null
                ? map[indicator.variable].toString()
                : '',
            onChanged: (value) {
              map[indicator.variable] = value;
            },
            onSaved: (value) {
              map[indicator.variable] = value;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 16.0),
              suffixIcon: Icon(Icons.edit, size: 20.0),
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
            keyboardType: TextInputType.text,
            autofocus: false,
            initialValue: map[indicator.variable],
            onSaved: (value) {
              map[indicator.variable] = value;
            },
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
                groupValue: map[indicator.variable],
                value: indicator.defaultValue,
                onChanged: (value) {
                  setState(() {
                    map[indicator.variable] = indicator.defaultValue;
                  });
                },
              ),
            ),
          ],
        );
        break;
      case IndicatorField.checkbox:
        return CheckboxListTile(
          title: Text(indicator.name),
          value: map[indicator.variable] == indicator.defaultValue,
          onChanged: (value) {
            setState(() {
              map[indicator.variable] =
                  map[indicator.variable] == indicator.defaultValue
                      ? ''
                      : indicator.defaultValue;
            });
          },
        );
      case IndicatorField.multiple_number:
        List defaultValue = indicator.defaultValue.split('/');
        return Row(
          children: List.generate(defaultValue.length, (index) {
            return Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 5.0, top: 8.0),
                child: Theme(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    validator: Validator.numberValidator,
                    initialValue: map['${indicator.variable}${index + 1}'] !=
                            null
                        ? map['${indicator.variable}${index + 1}'].toString()
                        : '',
                    onChanged: (value) {
                      _formKey.currentState.save();
                      print(map);
                    },
                    onSaved: (value) {
                      if (value != null || value.isNotEmpty) {
                        map['${indicator.variable}${index + 1}'] = value;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      hintText:
                          map['${indicator.variable}${index + 1}'].toString(),
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
