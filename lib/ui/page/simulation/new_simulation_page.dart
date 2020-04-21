import 'package:flutter/material.dart';
import 'package:isk_aps_calc/util/validator.dart';
import 'package:provider/provider.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/model/jumlah_lulusan_model.dart';
import 'package:isk_aps_calc/data/model/new_simulation_model.dart';

import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';

import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';
import 'package:isk_aps_calc/ui/component/custom_appbar.dart';

import 'package:isk_aps_calc/ui/page/simulation/indicator_page.dart';

class NewSimulationPage extends StatefulWidget {
  static const String tag = '/simulatsi/create';

  @override
  _NewSimulationPageState createState() => _NewSimulationPageState();
}

class _NewSimulationPageState extends State<NewSimulationPage> {
  final _formKey = GlobalKey<FormState>();

  NewSimulationModel newSimulation = NewSimulationModel(
    jumlahLulusan: [
      JumlahLulusanModel(type: Constants.lulusanNormal, variable: 'NLtotal'),
      JumlahLulusanModel(type: Constants.lulusanTerlacak, variable: 'NJtotal'),
      JumlahLulusanModel(type: Constants.lulusanTanggap, variable: 'NJItotal'),
    ],
  );

  int educationStagesActive;

  final currentAccreditations = ['A', 'B', 'C'];

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

  void toggleEducationStagesActive(int index) {
    setState(() {
      newSimulation.educationStage = educationStages[index]['id'];
      newSimulation.educationStageName = educationStages[index]['name'];
      if (educationStagesActive == index) {
        educationStagesActive = null;
      } else {
        educationStagesActive = index;
      }
    });
  }

  handleNextButton() async {
    if (_formKey.currentState.validate() &&
        newSimulation.educationStageName != null &&
        newSimulation.currentAccreditation != null) {
      _formKey.currentState.save();

      Provider.of<SimulationBloc>(context, listen: false).newSimulation =
          newSimulation;

      await Provider.of<SimulationBloc>(context, listen: false)
          .mappingIndicator();

      Navigator.pushNamed(context, IndicatorPage.tag);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: CustomAppBar(newSimulation: true),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          child: ListView(children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  studyProgramNameContainer(),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: currentAccreditation(),
                  ),
                  SizedBox(height: 10.0),
                  educationStagesContainer(),
                  SizedBox(height: 36.0),
                  nextButton(),
                  SizedBox(height: 36.0),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget studyProgramNameContainer() => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _studyProgramNameLabel(),
            _studyProgramNameField(),
          ],
        ),
      );

  Widget currentAccreditation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Akreditasi Saat Ini:'),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: DropdownButton(
                  isExpanded: true,
                  value: newSimulation.currentAccreditation,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Constants.accentColor,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      newSimulation.currentAccreditation = newValue;
                    });
                  },
                  items: currentAccreditations.map((value) {
                    return DropdownMenuItem(
                      child: new Text(value),
                      value: value,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        if (newSimulation.currentAccreditation == null) textValidation(),
      ],
    );
  }

  Widget textValidation() {
    return Text(
      'Please select one',
      style: TextStyle(
        color: Colors.red,
        fontSize: 12,
      ),
    );
  }

  Widget educationStagesContainer() => Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _chooseStudyProgramLabel(),
            SizedBox(
              height: 16,
            ),
            _chooseStudyProgram(),
            if (newSimulation.educationStage == null) textValidation(),
          ],
        ),
      );

  bool isMagister(int index) {
    return newSimulation.jumlahLulusan[index].type ==
                Constants.lulusanTanggap &&
            educationStagesActive != null &&
            educationStagesActive == 3 ||
        educationStagesActive == 4;
  }

  bool isNotMagister(int index) {
    return newSimulation.jumlahLulusan[index].type !=
            Constants.lulusanTanggap &&
        educationStagesActive != null &&
        educationStagesActive <= 4;
  }

  Widget jumlahLulusanContainer() {
    return Column(
      children: <Widget>[
        ...List.generate(newSimulation.jumlahLulusan.length, (index) {
          if (isMagister(index)) {
            return Padding(
              padding: EdgeInsets.only(bottom: 36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    newSimulation.jumlahLulusan[index].type,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...List.generate(
                      newSimulation.jumlahLulusan[index].title.length, (fadil) {
                    newSimulation.jumlahLulusan[index].value = new List(3);
                    return _jumlahLulusanItem(
                      newSimulation.jumlahLulusan[index].title[fadil],
                      (value) => newSimulation.jumlahLulusan[index]
                          .value[fadil] = num.tryParse(value),
                    );
                  }),
                ],
              ),
            );
          } else if (isNotMagister(index)) {
            return Padding(
              padding: EdgeInsets.only(bottom: 36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    newSimulation.jumlahLulusan[index].type,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...List.generate(
                      newSimulation.jumlahLulusan[index].title.length, (fadil) {
                    newSimulation.jumlahLulusan[index].value = new List(3);
                    return _jumlahLulusanItem(
                      newSimulation.jumlahLulusan[index].title[fadil],
                      (value) => newSimulation.jumlahLulusan[index]
                          .value[fadil] = num.tryParse(value),
                    );
                  }),
                ],
              ),
            );
          } else {
            return Container();
          }
        }),
      ],
    );
  }

  Widget nextButton() => SizedBox(
        width: 140.0,
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
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
            )
          ],
          onPressed: handleNextButton,
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
          onSaved: (value) => newSimulation.studyProgramName = value,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 16.0),
            suffixIcon: Icon(Icons.edit, size: 20.0),
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
            style: TextStyle(fontSize: 16),
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
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                padding: EdgeInsets.only(right: 5),
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
                    padding: EdgeInsets.only(right: 8.0),
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
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        validator: Validator.number,
                        onSaved: onSaved,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(top: 16.0, left: 10.0),
                          suffixIcon: Icon(Icons.edit, size: 16.0),
                          border: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.white,
                              style: BorderStyle.solid,
                            ),
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
