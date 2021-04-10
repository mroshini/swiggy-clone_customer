import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/arguments_model/edit_profile_arguments.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_widget.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/theme_changer.dart';
import 'package:foodstar/src/core/provider_viewmodels/profile_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/show_snack_bar.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:foodstar/src/utils/restaurant_info_list_shimmer.dart';
import 'package:provider/provider.dart';
//import 'package:url_launcher/url_launcher.dart';

class MyAccountScreen extends StatefulWidget {
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  var profileModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(
          S.of(context).myProfile,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
      body: BaseWidget<ProfileViewModel>(
        model: ProfileViewModel(context: context),
        onModelReady: (model) => model.getUserProfileDetails(context),
        builder: (BuildContext context, ProfileViewModel model, Widget child) {
          return LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return Stack(
              children: [
                Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight,
                          ),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: <
                                  Widget>[
                            verticalSizedBox(),
                            model.state == BaseViewState.BeforeLogin
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, login);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          CircleAvatar(
                                            backgroundColor: appColor,
                                            child: Icon(
                                              Icons.person_outline,
                                              color: Colors.black,
                                            ),
                                          ),
                                          horizontalSizedBoxTwenty(),
                                          Text(
                                            'Login/Register',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subhead,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : model.state == BaseViewState.Busy
                                    ? showShimmer(context)
                                    : InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            editProfile,
                                            arguments: EditProfileArguments(
                                                name: model.name,
                                                phoneNumber: model.number,
                                                email: model.emailAddress,
                                                phoneCode: "${model.phoneCode}",
                                                image: model.sampleImageSource,
                                                socialType: model.socialType),
                                          );
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Flexible(
                                                  flex: 2,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      CircleAvatar(
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: model
                                                              .sampleImageSource,
                                                          placeholder:
                                                              (context, url) =>
                                                                  Icon(
                                                            Icons
                                                                .person_outline,
                                                            color: Colors.black,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(
                                                                  Icons
                                                                      .person_outline,
                                                                  color: Colors
                                                                      .black),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      horizontalSizedBoxTwenty(),
                                                      Flexible(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              model.name,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline,
                                                            ),
                                                            verticalSizedBox(),
                                                            Visibility(
                                                              visible: model
                                                                      .number !=
                                                                  "0",
                                                              child: Text(
                                                                model.socialType ==
                                                                        null
                                                                    ? model.phoneCode ==
                                                                            0
                                                                        ? ""
                                                                        : "${model.phoneCode} ${model.number}"
                                                                    : model.phoneCode ==
                                                                            0
                                                                        ? ""
                                                                        : "+${model.phoneCode} ${model.number}",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .display2,
                                                              ),
                                                            ),
                                                            verticalSizedBox(),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  model
                                                                      .emailAddress,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display2,
                                                                ),
                                                                horizontalSizedBox(),
                                                                Flexible(
                                                                  child:
                                                                      Visibility(
                                                                    visible: model.emailVerifiedStatus ==
                                                                            1
                                                                        ? false
                                                                        : true,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        model
                                                                            .verifyEmailRequest(model.emailAddress,
                                                                                context)
                                                                            .then(
                                                                              (value) => {
                                                                                if (value != null)
                                                                                  {
                                                                                    Navigator.pushNamed(
                                                                                      context,
                                                                                      otp,
                                                                                      arguments: {
                                                                                        "message": value.message,
                                                                                        "email": model.emailAddress,
                                                                                        "type": 0
                                                                                      },
                                                                                    ),
                                                                                  },
                                                                              },
                                                                            );
                                                                      },
                                                                      child: model.state ==
                                                                              BaseViewState.Busy
                                                                          ? CircularProgressIndicator
                                                                          : Text(
                                                                              model.emailAddress.isEmpty ? "" : "Verify email",
                                                                              style: Theme.of(context).textTheme.display1.copyWith(
                                                                                    color: darkRed,
                                                                                  ),
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.edit,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                            verticalSizedBox(),
                            Consumer<ThemeManager>(
                                builder: (context, appTheme, child) {
                              return SwitchListTile(
                                title: Text(
                                  S.of(context).darkMode,
                                  style: Theme.of(context).textTheme.display1,
                                ),
                                onChanged: (val) {
                                  appTheme.changeTheme();
                                },
                                value: appTheme.darkMode,
                              );
                            }),
                            ListView.builder(
                                itemCount: model.myAccountData.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, parentIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          model
                                              .myAccountData[parentIndex].title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1,
                                        ),
                                        verticalSizedBoxTwenty(),
                                        ListView.builder(
                                          itemCount: model
                                              .myAccountData[parentIndex]
                                              .bodyModel
                                              .length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Material(
                                              color: transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  moveToRespectivePage(model
                                                      .myAccountData[
                                                          parentIndex]
                                                      .bodyModel[index]
                                                      .bodyTitle);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        //                   <--- left side
                                                        color: Colors.grey[100],
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            horizontalSizedBox(),
                                                            Icon(
                                                              model
                                                                  .myAccountData[
                                                                      parentIndex]
                                                                  .bodyModel[
                                                                      index]
                                                                  .accountIcon,
                                                              size: 25.0,
                                                            ),
                                                            horizontalSizedBox(),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Text(
                                                                model
                                                                    .myAccountData[
                                                                        parentIndex]
                                                                    .bodyModel[
                                                                        index]
                                                                    .bodyTitle,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .display1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color:
                                                                  Colors.grey,
                                                              size: 15.0,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        verticalSizedBox(),
                                      ],
                                    ),
                                  );
                                }),
                            verticalSizedBox(),
                            Visibility(
                              visible: model.accessToken.isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: OutlineButton(
                                    splashColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                    ),
                                    highlightElevation: 0,
                                    borderSide: BorderSide(color: Colors.grey),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 12,
                                        right: 10,
                                        bottom: 12,
                                      ),
                                      child: Text(
                                        S.of(context).logout,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .copyWith(
                                              color: Colors.grey,
                                            ),
                                      ),
                                    ),
                                    onPressed: () {
                                      showLogoutDialog(context: context)
                                          .then((value) async => {
                                                if (value)
                                                  {
                                                    await model
                                                        .logoutApiRequest(
                                                            buildContext:
                                                                context),
                                                    showSnackbar(
                                                        message:
                                                            'Logout Successfully',
                                                        context: context),
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context, mainHome),
                                                  }
                                              });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: model.isLogoutButtonClicked,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      color: Colors.transparent,
                      child: showProgress(context),
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                )
              ],
            );
          });
        },
      ),
    );
  }

  moveToRespectivePage(String title) {
    switch (title) {
      case CommonStrings.favourites:
        return Navigator.of(context).pushNamed(
          favorites,
        );
      case CommonStrings.myOrders:
        return Navigator.of(context).pushNamed(
          myOrdersRoute,
        );
      case CommonStrings.changeLanguage:
        return Navigator.of(context).pushNamed(
          language,
        );
      case CommonStrings.inviteFriends:
        return Navigator.of(context).pushNamed(
          inviteFriendsScreen,
        );
      case CommonStrings.changePassword:
        return Navigator.of(context).pushNamed(
          changePassword,
        );
      case CommonStrings.termsOfService:
//        return Navigator.of(context).pushNamed(
//          termsOfService,
//        );
        return _launchURL();
      case CommonStrings.privacyPolicy:
//        return Navigator.of(context).pushNamed(
//          termsOfService,
//          arguments: (1),
//        );
        return _launchURL();
      case CommonStrings.manageAddress: // manage address from profile
        return Navigator.of(context)
            .pushNamed(manageAddress, arguments: {fromWhichScreen: "3"});
      default:
        return Scaffold(
          body: Container(
            color: white,
          ),
        );
    }
  }

  _launchURL() async {
//    const url = privacyPolicyUrl;
//    if (await canLaunch(url)) {
//      await launch(url, forceWebView: true);
//    } else {
//      throw 'Could not launch $url';
//    }
  }
}
