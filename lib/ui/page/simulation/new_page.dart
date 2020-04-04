import 'package:flutter/material.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';
import 'package:isk_aps_calc/data/model/simulation_model.dart';
import 'package:isk_aps_calc/ui/component/custom_appbar.dart';
import 'package:isk_aps_calc/ui/page/simulation/dosen_page.dart';
import 'package:isk_aps_calc/ui/page/simulation/kurikulum_page.dart';
import 'package:provider/provider.dart';

class NewSimulationPage extends StatefulWidget {
  static const String tag = '/simulatsi/create';

  @override
  _NewSimulationPageState createState() => _NewSimulationPageState();
}

class _NewSimulationPageState extends State<NewSimulationPage> {
  final _formKey = GlobalKey<FormState>();

  String _prodiName = '', _tingkat = '';

  Map<String, int> mapTingkat = {
    'D3': 0,
    'S1': 0,
    'S2': 0,
    'S3': 0,
  };

  bool tingkatInvalid = false;

  toggleTingkatActive(String key) {
    setState(() {
      _tingkat = key;
      mapTingkat.updateAll((k, v) {
        if (mapTingkat[k] == 1) {
          mapTingkat[k] = 0;
          return;
        }
      });
      mapTingkat[key] = 1;
    });
  }

  @override
  Widget build(context) {
    final simulationBloc = Provider.of<SimulationBloc>(context);

    Widget _studyProgramNameLabel() => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Nama Prodi:',
            )
          ],
        );

    Widget _studyProgramName() => Theme(
        child: TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please provide value';
            }
            return null;
          },
          onSaved: (text) => _prodiName = text,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.edit),
            contentPadding: EdgeInsets.only(
                left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(4)
            // )
            border: new UnderlineInputBorder(
              borderSide:
                  new BorderSide(color: Colors.white, style: BorderStyle.solid),
            ),
          ),
        ),
        data: Theme.of(context).copyWith(primaryColor: Constants.accentColor));

    Widget _chooseStudyProgramLabel() => Padding(
        padding: EdgeInsets.only(left: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Pilih Program Pendidikan:',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ));

    Widget _studyProgram({
      String key,
      String abbreviation,
      Text name,
      Color color,
    }) =>
        Container(
          key: ValueKey(key),
          margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: RaisedButton(
              color: mapTingkat[key] == 1 ? color : Colors.white,
              onPressed: () => toggleTingkatActive(key),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      abbreviation,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:
                              this.mapTingkat[key] == 1 ? Colors.white : color),
                    ),
                  ),
                  Expanded(child: name),
                ],
              ),
            ),
          ),
        );

    Widget _chooseStudyProgram() => Container(
            child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: _studyProgram(
                  key: 'D3',
                  color: Colors.greenAccent,
                  abbreviation: 'D3',
                  name: Text(
                    'Sarjana/Sarjana Terapan',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
                Expanded(
                  child: _studyProgram(
                      key: 'S1',
                      color: Colors.orangeAccent,
                      abbreviation: 'S1\nD4',
                      name: Text(
                        'Sarjana/Sarjana Terapan',
                        overflow: TextOverflow.ellipsis,
                      )),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: _studyProgram(
                    key: 'S2',
                    color: Colors.redAccent,
                    abbreviation: 'S2',
                    name: Text(
                      'Magister/Magister Terapan',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  child: _studyProgram(
                    key: 'S3',
                    color: Colors.purpleAccent,
                    abbreviation: 'S3',
                    name: Text(
                      'Doktor/Doktor Terapan',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            )
          ],
        ));

    Widget profileName() => Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[_studyProgramNameLabel(), _studyProgramName()],
          ),
        );

    Widget studyProgram() => Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              _chooseStudyProgramLabel(),
              _chooseStudyProgram(),
              if (tingkatInvalid)
                Text(
                  'Please select one',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                )
            ],
          ),
        );

    Widget btnNext() => Container(
          margin: EdgeInsets.only(left: 85.0, right: 85.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            onPressed: () {
              if (_formKey.currentState.validate() && _tingkat.isNotEmpty) {
                _formKey.currentState.save();

                var model = SimulationModel(
                  tingkat: _tingkat,
                  prodiName: _prodiName,
                );
                simulationBloc.simulation = model;

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: simulationBloc,
                    child: DosenPage(),
                  ),
                ));
              } else if (_tingkat.isEmpty) {
                setState(() {
                  tingkatInvalid = true;
                });
              }
            },
            color: Constants.accentColor,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Selanjutnya',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        );

    return Scaffold(
      appBar: CustomAppBar(newSimulation: true),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(5.0),
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              profileName(),
              SizedBox(
                height: 20,
              ),
              studyProgram(),
              SizedBox(
                height: 20,
              ),
              btnNext()
            ],
          ),
        ),
      ),
    );
  }
}
