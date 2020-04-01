import 'package:flutter/material.dart';
import 'package:isk_aps_calc/constants.dart';

class CustomFormField extends StatefulWidget {
  CustomFormField({
    Key key,
    this.context,
    this.controller,
    this.prefixIcon,
    this.suffixIcon = const Icon(Icons.edit),
    this.hintText
  }) : super(key: key);

  final context, controller, prefixIcon, suffixIcon, hintText;

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          hintText: widget.hintText,
          contentPadding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4)
          )
        ),
      ),
      data: Theme.of(context).copyWith(
        primaryColor: Constants.accentColor
      )
    );
  }
}

class CustomFormFieldText extends StatefulWidget {

  CustomFormFieldText({
    Key key,
    this.text, 
    this.formField
  }) : 
    super(key: key);

  final text, formField;

  @override
  _CustomFormFieldTextState createState() => _CustomFormFieldTextState();
}

class _CustomFormFieldTextState extends State<CustomFormFieldText> {
  @override
  Widget build(BuildContext context) {
    return Container(
    padding: EdgeInsets.only(top: 16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        widget.text,
        widget.formField
      ],
    ),
  );
  }
}