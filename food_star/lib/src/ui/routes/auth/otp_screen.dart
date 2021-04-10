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
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:foodstar/src/utils/validation.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final Map<String, Object> otpInfo;

  OtpScreen({Key key, this.otpInfo}) : super(key: key);

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController;
  final _formKey = GlobalKey<FormState>();
  FocusNode otpFocus;
  var message;
  var email;
  var type; // 0 from profile email verify, 1- singup email verify

  @override
  void initState() {
    otpController = TextEditingController();
    otpFocus = FocusNode();

    message = widget.otpInfo['message'];
    email = widget.otpInfo['email'];
    type = widget.otpInfo['type'];
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, model, child) => SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: 800,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 15.0,
                  bottom: 20.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        S.of(context).enterOtp,
                        style: Theme.of(context).textTheme.headline,
                      ),
                      verticalSizedBox(),
                      Visibility(
                        visible: message == null ? false : true,
                        child: Text(
                          message,
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                      buildInfoMessageView(context),
                      AuthTextField(
                        textField: TextFormField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          style: Theme.of(context).textTheme.body1,
                          validator: (value) {
                            return nameValidation(value);
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
                          onSaved: (value) => otpController.text = value,
                          focusNode: otpFocus,
                        ),
                      ),
//                      CardFieldView(
//                        cardFieldType: CardFieldType.none,
//                        fieldController: otpController,
//                        hint: S.of(context).enterOtp,
//                        fieldType: TextInputType.number,
//                        keyboardBtn: TextInputAction.done,
//                      ),
                      SizedBox(width: 20, height: 30),
                      buildResendOtpView(context),
                      SizedBox(width: 15, height: 20),
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

                                    if (type == 0) {
                                      callApiForVerifyCodeAndSkip(
                                          'submit', model);
                                    } else {
                                      model.initAuthApiRequest(
                                        dynamicAuthMap: {
                                          codeKey: otpController.text,
                                          userTypeKey: userType,
                                        },
                                        urlType: post, //put,
                                        url: activeAccount,
                                        parentContext: context,
                                      ).then((value) => {
                                            if (value != null)
                                              {
                                                model.saveAuthToken(
                                                    value.accessToken,
                                                    value.id),
                                                model.setAuthState(
                                                    AuthState.authenticated),
                                                navigateToHome(context: context)
                                              }
                                          });
                                    }
                                  }
                                },
                              ),
                      ),
                      Visibility(
                        visible: type == 1 ? false : true,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              //call api for skip
                              callApiForVerifyCodeAndSkip('skip', model);
                            },
                            child: Text(
                              'Skip',
                              style: Theme.of(context).textTheme.display3,
                            ),
                          ),
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

  Container buildResendOtpView(BuildContext context) {
    final ThemeData timerTheme = Theme.of(context);
    timerTheme.copyWith(
      textTheme: timerTheme.textTheme.copyWith(
          body2: timerTheme.textTheme.body2.copyWith(
        color: Colors.blue,
        fontSize: 40.0,
      )),
    );

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            S.of(context).resendOtp,
            style: Theme.of(context).textTheme.body2,
          ),
          SizedBox(width: 5, height: 5),
          Container(
            width: 1,
            height: 15,
            color: Colors.grey[700],
          ),
          SizedBox(width: 5, height: 5),
          Text(
            S.of(context).timer,
            style: TextStyle(
              color: appColor,
            ),
          ),
        ],
      ),
    );
  }

  RichText buildInfoMessageView(BuildContext context) => RichText(
        text: TextSpan(
          text: S.of(context).weHaveSentAnOtpOn,
          style: Theme.of(context).textTheme.body2,
          children: <TextSpan>[
            TextSpan(
              text: " ",
              style: Theme.of(context).textTheme.body1,
            ),
            TextSpan(
              text: "$email",
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      );

  callApiForVerifyCodeAndSkip(String type, AuthViewModel model) {
    model.initAuthApiRequest(
      dynamicAuthMap: {
        codeKey: otpController.text,
        userTypeKey: userType,
        emailKey: email,
        typeKey: type
      },
      urlType: post,//put,
      url: verifyEmailWithCode,
      parentContext: context,
    ).then((value) => {
          if (value != null) {navigateToHome(context: context, menuType: 3)}
          // set selected index in home screen as three
        });
  }
}
