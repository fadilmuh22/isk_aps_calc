import 'package:flutter/material.dart';

import 'package:isk_aps_calc/contants.dart';

class NewSimulation extends StatefulWidget {
  static const String tag = "new-simulation-page";
  @override
  _NewSimulationState createState() => _NewSimulationState();
}

class _NewSimulationState extends State<NewSimulation> {
  @override
  Widget build(BuildContext context) {

    final _txtStudyProgramName = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "Nama Prodi:",
        )
      ],
    );

    final _tffStudyProgramName = Theme(
      child: TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.edit),
          contentPadding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4)
          )
        ),
      ),
      data: Theme.of(context).copyWith(
        primaryColor: Constants.ACCENT_COLOR
      )
    );

    final _txtChooseStudyProgram = Padding(
      padding: EdgeInsets.only(left: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Pilih Program Pendidikan:",
            style: TextStyle(
              fontSize: 24
            ),
          ),
        ],
      )
    );
    

    Container _studyProgram({
      Text abbreviation,
      Text name
    }) => Container(
      margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: OutlineButton(
          onPressed: () {},
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: abbreviation,
              ),
              Expanded(child: name),
            ],
          ),
        ),
      ),
    );
    
    final _chooseStudyProgram = Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child:  _studyProgram(
                  abbreviation: Text(
                    "D3",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent
                    ),
                  ),
                  name: Text(
                    "Sarjana/Sarjana Terapan",
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ),
              Expanded(
                child: _studyProgram(
                  abbreviation: Text(
                    "S1\nD4",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent
                    ),
                  ),
                  name: Text(
                    "Sarjana/Sarjana Terapan",
                    overflow: TextOverflow.ellipsis,
                  )
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child:  _studyProgram(
                  abbreviation: Text(
                    "S2",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent
                    ),
                  ),
                  name: Text(
                    "Magister/Magister Terapan",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                child:  _studyProgram(
                  abbreviation: Text(
                    "S3",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent
                    ),
                  ),
                  name: Text(
                    "Doktor/Doktor Terapan",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          )
        ],
      )
    );

    final profileName = Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _txtStudyProgramName,
          _tffStudyProgramName
        ],
      ),
    );

    final studyProgram = Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          _txtChooseStudyProgram,
          _chooseStudyProgram
        ],
      ),
    );

    final btnNext = Container(
      width: 55.0,
      margin: EdgeInsets.only(left: 85.0, right: 85.0), 
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        onPressed: () {
          // Navigator.of(context).pushReplacementNamed(HomePage.tag);
        },
        color: Constants.ACCENT_COLOR,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Selanjutnya",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16
            )
          ),
        ),
      ),
    );

    return Scaffold(
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(5.0),
          children: <Widget>[
            SizedBox(height: 20,),
            profileName,
            SizedBox(height: 20,),
            studyProgram,
            SizedBox(height: 20,),
            btnNext
          ],
        ),
      )
    );
    
  }
}