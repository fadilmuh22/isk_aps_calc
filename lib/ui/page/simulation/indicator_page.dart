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
  List<MappingIndicatorModel> mapIndicator;
  Map<String, dynamic> mapVariable = Map<String, dynamic>();

  final _formKey = GlobalKey<FormState>();
  TabController _tabController;
  int _activeTabIndex;
  int _counter = 0;
  String _lastCategory;
  String multiNumberInvalid;

  List<Map<String, dynamic>> indicatorValidations = List();

  _setActiveTabIndex() {
    _formKey.currentState.save();
    _formKey.currentState.validate();
    setState(() {
      _activeTabIndex = _tabController.index;
    });
  }

  handleTabNext(int page) async {
    _formKey.currentState.save();
    _formKey.currentState.validate();
    bool required = requiredValidation(page);
    if ((indicatorValidations[page] != null && !required ||
        !indicatorValidations[page]['valid'])) {
      validationDialog(page);
    } else if (_tabController.index != null) {
      if (_activeTabIndex == (mapIndicator.length - 1)) {
        // await Provider.of<SimulationBloc>(context, listen: false)
        //     .accreditate(mapVariable, mapIndicator);

        // Navigator.of(context).pushReplacementNamed(ResultPage.tag);
      } else {
        _tabController.animateTo((_tabController.index + 1));
      }
    }
  }

  Future<bool> handleBackButton() {
    if (_tabController.index != null) {
      if (_tabController.index == 0) {
        exitDialog();
      } else if (_tabController.index < mapIndicator.length) {
        _formKey.currentState.save();
        _tabController.animateTo((_tabController.index - 1));
      }
    }

    return null;
  }

  dtpsValidation(int page) {
    double ndtps = double.tryParse(mapVariable['NDTPS'] ?? '0.0') ?? 0.0;
    double nds3 = double.tryParse(mapVariable['NDS3'] ?? '0.0') ?? 0.0;
    double ndgb = double.tryParse(mapVariable['NDGB'] ?? '0.0') ?? 0.0;
    double ndlk = double.tryParse(mapVariable['NDLK'] ?? '0.0') ?? 0.0;
    double ndl = double.tryParse(mapVariable['NDL'] ?? '0.0') ?? 0.0;

    double sumD = nds3 + ndgb + ndlk + ndl;

    if (sumD > ndtps) {
      if (mapIndicator[page + 1].indicatorCategory != 'ic1') {
        setState(() {
          indicatorValidations[page]['valid'] = false;
          indicatorValidations[page]['msg'] = 'Jumlah dosen tidak valid';
        });
      }
      return false;
    }
    setState(() {
      indicatorValidations[page]['valid'] = true;
    });
    return true;
  }

  multiNumberValidation(int page, var indicator) {
    double sum = 0.0;
    for (int i = 0; i < 4; i++) {
      double val = double.tryParse(
              mapVariable['${indicator.variable}${i + 1}'] ?? '0.0') ??
          0.0;
      sum += val;
    }
    setState(() {
      setState(() {
        multiNumberInvalid = 'X';
        indicatorValidations[page]['valid'] = false;
        indicatorValidations[page]['msg'] =
            Constants.multiNumberValidationMessage;
      });
    });
    if (sum > 100 || sum < 100) {
      setState(() {
        multiNumberInvalid = indicator.variable;
        indicatorValidations[page]['valid'] = false;
        indicatorValidations[page]['msg'] =
            Constants.multiNumberValidationMessage;
      });
    }
    if (sum == 100) {
      setState(() {
        indicatorValidations[page]['valid'] = true;
        indicatorValidations[page]['msg'] = null;
      });
      if (multiNumberInvalid == indicator.variable) {
        setState(() {
          multiNumberInvalid = null;
        });
      }
    } else if (multiNumberInvalid != null) {
      setState(() {
        multiNumberInvalid = indicator.variable;
        indicatorValidations[page]['valid'] = false;
        indicatorValidations[page]['msg'] =
            Constants.multiNumberValidationMessage;
      });
    }
  }

  bool requiredValidation(int page) {
    bool valid = true;
    for (IndicatorModel data in mapIndicator[page].indicator) {
      if (mapVariable[data.variable] is String) {
        valid = mapVariable[data.variable] != null &&
            mapVariable[data.variable].isNotEmpty;
      } else if (mapVariable[data.variable] is num) {
        valid = mapVariable[data.variable] != null;
      }
      if (!valid) {
        break;
      }
    }
    return valid;
  }

  @override
  void initState() {
    super.initState();

    mapIndicator =
        Provider.of<SimulationBloc>(context, listen: false).mapIndicator;

    mapIndicator.forEach((data) {
      indicatorValidations.add({
        'valid': false,
        'msg': null,
        'key': null,
      });
    });

    if (Provider.of<SimulationBloc>(context, listen: false).mapVariable !=
        null) {
      mapVariable =
          Provider.of<SimulationBloc>(context, listen: false).mapVariable;
      mapIndicator.forEach((data) {
        setState(() {
          indicatorValidations = indicatorValidations.map((data) {
            data['valid'] = true;
            return data;
          }).toList();
        });
      });
    } else {
      mapIndicator.forEach((data) {
        data.indicator.forEach((ind) {
          return mapVariable[ind.variable] = null;
        });
      });
    }

    _tabController = TabController(vsync: this, length: mapIndicator.length);
    _tabController.addListener((_setActiveTabIndex));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: List.generate(mapIndicator.length, (index) {
                  return indicatorContainer(index, mapIndicator[index]);
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

  validationDialog(int page) async {
    return await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: new Text('Konfirmasi'),
                  content: new Text(indicatorValidations[page]['msg'] ??
                      'Ada indicator yang masih tidak valid'),
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

  Widget indicatorContainer(int page, MappingIndicatorModel mappingIndicator) {
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
            return _indicatorFieldContainer(
                page, mappingIndicator.indicator[index]);
          }),
          SizedBox(
            height: 10,
          ),
          if (mappingIndicator.indicator[0].type == 3 &&
              mapVariable[mappingIndicator.indicator[0].variable] == null)
            textValidation(),
          SizedBox(height: 36.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _nextButton(page),
              SizedBox(height: 24.0),
              Text(
                  '${_activeTabIndex == null ? 1 : _activeTabIndex + 1} dari ${this.mapIndicator.length}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _indicatorFieldContainer(int page, IndicatorModel indicator) {
    String tsTitle = null;
    if (indicator.name.contains('TS-')) {
      String academicYearStr =
          Provider.of<SimulationBloc>(context, listen: false)
              .newSimulation
              .academicYear;
      int academicYearInt = int.parse(academicYearStr.split('/')[0]);
      int nts = int.parse(indicator.name[indicator.name.indexOf('TS-') + 3]);
      tsTitle =
          '${indicator.name} (Tahun ${academicYearInt - nts}/${academicYearInt - (nts - 1)})';
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (indicator.type != 3 && indicator.type != 4) ...[
            Text(
              tsTitle != null ? tsTitle : indicator.name,
            ),
          ],
          _indicatorField(page, indicator),
        ],
      ),
    );
  }

  Widget _nextButton(int page) => SizedBox(
        width: 140.0,
        child: CustomRoundedButton(
          items: <Widget>[
            Text(
              _activeTabIndex == (mapIndicator.length - 1)
                  ? 'Selesai'
                  : 'Lanjutkan',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
            )
          ],
          onPressed: () {
            handleTabNext(page);
          },
        ),
      );

  Widget _indicatorField(int page, IndicatorModel indicator) {
    switch (IndicatorField.values[indicator.type - 1]) {
      case IndicatorField.number:
        return Theme(
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp(r'\d+([\.]{1})?')),
            ],
            autofocus: false,
            validator: (value) {
              String msg = Validator.number(value);
              if (indicatorValidations[page] != null) {
                setState(() {
                  indicatorValidations[page]['valid'] = (msg == null);
                });
              }
              if (indicator.category == 'ic1') {
                dtpsValidation(page);
                double ndtps = double.tryParse(mapVariable['NDTPS']) ?? 0.0;
                double current =
                    double.tryParse(mapVariable[indicator.variable]) ?? 0.0;
                if (current > ndtps) {
                  return 'Input ${indicator.variable} melebihi jumlah';
                }
              }
              return msg;
            },
            initialValue: mapVariable[indicator.variable] != null
                ? mapVariable[indicator.variable].toString()
                : '',
            onChanged: (value) {
              mapVariable[indicator.variable] = value;
              _formKey.currentState.validate();
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
                value: double.parse(indicator.defaultValue),
                onChanged: (value) {
                  setState(() {
                    mapVariable[indicator.variable] =
                        double.parse(indicator.defaultValue);

                    indicatorValidations[page]['valid'] = true;
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
                    validator: (value) {
                      multiNumberValidation(page, indicator);

                      return Validator.number(value);
                    },
                    initialValue:
                        mapVariable['${indicator.variable}${index + 1}'] != null
                            ? mapVariable['${indicator.variable}${index + 1}']
                                .toString()
                            : '',
                    onChanged: (value) {
                      mapVariable['${indicator.variable}${index + 1}'] = value;

                      _formKey.currentState.validate();
                    },
                    onSaved: (value) {
                      mapVariable['${indicator.variable}${index + 1}'] = value;
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

  Widget textValidation({String msg}) {
    return Text(
      'Pilih salah satu',
      style: TextStyle(
        color: Colors.red,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
