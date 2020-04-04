import 'package:flutter/material.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';

import 'package:isk_aps_calc/ui/page/simulation/result_page.dart';

import 'package:isk_aps_calc/ui/component/custom_appbar.dart';
import 'package:isk_aps_calc/ui/component/custom_radio_button.dart';
import 'package:isk_aps_calc/ui/component/rounded_button.dart';
import 'package:provider/provider.dart';

class KuriKulumPage extends StatefulWidget {
  static const String tag = '/simulasi/create#kurikulum';

  @override
  _KuriKulumPageState createState() => _KuriKulumPageState();
}

class _KuriKulumPageState extends State<KuriKulumPage> {
  @override
  Widget build(context) {
    final simulationBloc = Provider.of<SimulationBloc>(context);

    Widget txtKurikulum() => Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Kurikulum',
                  style: Constants.titleStyle,
                ),
              ],
            ),
            Text(
              'Pilih salah satu yang sesuai dengan kondisi Program Studi anda',
            )
          ],
        );

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            txtKurikulum(),
            CustomRadioButton(
                values: [
                  'A',
                  'B',
                  'C',
                  'D',
                  'E',
                  'F',
                ],
                // groupValue: _kondisiProdi,
                onChanged: (dynamic value) {}),
            Container(
              margin: EdgeInsets.only(top: 24.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 200.0,
                      child: RoundedButton(
                          items: <Widget>[
                            Text('Lanjutkan',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                          onPressed: () {
                            Navigator.of(context).pushNamed(ResultPage.tag);
                          }),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('1 dari 8')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
