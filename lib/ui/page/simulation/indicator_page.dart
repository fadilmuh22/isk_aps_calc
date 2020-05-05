import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/util/validator.dart';

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
    with SingleTickerProviderStateMixin {
  List<MappingIndicatorModel> indicator;
  Map<String, dynamic> mapVariable = Map<String, dynamic>();

  final _formKey = GlobalKey<FormState>();
  TabController _tabController;
  int _activeTabIndex;
  int _counter = 0;
  String _lastCategory;

  @override
  void initState() {
    super.initState();

    indicator =
        Provider.of<SimulationBloc>(context, listen: false).mapIndicator;

    if (Provider.of<SimulationBloc>(context, listen: false).mapVariable !=
        null) {
      mapVariable =
          Provider.of<SimulationBloc>(context, listen: false).mapVariable;
    } else {
      indicator.forEach((data) {
        data.indicator.forEach((ind) {
          return mapVariable[ind.variable] = null;
        });
      });
    }

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
    _formKey.currentState.validate();
    setState(() {
      _activeTabIndex = _tabController.index;
    });
  }

  handleTabNext() async {
    _formKey.currentState.save();
    _formKey.currentState.validate();
    if (_tabController.index != null) {
      if (_activeTabIndex == (indicator.length - 1)) {
        await Provider.of<SimulationBloc>(context, listen: false)
            .accreditate(mapVariable, indicator);

        Navigator.of(context).pushReplacementNamed(ResultPage.tag);
      } else {
        _tabController.animateTo((_tabController.index + 1));
      }
    }
  }

  Future<bool> handleBackButton() {
    if (_tabController.index != null) {
      if (_tabController.index == 0) {
        exitDialog();
      } else if (_tabController.index < indicator.length) {
        _formKey.currentState.save();
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
          onBackButton: handleBackButton,
          educationStageName: Provider.of<SimulationBloc>(context)
              .newSimulation
              .educationStageName,
          studyProgramName: Provider.of<SimulationBloc>(context)
              .newSimulation
              .studyProgramName,
        ),
        body: GestureDetector(
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

  exitDialog() {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              title: new Text('Konfirmasi'),
              content:
                  new Text('Apakah Anda Yakin Ingin Keluar Dari Simulasi?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('Tidak'),
                ),
                new FlatButton(
                  onPressed: () {
                    Provider.of<SimulationBloc>(context, listen: false).clear();
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop(true);
                  },
                  child: new Text('Ya'),
                ),
              ],
            ));
  }

  validationDialog() async {
    return await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: new Text('Konfirmasi'),
                  content: new Text('Ada indicator yang masih kosong'),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Text('Ok'),
                    ),
                  ],
                )) ??
        false;
  }

  Widget indicatorContainer(MappingIndicatorModel mappingIndicator) {
    if (_lastCategory != mappingIndicator.indicatorCategoryName) {
      _counter = 0;
    }

    _counter = _counter + 1;
    _lastCategory = mappingIndicator.indicatorCategoryName;

    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: RichText(
              text: TextSpan(
                text: mappingIndicator.indicatorCategoryName,
                style: Constants.titleStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: ' (' + _counter.toString() + ')',
                    style: Constants.counterStyle,
                  ),
                ],
              ),
            ),
          ),
          if (mappingIndicator.indicator[0].type == 3) ...[
            Text(
              Constants.tipe3Subtitle,
              style: Constants.guidenceStyle,
            ),
          ] else if (mappingIndicator.indicator[0].type == 5) ...[
            Text(
              Constants.tipe5Subtitle,
              style: TextStyle(fontSize: 10),
            ),
          ] else if (mappingIndicator.indicatorCategoryName
              .toLowerCase()
              .contains('publikasi ilmiah')) ...[
            Text(
              'Isikan dengan data Publikasi ilmiah mahasiswa yang dihasilkan secara mandiri atau bersama DTPS, dengan judul yang relevan dengan bidang program studi dalam 3 tahun terakhir.',
              style: TextStyle(fontSize: 10),
            ),
          ],
          Text(
            mappingIndicator.indicatorSubcategoryDescription != null
                ? mappingIndicator.indicatorSubcategoryDescription
                : '',
            style: Constants.guidenceStyle,
          ),
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
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp(r'\d+([\.]{1})?')),
            ],
            autofocus: false,
            validator: Validator.number,
            initialValue: mapVariable[indicator.variable] != null
                ? mapVariable[indicator.variable].toString()
                : '',
            onChanged: (value) {
              mapVariable[indicator.variable] = value;
            },
            onSaved: (value) {
              mapVariable[indicator.variable] = value;
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
            initialValue: mapVariable[indicator.variable],
            onSaved: (value) {
              mapVariable[indicator.variable] = value;
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
                groupValue: mapVariable[indicator.variable],
                value: int.parse(indicator.defaultValue),
                onChanged: (value) {
                  setState(() {
                    mapVariable[indicator.variable] =
                        int.parse(indicator.defaultValue);
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
          value: mapVariable[indicator.variable] == indicator.defaultValue,
          onChanged: (value) {
            setState(() {
              mapVariable[indicator.variable] =
                  mapVariable[indicator.variable] == indicator.defaultValue
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
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp(r'\d+([\.]{1})?')),
                    ],
                    autofocus: false,
                    validator: Validator.number,
                    initialValue:
                        mapVariable['${indicator.variable}${index + 1}'] != null
                            ? mapVariable['${indicator.variable}${index + 1}']
                                .toString()
                            : '',
                    onChanged: (value) {
                      mapVariable['${indicator.variable}${index + 1}'] = value;
                    },
                    onSaved: (value) {
                      mapVariable['${indicator.variable}${index + 1}'] = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      hintText: mapVariable['${indicator.variable}${index + 1}']
                          .toString(),
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
