import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/simulation/simulation_bloc.dart';
import 'package:isk_aps_calc/data/bloc/simulation/simulation_state.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final double appBarHeight = 80.0;
  @override
  get preferredSize => Size.fromHeight(appBarHeight);
  
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      child: BlocBuilder(
        bloc: BlocProvider.of<SimulationBloc>(context), 
        builder: (context, SimulationState state) {
          return  Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Constants.accentColor,
                    ),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).maybePop();
                      }
                    }),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Simulasi Baru',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Constants.accentColor),
                    ),
                  ],
                ),
              ),
              if ( state is NewlySimulationState ) ...[
                Expanded(
                  child: Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      color: Constants.accentColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          state.prodi['tingkat'],
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        Text(
                          state.prodi['nama'],
                          style: TextStyle(fontSize: 10.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              ]
              
            ],
          );
      
        }
         
      ),
      decoration: BoxDecoration(color: Constants.primaryColor),
    );
  }
}
