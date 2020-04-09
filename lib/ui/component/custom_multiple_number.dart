import 'package:flutter/material.dart';
import 'package:isk_aps_calc/constants.dart';

class CustomMultipleNumber extends StatefulWidget {
  final String label;
  final dynamic defaultValue;

  CustomMultipleNumber({
    this.label,
    this.defaultValue = const ['Sangat Baik', 'Baik', 'Cukup', 'Kurang'],
  });

  @override
  _CustomMultipleNumberState createState() => _CustomMultipleNumberState();
}

class _CustomMultipleNumberState extends State<CustomMultipleNumber> {
  Map<String, dynamic> map = Map<String, dynamic>();

  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(widget.label),
        Column(
          children: List.generate(widget.defaultValue.length, (index) {
            return Row(
              children: <Widget>[
                // Text(widget.defaultValue[index]),
                Theme(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    onSaved: (value) => map[widget.defaultValue[index]] = value,
                    decoration: InputDecoration(
                      labelText: widget.defaultValue[index],
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                  data: Theme.of(context)
                      .copyWith(primaryColor: Constants.accentColor),
                ),
              ],
            );
          }),
        )
      ],
    );
  }
}
