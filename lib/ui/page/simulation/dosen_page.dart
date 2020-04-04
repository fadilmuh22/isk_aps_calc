import 'package:flutter/material.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';

import 'package:isk_aps_calc/ui/component/custom_appbar.dart';
import 'package:isk_aps_calc/ui/component/custom_form_field.dart';

import 'package:isk_aps_calc/ui/component/rounded_button.dart';
import 'package:isk_aps_calc/ui/page/simulation/kurikulum_page.dart';
import 'package:provider/provider.dart';

class DosenPage extends StatefulWidget {
  static const String tag = '/simulasi/create#dosen';

  @override
  _DosenPageState createState() => _DosenPageState();
}

class _DosenPageState extends State<DosenPage> {
  @override
  Widget build(context) {
    final simulationBloc = Provider.of<SimulationBloc>(context);

    Widget dtpsLabel() => Text(
          'Dosen Tetap (DTPS)',
          style: Constants.titleStyle,
        );

    Widget btnNext(BuildContext context) => RoundedButton(
          items: <Widget>[
            Text('Lanjutkan',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            Icon(Icons.keyboard_arrow_right)
          ],
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: simulationBloc,
                  child: KuriKulumPage(),
                ),
              ),
            );
          },
        );

    dtpsField() => CustomFormFieldText(
      text: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Jumlah DTPS'),
        ],
      ),
      formField: CustomFormField(context: context),
    );
    
    return Scaffold(
      appBar: CustomAppBar(
        // newSimulation: true,
        tingkat: simulationBloc.simulation.tingkat,
        prodiName: simulationBloc.simulation.prodiName,
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
                    SizedBox(
                      width: 200.0,
                      child: btnNext(context),
                    ),
                    SizedBox(
                      height: 20.0,
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

}
