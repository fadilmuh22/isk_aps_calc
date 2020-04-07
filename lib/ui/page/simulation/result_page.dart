import 'package:flutter/material.dart';
import 'package:isk_aps_calc/ui/component/custom_appbar.dart';

class ResultPage extends StatefulWidget {
  static const String tag = '/simulasi/result';

  // final Function goToPage;

  // ResultPage({this.goToPage});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(context) {
    
    cardResult() => GestureDetector(
      onTap: () {
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.5)),
        color: Color.fromRGBO(130, 130, 130, 0.8),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/result_card_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(16),
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'TERAKREDITASI',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
    
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            cardResult()
          ],
        ),
      ),
    );
  }
}