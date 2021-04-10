import 'package:flutter/material.dart';

enum CardFieldType {
  changeNumber,
  password,
  number,
  none,
}

class AuthTextField extends StatefulWidget {
  final Widget textField;

  AuthTextField({this.textField});

  @override
  _AuthTextFieldViewState createState() => _AuthTextFieldViewState();
}

class _AuthTextFieldViewState extends State<AuthTextField> {
  IconData eyeIcon = Icons.visibility_off;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.only(
        top: 15,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.textField,
      ),
    );
  }

//  Text buildCountryCodeView() => Text(
//        '+91 -',
//        style: TextStyle(
//            fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
//      );
//
//  Expanded buildFieldView() => Expanded(
//        flex: 2,
//        child: Padding(
//          padding: const EdgeInsets.all(10.0),
//          child: TextFormField(
//            enabled: widget.cardFieldType == CardFieldType.changeNumber
//                ? false
//                : true,
//            obscureText: widget.isSecureText,
//            keyboardType: widget.fieldType,
//            textInputAction: widget.keyboardBtn,
//            controller: widget.fieldController,
//            maxLength: widget.length,
//            style: TextStyle(fontSize: 15.0, color: Colors.black),
//            focusNode: widget.currentFieldFocus,
//            onFieldSubmitted: (term) {
//              widget.currentFieldFocus.unfocus();
//              FocusScope.of(context).requestFocus(widget.nextFieldFocus);
//            },
//            decoration: InputDecoration(
//              border: InputBorder.none,
//              hintText: widget.hint,
//              hintStyle: TextStyle(color: Colors.grey[400]),
//              counterText: '',
//            ),
//          ),
//        ),
//      );
//
//  FlatButton buildChangeButton() => FlatButton(
//        child: Text(
//          S.of(context).change,
//          style: TextStyle(color: Theme.of(context).accentColor),
//        ),
//        onPressed: () {
//          Navigator.pop(context);
//        },
//      );
//
//  Widget buildTrailingView() {
//    if (widget.cardFieldType == CardFieldType.password) {
//      return IconButton(
//        icon: Icon(eyeIcon),
//        onPressed: () {
//          setState(() {
//            eyeIcon =
//                widget.isSecureText ? Icons.visibility : Icons.visibility_off;
//            widget.isSecureText = !widget.isSecureText;
//          });
//        },
//      );
//    } else if (widget.cardFieldType == CardFieldType.changeNumber) {
//      return buildChangeButton();
//    }
//    return Container();
//  }
}
