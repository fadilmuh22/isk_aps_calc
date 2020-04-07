import 'package:flutter/material.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';
import 'package:isk_aps_calc/data/model/field_model.dart';
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

  final List<Map<String, String>> tingkats = [
    {
      'abbr': 'D3',
      'name': 'Diploma 3',
    },
    {
      'abbr': 'D4',
      'name': 'Sarjana Terapan',
    },
    {
      'abbr': 'S1',
      'name': 'Sarjana',
    },
    {
      'abbr': 'S2',
      'name': 'Magister',
    },
    {
      'abbr': 'S2',
      'name': 'Magister Terapan',
    },
    {
      'abbr': 'S3',
      'name': 'Doktor',
    },
    {
      'abbr': 'S3',
      'name': 'Doktor Terapan',
    },
    {
      'abbr': 'PT',
      'name': 'Perguruan Tinggi',
    },
  ];

  final List<Color> tingkatsColors = [
    Color(0xff08CA1C),
    Color(0xffED9818),
    Color(0xff1D73C2),
    Color(0xffDB1616),
    Color(0xff971DC2),
    Color(0xff90630C),
    Color(0xffB99E67),
    Color(0xffAD78F0),
  ];

  int tingkatsActive;
  bool tingkatsInvalid = false;

  void toggleTingkatsActive(int index) {
    setState(() {
      _tingkat = tingkats[index]['abbr'];
      tingkatsActive = index;
    });
  }

  final jumlahLulusan = {
    'normal': [
      FieldModel(name: 'Jumlah Lulusan TS-4'),
      FieldModel(name: 'Jumlah Lulusan TS-3'),
      FieldModel(name: 'Jumlah Lulusan TS-2'),
    ],
    'terlacak': [
      FieldModel(name: 'Jumlah Lulusan TS-4'),
      FieldModel(name: 'Jumlah Lulusan TS-3'),
      FieldModel(name: 'Jumlah Lulusan TS-2'),
    ],
    'tanggap': [
      FieldModel(name: 'Jumlah Lulusan TS-4'),
      FieldModel(name: 'Jumlah Lulusan TS-3'),
      FieldModel(name: 'Jumlah Lulusan TS-2'),
    ]
  };

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

    Widget _studyProgramNameField() => Theme(
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
              border: new UnderlineInputBorder(
                borderSide: new BorderSide(
                    color: Colors.white, style: BorderStyle.solid),
              ),
            ),
          ),
          data: Theme.of(context).copyWith(primaryColor: Constants.accentColor),
        );

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
      int key,
      String abbr = 'fadil',
      String name = 'fadil',
      Color color,
    }) {
      print(key);
      return Container(
        key: ValueKey(key),
        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: RaisedButton(
            color: tingkatsActive == key ? color : Colors.white,
            onPressed: () => toggleTingkatsActive(key),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    abbr,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: tingkatsActive == key ? Colors.white : color),
                  ),
                ),
                Expanded(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          tingkatsActive == key ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // TODO: Refactor using loop, set data on sqlite
    Widget _chooseStudyProgram() => GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 16 / 7,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(tingkats.length, (index) {
            return _studyProgram(
              key: index,
              color: tingkatsColors[index],
              abbr: tingkats[index]['abbr'],
              name: tingkats[index]['name'],
            );
          }),
        );

    Widget prodiNameContainer() => Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _studyProgramNameLabel(),
              _studyProgramNameField(),
            ],
          ),
        );

    Widget studyProgramsContainer() => Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              _chooseStudyProgramLabel(),
              SizedBox(
                height: 16,
              ),
              _chooseStudyProgram(),
              if (tingkatsInvalid)
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

    Widget _jumlahLulusanItem(String fieldLabel, onSaved) => Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        fieldLabel,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Theme(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide value';
                            }
                            return null;
                          },
                          onSaved: onSaved,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.edit),
                            border: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.white,
                                  style: BorderStyle.solid),
                            ),
                          ),
                        ),
                        data: Theme.of(context)
                            .copyWith(primaryColor: Constants.accentColor),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );

    Widget jumlahLulusanNormalContainer() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Constants.lulusanNormal,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...List.generate(jumlahLulusan['normal'].length, (index) {
            return _jumlahLulusanItem(
              jumlahLulusan['normal'][index].name,
              (value) => jumlahLulusan['normal'][index].value = value,
            );
          }),
        ],
      );
    }

    Widget jumlahLulusanTerlacakContainer() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Constants.lulusanTerlacak,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...List.generate(jumlahLulusan['terlacak'].length, (index) {
            return _jumlahLulusanItem(
              jumlahLulusan['terlacak'][index].name,
              (value) => jumlahLulusan['terlacak'][index].value = value,
            );
          }),
        ],
      );
    }

    Widget jumlahLulusanTanggapContainer() {
      return Column(
        children: <Widget>[
          Text(
            Constants.lulusanTanggap,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...List.generate(jumlahLulusan['tanggap'].length, (index) {
            return _jumlahLulusanItem(
              jumlahLulusan['tanggap'][index].name,
              (value) => jumlahLulusan['tanggap'][index].value = value,
            );
          }),
        ],
      );
    }

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
                  tingkatsInvalid = true;
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
              SizedBox(height: 20),
              prodiNameContainer(),
              SizedBox(height: 20),
              studyProgramsContainer(),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    jumlahLulusanNormalContainer(),
                    SizedBox(height: 24),
                    jumlahLulusanTerlacakContainer(),
                    SizedBox(height: 24),
                    if (tingkatsActive ==  )
                      jumlahLulusanTanggapContainer(),
                      SizedBox(height: 24),
                    SizedBox(height: 24),
                  ],
                ),
              ),
              btnNext()
            ],
          ),
        ),
      ),
    );
  }
}
