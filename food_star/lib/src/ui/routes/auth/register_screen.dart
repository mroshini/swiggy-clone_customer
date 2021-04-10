import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/provider_viewmodels/auth/auth_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/auth_textField.dart';
import 'package:foodstar/src/ui/shared/buttons/form_submit_button.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:foodstar/src/utils/target_platform.dart';
import 'package:foodstar/src/utils/validation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController mobileNumberTextController;
  TextEditingController nameTextController;
  TextEditingController emailTextController;
  TextEditingController passwordTextController;
  FocusNode numberFocus;
  FocusNode nameFocus;
  FocusNode emailFocus;
  FocusNode passwordFocus;
  String firebaseToken = "";
  String clientId = "";
  String clientSecret = "";
  var _showPassword = false;
  SharedPreferences prefs;
  var deviceId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    mobileNumberTextController = TextEditingController();
    nameTextController = TextEditingController();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    nameFocus = FocusNode();
    emailFocus = FocusNode();
    numberFocus = FocusNode();
    passwordFocus = FocusNode();
    getAuthCoreData();
    super.initState();
  }

  @override
  void dispose() {
    mobileNumberTextController.dispose();
    nameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    numberFocus.dispose();
    emailFocus.dispose();
    nameFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  getAuthCoreData() async {
    await initPref();
    deviceId = await fetchDeviceId();
    firebaseToken = prefs.getString(SharedPreferenceKeys.firebaseToken) ?? "";
    clientId = CLIENTID; //prefs.getString(SharedPreferenceKeys.clientId) ?? "";
    clientSecret =
        CLIENTSECRET; //prefs.getString(SharedPreferenceKeys.clientSecret) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.of(context).register,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  verticalSizedBox(),
                  Text(
                    S
                        .of(context)
                        .pleaseEnterYourPersonalDetailsWorryNotTheyAreSafe,
                    style: Theme.of(context).textTheme.body2,
                  ),
                  verticalSizedBox(),
                  Text(
                    S.of(context).phonenumber,
                    style: Theme.of(context).textTheme.display1,
                  ),
                  verticalSizedBoxFive(),
                  AuthTextField(
                    textField: Row(
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          margin: const EdgeInsets.only(
                            left: 10.0,
                            top: 10.0,
                            bottom: 10.0,
                          ),
                          child: Text(
                            '+91 -',
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: mobileNumberTextController,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            style: Theme.of(context).textTheme.body1,
                            validator: (value) {
                              return mobileNumberValidation(value);
                            },
                            onFieldSubmitted: (term) {
                              numberFocus.unfocus();
                              FocusScope.of(context).requestFocus(nameFocus);
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: S.of(context).phonenumber,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.grey[400],
                                  ),
                              counterText: '',
                            ),
                            onSaved: (value) =>
                                mobileNumberTextController.text = value,
                            focusNode: numberFocus,
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSizedBox(),
                  Text(
                    S.of(context).name,
                    style: Theme.of(context).textTheme.display1,
                  ),
                  verticalSizedBoxFive(),
                  AuthTextField(
                    textField: TextFormField(
                      controller: nameTextController,
                      style: Theme.of(context).textTheme.body1,
                      validator: (value) {
                        return nameValidation(value);
                      },
                      onFieldSubmitted: (term) {
                        nameFocus.unfocus();
                        FocusScope.of(context).requestFocus(emailFocus);
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: S.of(context).name,
                        hintStyle:
                            Theme.of(context).textTheme.bodyText1.copyWith(
                                  color: Colors.grey[400],
                                ),
                        counterText: '',
                      ),
                      onSaved: (value) => nameTextController.text = value,
                      focusNode: nameFocus,
                    ),
                  ),
                  verticalSizedBox(),
                  Text(
                    S.of(context).email,
                    style: Theme.of(context).textTheme.display1,
                  ),
                  verticalSizedBoxFive(),
                  AuthTextField(
                    textField: TextFormField(
                      controller: emailTextController,
                      keyboardType: TextInputType.emailAddress,
                      style: Theme.of(context).textTheme.body1,
                      validator: (value) {
                        return emailValidation(value);
                      },
                      onFieldSubmitted: (term) {
                        emailFocus.unfocus();
                        FocusScope.of(context).requestFocus(passwordFocus);
                      },
                      textInputAction: TextInputAction.next,
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
                  verticalSizedBox(),
                  Text(
                    S.of(context).password,
                    style: Theme.of(context).textTheme.display1,
                  ),
                  verticalSizedBoxFive(),
                  AuthTextField(
                    textField: TextFormField(
                      controller: passwordTextController,
                      textInputAction: TextInputAction.done,
                      style: Theme.of(context).textTheme.body1,
                      validator: (value) {
                        return passwordValidation(value);
                      },
                      obscureText: !_showPassword,
                      onSaved: (value) => passwordTextController.text = value,
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
                  Consumer<AuthViewModel>(builder: (context, model, child) {
                    return Padding(
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
                                  model.initRegisterApiRequest(
                                    dynamicAuthMap: {
                                      userNameKey: nameTextController.text,
                                      phoneNumberKey:
                                          mobileNumberTextController.text,
                                      phoneCodeKey: '91',
                                      emailKey: emailTextController.text,
                                      passwordKey: passwordTextController.text,
                                      groupIdKey: groupId,
                                      deviceKey: fetchTargetPlatform(),
                                      deviceIDKey: deviceId.toString(),
                                      mobileTokenKey: firebaseToken,
                                      clientIdKey: clientId,
                                      clientSecretKey: clientSecret,
                                      grantTypeKey: passwordKey,
                                      userTypeKey: userType,
                                    },
                                    url: registerUrl,
                                    urlType: post,
                                    context: context,
                                  ).then((value) => {
                                        if (value != null)
                                          {
                                            if (value.confirmation == 1)
                                              {
                                                Navigator.pushNamed(
                                                  context,
                                                  otp,
                                                  arguments: {
                                                    "email": emailTextController
                                                        .text,
                                                    "type": 1
                                                  },
                                                ),
                                              }
                                            else
                                              {
                                                model.saveAuthToken(
                                                    value.accessToken,
                                                    value.id),
                                                model.setAuthState(
                                                    AuthState.authenticated),
                                                showInfoAlertDialog(
                                                    context: context,
                                                    response: value.message,
                                                    onClicked: () {
                                                      model.setAuthState(
                                                          AuthState
                                                              .authenticated);
                                                      navigateToHome(
                                                          context: context);
                                                    })
                                              }
                                          }
                                      });
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
    );
  }
}
