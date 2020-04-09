import 'package:flutter/material.dart';

import 'package:isk_aps_calc/data/model/new_simulation_model.dart';
import 'package:isk_aps_calc/ui/page/simulation/indicator_page.dart';

import 'package:provider/provider.dart';

import 'package:isk_aps_calc/constants.dart';

import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';

import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';
import 'package:isk_aps_calc/data/model/field_model.dart';
import 'package:isk_aps_calc/ui/component/custom_appbar.dart';

class NewSimulationPage extends StatefulWidget {
  static const String tag = '/simulatsi/create';

  @override
  _NewSimulationPageState createState() => _NewSimulationPageState();
}

class _NewSimulationPageState extends State<NewSimulationPage> {
  final _formKey = GlobalKey<FormState>();

  String _educationStageName = '', _studyProgramName = '';

  final List<Map<String, dynamic>> educationStages = [
    {
      'id': 1,
      'name': 'D3',
      'desc': 'Diploma 3',
    },
    {
      'id': 2,
      'name': 'D4',
      'desc': 'Sarjana Terapan',
    },
    {
      'id': 3,
      'name': 'S1',
      'desc': 'Sarjana',
    },
    {
      'id': 4,
      'name': 'S2',
      'desc': 'Magister',
    },
    {
      'id': 5,
      'name': 'S2',
      'desc': 'Magister Terapan',
    },
    {
      'id': 6,
      'name': 'S3',
      'desc': 'Doktor',
    },
    {
      'id': 7,
      'name': 'S3',
      'desc': 'Doktor Terapan',
    },
    {
      'id': 8,
      'name': 'PT',
      'desc': 'Perguruan Tinggi',
    },
  ];

  final List<Color> educationStagesColors = [
    Color(0xff08CA1C),
    Color(0xffED9818),
    Color(0xff1D73C2),
    Color(0xffDB1616),
    Color(0xff971DC2),
    Color(0xff90630C),
    Color(0xffB99E67),
    Color(0xffAD78F0),
  ];

  int educationStagesActive;
  bool educationStagesInvalid = false;

  void toggleEducationStagesActive(int index) {
    setState(() {
      _educationStageName = educationStages[index]['name'];
      educationStagesActive = index;
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
    return Scaffold(
      appBar: CustomAppBar(newSimulation: true),
      body: Container(
        child: ListView(children: [
          Form(
            key: _formKey,
            child: Column(
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
                      if (educationStagesActive != null &&
                          educationStagesActive > 3)
                        jumlahLulusanTanggapContainer(),
                      SizedBox(height: 24),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
                nextButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ]),
      ),
    );
  }

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
            if (educationStagesInvalid)
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

  Widget nextButton() => SizedBox(
        width: 200.0,
        child: CustomRoundedButton(
          items: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Lanjutkan',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            Icon(Icons.keyboard_arrow_right)
          ],
          onPressed: () {
            if (/**_formKey.currentState.validate() &&  _tingkat.isNotEmpty */ true) {
              // _formKey.currentState.save();

              var model = NewSimulationModel(
                studyProgramName: _studyProgramName,
                educationStageName: _educationStageName,
              );
              Provider.of<SimulationBloc>(context, listen: false)
                  .newSimulation = model;

              Navigator.of(context).pushNamed(IndicatorPage.tag);
            } else if (_educationStageName.isEmpty) {
              setState(() {
                educationStagesInvalid = true;
              });
            }
          },
        ),
      );

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
          onSaved: (value) => _educationStageName = value,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.edit),
            border: new UnderlineInputBorder(
              borderSide:
                  new BorderSide(color: Colors.white, style: BorderStyle.solid),
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

  Widget _studyProgram(
    context, {
    int key,
    String name = 'fadil',
    String desc = 'fadil',
    Color color,
  }) {
    return Container(
      key: ValueKey(key),
      margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: RaisedButton(
          color: educationStagesActive == key ? color : Colors.white,
          onPressed: () => toggleEducationStagesActive(key),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color:
                          educationStagesActive == key ? Colors.white : color),
                ),
              ),
              Flexible(
                child: Text(
                  desc,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: educationStagesActive == key
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chooseStudyProgram() => GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 16 / 7,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          educationStages.length,
          (index) {
            return _studyProgram(
              context,
              key: index,
              color: educationStagesColors[index],
              name: educationStages[index]['name'],
              desc: educationStages[index]['desc'],
            );
          },
        ),
      );

  Widget _jumlahLulusanItem(String fieldLabel, onSaved) => Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Flexible(
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
                  Flexible(
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
                                color: Colors.white, style: BorderStyle.solid),
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
}
