import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  CustomRadio({
    this.values,
    this.groupValue,
    this.onChanged,
  });

  final List<String> values;
  final Function onChanged;
  final groupValue;

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  List<Container> mapRadioValues({
    List<String> values,
    groupValue,
    Function onChanged,
  }) {
    List<Container> radios = new List();

    values.forEach((value) => radios.add(
          Container(
            child: RadioListTile(
              key: UniqueKey(),
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
          ),
        ));

    return radios;
  }

  @override
  Widget build(context) {
    return Column(
      children: mapRadioValues(
        values: widget.values,
        groupValue: widget.groupValue,
        onChanged: widget.onChanged,
      ),
    );
  }
}
