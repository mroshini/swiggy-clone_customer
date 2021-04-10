import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/api_models/login_response_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/auth/auth_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/auth_textField.dart';
import 'package:foodstar/src/ui/shared/buttons/form_submit_button.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:foodstar/src/utils/validation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: LoginContainerView(title: S.of(context).login),
        ),
      ),
    );
  }
}

class LoginContainerView extends StatefulWidget {
  final String title;

  LoginContainerView({this.title});

  @override
  _LoginContainerViewState createState() => _LoginContainerViewState();
}

class _LoginContainerViewState extends State<LoginContainerView> {
  TextEditingController loginEmailTextController;
  TextEditingController passwordTextController;
  var _showPassword = false;
  SharedPreferences prefs;
  FocusNode emailFocus;
  FocusNode passwordFocus;

  bool isUserExists = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loginEmailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    passwordFocus = FocusNode();
    emailFocus = FocusNode();
    super.initState();
    Provider.of<AuthViewModel>(context, listen: false).getAuthCoreData();
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

//  getAuthCoreData() async {
//    await initPref();
//    clientId = CLIENTID; //prefs.getString(SharedPreferenceKeys.clientId) ?? "";
//    clientSecret =
//        CLIENTSECRET; //prefs.getString(SharedPreferenceKeys.clientSecret) ?? "";
//    firebaseToken = prefs.getString(SharedPreferenceKeys.firebaseToken) ?? "";
//    deviceId = await fetchDeviceId();
//  }

  @override
  void dispose() {
    loginEmailTextController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/foodstar_logo.png',
                    width: 250,
                    height: 60,
                  ),
                ),
                verticalSizedBoxTwenty(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headline,
                    ),
                    Consumer<AuthViewModel>(
                      builder: (BuildContext context, AuthViewModel model,
                          Widget child) {
                        return InkWell(
                          onTap: () {
                            model.setAuthState(AuthState.authSkiped);
                            navigateToHome(context: context);
                          },
                          child: Text(
                            'Skip',
                            style: Theme.of(context)
                                .textTheme
                                .display2
                                .copyWith(decoration: TextDecoration.underline),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                verticalSizedBoxTwenty(),
                Text(
                  'Email',
                  style: Theme.of(context).textTheme.display1,
                ),
                AuthTextField(
                  textField: TextFormField(
                    controller: loginEmailTextController,
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
                      hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.grey[400],
                          ),
                      counterText: '',
                    ),
                    onSaved: (value) => loginEmailTextController.text = value,
                    focusNode: emailFocus,
                  ),
                ),
                verticalSizedBox(),
                Text(
                  S.of(context).password,
                  style: Theme.of(context).textTheme.display1,
                ),
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
                      hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.grey[400],
                          ),
                      counterText: '',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Text(
                      "${S.of(context).forgotPassword} ?",
                      /**/
                      style: TextStyle(color: appColor),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, forgetPassword);
                    },
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
                            onPressed: () async {
                              await model.getAuthCoreData();
                              if (_formKey.currentState.validate()) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _formKey.currentState.save();
                                showLog("initloginReq");
                                model.initLoginRequest(
                                  dynamicAuthMap: {
                                    emailKey: loginEmailTextController.text,
                                    passwordKey: passwordTextController.text,
                                    userTypeKey: userType,
                                    grantTypeKey: passwordKey,
                                    deviceIDKey: model.deviceId,
                                    //mobileTokenKey: "sdfjdshfkjdf",
                                    mobileTokenKey: model.firebaseToken,
                                    clientIdKey: model.clientId,
                                    clientSecretKey: model.clientSecret,
                                  },
                                  url: loginUrl,
                                  urlType: post,
                                  context: context,
                                ).then((value) => {
                                      if (value != null)
                                        {
                                          saveAuthValues(model, value, context),
                                        }
                                    });
                              } else {}
                            },
                          ),
                  );
                }),
                LoginFooterView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

saveAuthValues(
    AuthViewModel model, LoginResponseModel value, BuildContext context) {
  model.saveAuthToken(value.accessToken, value.id);
  model.setAuthState(AuthState.authenticated);
  navigateToHome(context: context);
}

class LoginFooterView extends StatefulWidget {
  const LoginFooterView({Key key}) : super(key: key);

  @override
  _LoginFooterViewState createState() => _LoginFooterViewState();
}

class _LoginFooterViewState extends State<LoginFooterView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 1.0,
                  color: Colors.grey[400],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(S.of(context).orLoginWith),
              ),
              Expanded(
                child: Container(
                  height: 1.0,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Consumer<AuthViewModel>(builder: (context, model, child) {
                return signInButton(model, context);
              })),
          verticalSizedBox(),
          Material(
            color: transparent,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  register,
                );
              },
              child: Text(
                "Don't have an account? SignUp",
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ),
          verticalSizedBoxTwenty(),
        ],
      ),
    );
  }

  Widget signInButton(AuthViewModel model, BuildContext context) => model
          .googleSignInClicked
      ? showProgress(context)
      : OutlineButton(
          splashColor: Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          highlightElevation: 0,
          borderSide: BorderSide(color: Colors.grey),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0, top: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/google_logo.png',
                  height: 20.0,
                  width: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: Text(
                    'Sign In with Google',
                    style: Theme.of(context).textTheme.body2,
                  ),
                )
              ],
            ),
          ),
          onPressed: () {
            print('Sign in with google button tapped');
            model.signInWithGoogle(context).then((value) => {
                  saveAuthValues(model, value, context),
                });
          },
        );

  String valueIsEmpty(String value) {
    return value.isEmpty ? 'Please fill this field' : "";
  }

//Future<void> _signOutGoogleUser() => _googleSignIn.disconnect();

}

//        child: SingleChildScrollView(
//          child: Container(
//            margin:
//                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
//            child: Form(
//              key: _formKey,
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Center(
//                    child: Image.asset(
//                      HomeModelData().imagePath[0],
//                      width: 250,
//                      height: 250,
//                    ),
//                  ),
//                  verticalSizedBoxTwenty(),
//                  Text(
//                    widget.title,
//                    style: Theme.of(context).textTheme.headline,
//                  ),
//                  verticalSizedBoxTwenty(),
//                  Text(
//                    'Email',
//                    style: Theme.of(context).textTheme.display1,
//                  ),
//                  AuthTextField(
//                    textField: TextFormField(
//                      controller: loginEmailTextController,
//                      keyboardType: TextInputType.emailAddress,
//                      style: Theme.of(context).textTheme.body1,
//                      validator: (value) {
//                        return emailValidation(value);
//                      },
//                      onFieldSubmitted: (term) {
//                        emailFocus.unfocus();
//                        FocusScope.of(context).requestFocus(passwordFocus);
//                      },
//                      textInputAction: TextInputAction.next,
//                      decoration: InputDecoration(
//                        border: InputBorder.none,
//                        hintText: S.of(context).email,
//                        hintStyle:
//                            Theme.of(context).textTheme.bodyText1.copyWith(
//                                  color: Colors.grey[400],
//                                ),
//                        counterText: '',
//                      ),
//                      onSaved: (value) => loginEmailTextController.text = value,
//                      focusNode: emailFocus,
//                    ),
//                  ),
//                  verticalSizedBox(),
//                  Text(
//                    S.of(context).password,
//                    style: Theme.of(context).textTheme.display1,
//                  ),
//                  AuthTextField(
//                    textField: TextFormField(
//                      controller: passwordTextController,
//                      textInputAction: TextInputAction.done,
//                      style: Theme.of(context).textTheme.body1,
//                      validator: (value) {
//                        return passwordValidation(value);
//                      },
//                      obscureText: !_showPassword,
//                      onSaved: (value) => passwordTextController.text = value,
//                      decoration: InputDecoration(
//                        suffixIcon: GestureDetector(
//                          onTap: () {
//                            setState(() {
//                              _showPassword = !_showPassword;
//                            });
//                          },
//                          child: Icon(
//                            _showPassword
//                                ? Icons.visibility
//                                : Icons.visibility_off,
//                            color: appColor,
//                          ),
//                        ),
//                        border: InputBorder.none,
//                        hintText: S.of(context).password,
//                        hintStyle:
//                            Theme.of(context).textTheme.bodyText1.copyWith(
//                                  color: Colors.grey[400],
//                                ),
//                        counterText: '',
//                      ),
//                    ),
//                  ),
//                  Align(
//                    alignment: Alignment.centerRight,
//                    child: FlatButton(
//                      child: Text(
//                        "${S.of(context).forgotPassword} ?",
//                        /**/
//                        style: TextStyle(color: appColor),
//                      ),
//                      onPressed: () {
//                        Navigator.pushNamed(context, forgetPassword);
//                      },
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.symmetric(
//                        vertical: 20.0, horizontal: 10.0),
//                    child: model.state == ViewState.Busy
//                        ? showProgress(context)
//                        : FormSubmitButton(
//                            title: S.of(context).continue_button_text,
//                            onPressed: () {
//                              getAuthCoreData();
//                              if (_formKey.currentState.validate()) {
//                                _formKey.currentState.save();
//                                showLog("initloginReq");
//                                model.initLoginRequest(
//                                  dynamicAuthMap: {
//                                    emailKey: loginEmailTextController.text,
//                                    passwordKey: passwordTextController.text,
//                                    userTypeKey: userType,
//                                    grantTypeKey: passwordKey,
//                                    deviceIDKey: deviceId,
//                                    mobileTokenKey: firebaseToken,
//                                    clientIdKey: clientId,
//                                    clientSecretKey: clientSecret,
//                                  },
//                                  url: loginUrl,
//                                  urlType: post,
//                                ).then((value) => {
//                                      if (value != null)
//                                        {
//                                          model
//                                              .saveAuthToken(value.accessToken),
//                                          model.setAuthState(),
//                                          navigateToHome(context),
//                                        }
//                                    });
//                              } else {}
////                                  } else {
////                                    showLog("initloginReq");
////                                    ApiRepository(mContext: context)
////                                        .fetchAppEssentialCorerData();
////                                  }
//                            },
//                          ),
//                  ),
//                  LoginFooterView(),
//                ],
//              ),
//            ),
//          ),
//        ),
