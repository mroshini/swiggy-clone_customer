import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/arguments_model/auth_argument_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/auth/auth_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/auth_textField.dart';
import 'package:foodstar/src/ui/shared/buttons/form_submit_button.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/validation.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final AuthArgumentsModel args;

  ResetPasswordScreen({Key key, this.args}) : super(key: key);

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passWordTextController;
  TextEditingController confirmPassWordTextController;
  TextEditingController codeTextController;
  FocusNode passwordFocus;
  FocusNode codeFocus;
  FocusNode confirmPasswordFocus;
  final _formKey = GlobalKey<FormState>();
  var _showPassword = false;

  @override
  void initState() {
    codeTextController = TextEditingController();
    passWordTextController = TextEditingController();
    confirmPassWordTextController = TextEditingController();
    passwordFocus = FocusNode();
    confirmPasswordFocus = FocusNode();
    codeFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    codeTextController.dispose();
    passWordTextController.dispose();
    confirmPassWordTextController.dispose();
    codeFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();

    super.dispose();
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
        elevation: 0.0,
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, model, child) => SafeArea(
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
                        'Reset Password',
                        style: Theme.of(context).textTheme.headline,
                      ),
                      verticalSizedBox(),
                      Visibility(
                        visible: model.state == ViewState.Busy ? false : true,
                        child: Text(
                          widget.args.info == "" ? "" : widget.args.info,
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                      Text(
                        'Enter code',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      AuthTextField(
                        textField: TextFormField(
                          controller: codeTextController,
                          keyboardType: TextInputType.number,
                          style: Theme.of(context).textTheme.body2,
                          validator: (value) {
                            return nameValidation(value);
                          },
                          onFieldSubmitted: (term) {
                            codeFocus.unfocus();
                            FocusScope.of(context).requestFocus(passwordFocus);
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'code',
                            hintStyle:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.grey[400],
                                    ),
                            counterText: '',
                          ),
                          onSaved: (value) => codeTextController.text = value,
                          focusNode: codeFocus,
                        ),
                      ),
                      AuthTextField(
                        textField: TextFormField(
                          controller: passWordTextController,
                          textInputAction: TextInputAction.next,
                          style: Theme.of(context).textTheme.body1,
                          validator: (value) {
                            return passwordValidation(value);
                          },
                          obscureText: !_showPassword,
                          onSaved: (value) =>
                              passWordTextController.text = value,
                          onFieldSubmitted: (term) {
                            passwordFocus.unfocus();
                            FocusScope.of(context)
                                .requestFocus(confirmPasswordFocus);
                          },
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              child: Icon(
                                _showPassword
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
                      AuthTextField(
                        textField: TextFormField(
                          controller: confirmPassWordTextController,
                          textInputAction: TextInputAction.done,
                          style: Theme.of(context).textTheme.body1,
                          validator: (value) {
                            return passwordValidation(value);
                          },
                          obscureText: !_showPassword,
                          onSaved: (value) =>
                              confirmPassWordTextController.text = value,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              child: Icon(_showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            border: InputBorder.none,
                            hintText: S.of(context).password,
                            hintStyle:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.grey[400],
                                    ),
                            counterText: '',
                          ),
                          focusNode: confirmPasswordFocus,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: model.state == ViewState.Busy
                            ? showProgress(context)
                            : FormSubmitButton(
                                title: S.of(context).continue_button_text,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    _formKey.currentState.save();
                                    model.initAuthApiRequest(
                                      dynamicAuthMap: {
                                        emailKey: widget.args.emailOrCode,
                                        passwordKey:
                                            passWordTextController.text,
                                        passwordConfirmationKey:
                                            confirmPassWordTextController.text,
                                        userTypeKey: userType,
                                        codeKey: codeTextController.text,
                                        //codeTextController.text,
                                      },
                                      url: resetPasswordUrl,
                                      urlType: post, //put,
                                      parentContext: context,
                                    ).then((value) => {
                                          if (value != null)
                                            {
                                              Navigator.pushReplacementNamed(
                                                  context, login)
                                            }
                                        });
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
