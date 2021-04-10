import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/arguments_model/edit_profile_arguments.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_widget.dart';
import 'package:foodstar/src/core/provider_viewmodels/profile_view_model.dart';
import 'package:foodstar/src/ui/shared/auth_textField.dart';
import 'package:foodstar/src/ui/shared/buttons/form_submit_button.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:foodstar/src/utils/validation.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final EditProfileArguments profileInfo;

  EditProfileScreen({this.profileInfo});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState(profileInfo);
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileArguments profileInfo;
  TextEditingController numberTextController;
  TextEditingController emailTextController;
  TextEditingController nameTextController;
  final _formKey = GlobalKey<FormState>();
  dynamic pickedImage;
  FocusNode nameFocus;
  FocusNode emailFocus;
  FocusNode numberFocus;

//  File image = File(
//      '/storage/emulated/0/Android/data/com.abservetech.foodstar/files/Pictures/5acacfef-fbf0-46ef-b265-16f1b2f1f5e1-240733384.jpg');
  dynamic profileImage;
  final picker = ImagePicker();
  var imagePickedFromLocalFile = false;

  _EditProfileScreenState(this.profileInfo);

  @override
  void initState() {
    numberTextController =
        TextEditingController(text: widget.profileInfo.phoneNumber);
    nameTextController = TextEditingController(text: widget.profileInfo.name);
    emailTextController = TextEditingController(text: widget.profileInfo.email);
    nameFocus = FocusNode();
    emailFocus = FocusNode();
    numberFocus = FocusNode();

    profileImage = widget.profileInfo.image;
    super.initState();

//    downloadImageUrl(pickedImage).then((value) => {
//          setState(() {
//            image = File(value.path);
//            showLog(("Profilepic ${image.path}"));
//          }),
//        });
  }

  @override
  void dispose() {
    numberTextController.dispose();
    nameTextController.dispose();
    emailTextController.dispose();
    emailFocus.dispose();
    numberFocus.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
      body: BaseWidget<ProfileViewModel>(
        model: ProfileViewModel(context: context),
        builder: (BuildContext context, ProfileViewModel model, Widget child) {
          return Container(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 25.0, horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.teal[50],
                                      blurRadius: 10,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  child: (profileImage is String)
                                      ? CircleAvatar(
                                          child: networkImage(
                                            image: profileImage,
                                            loaderImage:
                                                CircularProgressIndicator(),
                                          ),
//                                          child: CachedNetworkImage(
//                                            imageUrl: profileImage,
//                                            placeholder: (context, url) =>
//                                                CircularProgressIndicator(),
//                                            errorWidget:
//                                                (context, url, error) =>
//                                                    Icon(Icons.error),
//                                            fit: BoxFit.fill,
//                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: Center(
                                            child: Image.file(
                                              profileImage,
                                            ),
                                          )
//                                        : CachedNetworkImage(
//                                            imageUrl: networkImage,
//                                            placeholder: (context, url) =>
//                                                Padding(
//                                              padding:
//                                                  const EdgeInsets.all(10.0),
//                                              child:
//                                                  CircularProgressIndicator(),
//                                            ),
//                                            errorWidget:
//                                                (context, url, error) =>
//                                                    Icon(Icons.error),
//                                            fit: BoxFit.contain,
//                                          ),
                                          ),
//                                  decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(10.0),
//                                    image: DecorationImage(
//                                      image: image == null && image == ""
//                                          ? Image.asset(
//                                              'assets/images/shop1.jpg',
//                                              fit: BoxFit.fill,
//                                            )
//                                          : FileImage(image),
//                                      fit: BoxFit.contain,
//                                    ),
//                                  ),
                                  // margin: EdgeInsets.only(left: 16.0),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  builder: (context) =>
                                      cameraOrGalleryBottomSheet(),
                                  context: context,
                                  isScrollControlled: false,
                                ).then((value) => {});
                              },
                              child: Icon(
                                Icons.edit,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(S.of(context).name,
                          style: Theme.of(context).textTheme.display1),
                      AuthTextField(
                        textField: TextFormField(
                          controller: nameTextController,
                          style: Theme.of(context).textTheme.body1,
                          validator: (value) {
                            return nameValidation(value);
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (term) {
                            nameFocus.unfocus();
                            FocusScope.of(context).requestFocus(numberFocus);
                          },
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
                      verticalSizedBoxTwenty(),
                      Text(S.of(context).phonenumber,
                          style: Theme.of(context).textTheme.display1),
                      AuthTextField(
                        textField: Row(
                          children: <Widget>[
                            Container(
                              width: 50.0,
                              margin: const EdgeInsets.only(
                                  left: 10.0, top: 10.0, bottom: 10.0),
                              child: Text(
                                "+ ${profileInfo.phoneCode}",
                                style: Theme.of(context).textTheme.body1,
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: numberTextController,
                                keyboardType: TextInputType.number,
                                style: Theme.of(context).textTheme.body1,
                                validator: (value) {
                                  return mobileNumberValidation(value);
                                },
                                textInputAction: profileInfo.socialType == null
                                    ? TextInputAction.done
                                    : TextInputAction.next,
                                onFieldSubmitted: (term) {
                                  numberFocus.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(emailFocus);
                                },
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
                                    numberTextController.text = value,
                                focusNode: numberFocus,
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSizedBoxTwenty(),
                      Visibility(
                        visible: profileInfo.socialType == null,
                        child: Text(S.of(context).email,
                            style: Theme.of(context).textTheme.display1),
                      ),
                      Visibility(
                        visible: profileInfo.socialType == null,
                        child: AuthTextField(
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
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.grey[400],
                                  ),
                              counterText: '',
                            ),
                            onSaved: (value) =>
                                emailTextController.text = value,
                            focusNode: emailFocus,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 10.0,
                        ),
                        child: model.state == BaseViewState.Busy
                            ? showProgress(context)
                            : FormSubmitButton(
                                title: S.of(context).change,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    model.editProfileRequest(
                                      dynamicAuthMap: {
                                        userNameKey: nameTextController.text,
                                        emailKey: emailTextController.text,
                                        phoneCodeKey: "+91",
                                        phoneNumberKey:
                                            numberTextController.text,
                                        userTypeKey: userType,
                                        imageFilePathKey:
                                            (profileImage is String)
                                                ? ""
                                                : pickedImage.path
                                      },
                                      // fileName: image,
                                      buildContext: context,
                                      urlType: multipart,
                                      url: editProfileUrl,
                                    ).then((value) => {
                                          if (value != null)
                                            {
                                              model.storeProfileDataInDb(value),
                                              Navigator.pop(context),
                                              if (value.doEmailVerify == 0)
                                                {
                                                  navigateToHome(
                                                      context: context,
                                                      menuType: 3)
                                                }
                                              else if (value.doEmailVerify == 1)
                                                {
                                                  Navigator.pushNamed(
                                                    context,
                                                    otp,
                                                    arguments: {
                                                      "email": value.user.email,
                                                      "type": 0
                                                    },
                                                  )
                                                }
                                            }
                                        });
                                  }
                                  //  Navigator.of(context).pop();
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container cameraOrGalleryBottomSheet() => Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              verticalSizedBox(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Select Image From',
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  closeIconButton(
                      context: context,
                      onClicked: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
              verticalSizedBoxTwenty(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  cameraOrGallery(
                      iconData: Icons.camera_alt, title: 'Camera', type: 1),
                  divider(),
                  cameraOrGallery(
                      iconData: Icons.image, title: 'Gallery', type: 2),
                  verticalSizedBox(),
                ],
              ),
            ],
          ),
        ),
      );

  InkWell cameraOrGallery({
    IconData iconData,
    String title,
    int type,
  }) =>
      InkWell(
        onTap: () {
          Navigator.of(context).pop();
          getImageFromCameraOrGallery(type);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.display1,
              ),
              Icon(
                iconData,
              ),
            ],
          ),
        ),
      );

  Future<void> getImageFromCameraOrGallery(int type) async {
    var pickedImageFromLocal;
    if (type == 1) {
      pickedImageFromLocal = await picker.getImage(source: ImageSource.camera);
    } else {
      pickedImageFromLocal = await picker.getImage(source: ImageSource.gallery);
    }
    setState(() {
      pickedImage = pickedImageFromLocal;
      // imagePickedFromLocalFile = true;
      profileImage = File(pickedImageFromLocal.path);
      imagePickedFromLocalFile = true;

      showLog("ImagePicker ${profileImage}");
    });
  }

  void _closeModal(void value) {}
}
