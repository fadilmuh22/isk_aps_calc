import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {

  CustomRadioButton({
    this.values,
    this.groupValue,
    this.onChanged
  });

  final List<String> values;
  final Function onChanged;
  final groupValue;

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {

  String capitalize(String value) => value[0].toUpperCase() + value.substring(1);

  List<Container> mapRadioButtonValues({
    List<String> values,
    groupValue,
    Function onChanged
  }) {
    List<Container> radios = new List();

    values.forEach((value) => radios.add(
      Container(
        child: RadioListTile(
          title: Text(capitalize(value)),
          value: value,
          groupValue: groupValue,
          onChanged: onChanged
        ),
      ),
    ));

    return radios;
  }

  @override
  Widget build(context) {
    return Column(
        children: mapRadioButtonValues(
          values: widget.values, 
          groupValue: widget.groupValue, 
          onChanged: widget.onChanged
        ),
    );
  }
}