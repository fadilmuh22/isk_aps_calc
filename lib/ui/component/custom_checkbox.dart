import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  CustomCheckBox({
    this.values,
    this.groupValue,
    this.onChanged,
  });

  final List<String> values;
  final Function onChanged;
  final groupValue;

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  List<Container> mapCheckBoxValues({
    List<String> values,
    groupValue,
    Function onChanged,
  }) {
    List<Container> radios = new List();

    values.forEach((value) => radios.add(
          Container(
            child: RadioListTile(
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
      children: mapCheckBoxValues(
        values: widget.values,
        groupValue: widget.groupValue,
        onChanged: widget.onChanged,
      ),
    );
  }
}
