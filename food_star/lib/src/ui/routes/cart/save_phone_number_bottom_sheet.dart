import 'package:flutter/material.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/validation.dart';
import 'package:provider/provider.dart';

class SavePhoneNumberBottomSheet extends StatefulWidget {
  final String phoneNumber;

  SavePhoneNumberBottomSheet({
    this.phoneNumber,
  });

  @override
  _SavePhoneNumberBottomSheetState createState() =>
      _SavePhoneNumberBottomSheetState();
}

class _SavePhoneNumberBottomSheetState
    extends State<SavePhoneNumberBottomSheet> {
  TextEditingController mobileNumberController;
  FocusNode numberFocus = new FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    mobileNumberController = TextEditingController(text: widget.phoneNumber);
    numberFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    numberFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartBillDetailViewModel>(builder:
        (BuildContext context, CartBillDetailViewModel model, Widget child) {
      return Container(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    dragIcon(),
                    verticalSizedBox(),
//                  Text(
//                    'Enter Phone number',
//                    style: Theme.of(context).textTheme.display1,
//                  ),
//                  verticalSizedBoxFive(),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: mobileNumberController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        focusNode: numberFocus,
                        validator: (value) {
                          return mobileNumberValidation(value);
                        },
                        onChanged: (value) {
                          // filterSearchResults(value);
                        },
                        onSaved: (value) => {
                          mobileNumberController.text = value,
                        },
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: "Phone number",
                          border: InputBorder.none,
                          // labelText: "Phone number",
                          //labelStyle: TextStyle(fontSize: 15, color: Colors.grey),
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.save,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _formKey.currentState.save();
                                Navigator.pop(
                                    context, mobileNumberController.text);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    verticalSizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
