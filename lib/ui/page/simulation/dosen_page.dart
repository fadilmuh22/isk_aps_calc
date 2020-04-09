import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';

import 'package:isk_aps_calc/ui/component/custom_appbar.dart';
import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';

import 'package:isk_aps_calc/ui/page/simulation/kurikulum_page.dart';

class DosenPage extends StatefulWidget {
  static const String tag = '/simulasi/create#dosen';

  @override
  _DosenPageState createState() => _DosenPageState();
}

class _DosenPageState extends State<DosenPage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: CustomAppBar(
        // newSimulation: true,
        educationStageName: Provider.of<SimulationBloc>(context)
            .newSimulation
            .educationStageName,
        studyProgramName:
            Provider.of<SimulationBloc>(context).newSimulation.studyProgramName,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Container(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              dtpsLabel(),
              dtpsField(),
              SizedBox(height: 80.0),
              Center(
                child: Column(
                  children: <Widget>[
                    nextButton(),
                    SizedBox(
                      height: 24.0,
                    ),
                    Text('2 dari 8')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dtpsLabel() => Text(
        'Dosen Tetap (DTPS)',
        style: Constants.titleStyle,
      );

  Widget dtpsField() => Theme(
        child: TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          validator: (value) {
            if (value.isEmpty) {
              return 'This must be filled';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'DTPS',
            border: new UnderlineInputBorder(
              borderSide:
                  new BorderSide(color: Colors.white, style: BorderStyle.solid),
            ),
            contentPadding: EdgeInsets.only(
              left: 20.0,
              top: 10.0,
              right: 20.0,
              bottom: 10.0,
            ),
            suffixIcon: Icon(Icons.edit),
          ),
        ),
        data: Theme.of(context).copyWith(primaryColor: Constants.accentColor),
      );

  Widget nextButton() => SizedBox(
        width: 200.0,
        child: CustomRoundedButton(
          items: <Widget>[
            Text('Lanjutkan',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            Icon(Icons.keyboard_arrow_right)
          ],
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: Provider.of<SimulationBloc>(context),
                  child: KuriKulumPage(),
                ),
              ),
            );
          },
        ),
      );
}
