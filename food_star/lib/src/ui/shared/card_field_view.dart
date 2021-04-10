import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';

enum CardFieldType {
  changeNumber,
  password,
  number,
  none,
}

class CardFieldView extends StatefulWidget {
  bool isSecureText = false;
  final String hint;
  final CardFieldType cardFieldType;
  final TextEditingController fieldController;
  final TextInputType fieldType;
  final TextInputAction keyboardBtn;
  final FocusNode currentFieldFocus;
  final FocusNode nextFieldFocus;
  final int length;

  CardFieldView(
      {this.hint,
      this.cardFieldType,
      this.fieldController,
      this.fieldType,
      this.keyboardBtn,
      this.currentFieldFocus,
      this.nextFieldFocus,
      this.length = 50});

  @override
  _CardFieldViewState createState() => _CardFieldViewState();
}

class _CardFieldViewState extends State<CardFieldView> {
  IconData eyeIcon = Icons.visibility_off;

  @override
  void initState() {
    super.initState();
    if (widget.cardFieldType == CardFieldType.password) {
      widget.isSecureText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.only(
        top: 15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: (widget.cardFieldType == CardFieldType.changeNumber ||
                    widget.cardFieldType == CardFieldType.number)
                ? true
                : false,
            child: Container(
              width: 50.0,
              margin:
                  const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
              child: buildCountryCodeView(),
            ),
          ),
          buildFieldView(),
          buildTrailingView(),
        ],
      ),
    );
  }

  Text buildCountryCodeView() => Text(
        '+91 -',
        style: TextStyle(
            fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
      );

  Expanded buildFieldView() => Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            enabled: widget.cardFieldType == CardFieldType.changeNumber
                ? false
                : true,
            obscureText: widget.isSecureText,
            keyboardType: widget.fieldType,
            textInputAction: widget.keyboardBtn,
            controller: widget.fieldController,
            maxLength: widget.length,
            style: TextStyle(fontSize: 15.0, color: Colors.black),
            focusNode: widget.currentFieldFocus,
            onFieldSubmitted: (term) {
              widget.currentFieldFocus.unfocus();
              FocusScope.of(context).requestFocus(widget.nextFieldFocus);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              counterText: '',
            ),
          ),
        ),
      );

  FlatButton buildChangeButton() => FlatButton(
        child: Text(
          S.of(context).change,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );

  Widget buildTrailingView() {
    if (widget.cardFieldType == CardFieldType.password) {
      return IconButton(
        icon: Icon(eyeIcon),
        onPressed: () {
          setState(() {
            eyeIcon =
                widget.isSecureText ? Icons.visibility : Icons.visibility_off;
            widget.isSecureText = !widget.isSecureText;
          });
        },
      );
    } else if (widget.cardFieldType == CardFieldType.changeNumber) {
      return buildChangeButton();
    }
    return Container();
  }
}
