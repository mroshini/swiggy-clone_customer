import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/arguments_model/auth_argument_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/auth/auth_view_model.dart';
import 'package:foodstar/src/ui/shared/auth_textField.dart';
import 'package:foodstar/src/ui/shared/buttons/form_submit_button.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/utils/validation.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailTextController;
  final _formKey = GlobalKey<FormState>();
  FocusNode emailFocus;

  @override
  void initState() {
    emailTextController = TextEditingController();
    emailFocus = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 800,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).forgotPassword,
                      style: Theme.of(context).textTheme.headline,
                    ),
                    SizedBox(width: 10, height: 10),
                    Text(
                      'Enter registered email',
                      style: Theme.of(context).textTheme.body2,
                    ),
                    AuthTextField(
                      textField: TextFormField(
                        controller: emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        style: Theme.of(context).textTheme.body1,
                        validator: (value) {
                          return emailValidation(value);
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: S.of(context).email,
                          hintStyle:
                              Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: Colors.grey[400],
                                  ),
                          counterText: '',
                        ),
                        onSaved: (value) => emailTextController.text = value,
                        focusNode: emailFocus,
                      ),
                    ),
                    SizedBox(width: 15, height: 20),
                    Consumer<AuthViewModel>(builder: (context, model, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 10.0,
                        ),
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
                                        emailKey: emailTextController.text,
                                        userTypeKey: userType,
                                      },
                                      urlType: post, //put,
                                      url: forgetPasswordUrl,
                                      parentContext: context,
                                    ).then(
                                      (value) => {
                                        if (value != null)
                                          {
                                            Navigator.popAndPushNamed(
                                              context,
                                              resetPassword,
                                              arguments: AuthArgumentsModel(
                                                emailOrCode:
                                                    emailTextController.text,
                                                info: value.message,
                                              ),
                                            ),
                                          }
                                      },
                                    );
                                  }
                                },
                              ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
