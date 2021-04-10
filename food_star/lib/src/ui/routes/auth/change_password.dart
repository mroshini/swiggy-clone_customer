import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/core/provider_viewmodels/auth/auth_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/auth_textField.dart';
import 'package:foodstar/src/ui/shared/buttons/form_submit_button.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/validation.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPassWordTextController;
  TextEditingController passWordTextController;
  TextEditingController confirmPassWordTextController;
  TextEditingController codeTextController;
  FocusNode oldPasswordFocus;
  FocusNode passwordFocus;
  FocusNode confirmPasswordFocus;
  final _formKey = GlobalKey<FormState>();
  var _showOldPassword = false;
  var _showNewPassword = false;

  @override
  void initState() {
    passWordTextController = TextEditingController();
    confirmPassWordTextController = TextEditingController();
    oldPassWordTextController = TextEditingController();
    passwordFocus = FocusNode();
    confirmPasswordFocus = FocusNode();
    oldPasswordFocus = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 1.0,
        title: Text(
          "Change Password",
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 800,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 15.0, bottom: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Old Password ',
                      style: Theme.of(context).textTheme.display1,
                    ),
                    AuthTextField(
                      textField: TextFormField(
                        controller: oldPassWordTextController,
                        textInputAction: TextInputAction.next,
                        style: Theme.of(context).textTheme.display2,
                        validator: (value) {
                          return passwordValidation(value);
                        },
                        obscureText: !_showOldPassword,
                        onSaved: (value) =>
                            oldPassWordTextController.text = value,
                        onFieldSubmitted: (term) {
                          oldPasswordFocus.unfocus();
                          FocusScope.of(context).requestFocus(passwordFocus);
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showOldPassword = !_showOldPassword;
                              });
                            },
                            child: Icon(
                              _showOldPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: appColor,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: S.of(context).password,
                          hintStyle:
                              Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: Colors.grey[400],
                                  ),
                          counterText: '',
                        ),
                        focusNode: oldPasswordFocus,
                      ),
                    ),
                    verticalSizedBox(),
                    Text(
                      'New Password',
                      style: Theme.of(context).textTheme.display1,
                    ),
                    AuthTextField(
                      textField: TextFormField(
                        controller: passWordTextController,
                        textInputAction: TextInputAction.done,
                        style: Theme.of(context).textTheme.display2,
                        validator: (value) {
                          return passwordValidation(value);
                        },
                        obscureText: !_showNewPassword,
                        onSaved: (value) => passWordTextController.text = value,
                        onFieldSubmitted: (term) {
                          passwordFocus.unfocus();
                          FocusScope.of(context)
                              .requestFocus(confirmPasswordFocus);
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showNewPassword = !_showNewPassword;
                              });
                            },
                            child: Icon(
                              _showNewPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: appColor,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: S.of(context).password,
                          hintStyle:
                              Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: Colors.grey[400],
                                  ),
                          counterText: '',
                        ),
                        focusNode: passwordFocus,
                      ),
                    ),
                    verticalSizedBox(),
                    Consumer<AuthViewModel>(builder: (context, model, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: model.state == ViewState.Busy
                            ? showProgress(context)
                            : FormSubmitButton(
                                title: S.of(context).change,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    _formKey.currentState.save();
                                    model.initAuthApiRequest(
                                      dynamicAuthMap: {
                                        userTypeKey: userType,
                                        oldPasswordKey:
                                            oldPassWordTextController.text,
                                        newPasswordKey:
                                            passWordTextController.text,
                                      },
                                      url: changePasswordUrl,
                                      urlType: post, //put,
                                      parentContext: context,
                                    ).then((value) => {
                                          if (value != null)
                                            {
                                              //  Navigator.of(context).pop(),
                                              showAlertDialog(
                                                  context, value.message),
                                              // password changed successfully
                                            }
                                        });
                                  }
                                },
                              ),
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String successResponse) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: Theme.of(context).textTheme.display3,
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('alert');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      title: Text(
        successResponse,
        style: Theme.of(context).textTheme.display1,
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
