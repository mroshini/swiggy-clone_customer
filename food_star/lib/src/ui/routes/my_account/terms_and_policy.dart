import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/expandable_text.dart';
//import 'package:url_launcher/url_launcher.dart';

class TermsOfServiceScreen extends StatefulWidget {
  final screenName;

  TermsOfServiceScreen({this.screenName = 0});

  @override
  _TermsOfServiceScreenState createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(
          widget.screenName == 0
              ? CommonStrings.termsOfService
              : CommonStrings.privacyPolicy,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Terms of Use',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          verticalSizedBox(),
                          ExpandableText(
                            'These terms of use (the "Terms of Use") govern your use of our website ${webUrl} (the "Website") and our ${CommonStrings.appName} application for your mobile and handheld device (the "App"). The Website and the App are jointly reffered to as the ("Services"). Please read these Terms of Use carefully before you download, install or use the Services. If you do not agree to these Terms of Use, you may not install, download or use the Services. By installing, downloading or using the Services, you signify your acceptance to the Terms of Use and Privacy Policy (being hereby incorporated by reference herein) which takes effect on the date on which you download, install or use the Services, and create a legally binding arrangements to abide by the same',
                            style: Theme.of(context).textTheme.display2,
                            trimLines: 10,
                          ),
//                          Text(
//                              'These terms of use (the "Terms of Use") govern your use of our website ${webUrl} (the "Website") and our ${CommonStrings.appName} application for your mobile and handheld device (the "App"). The Website and the App are jointly reffered to as the ("Services"). Please read these Terms of Use carefully before you download, install or use the Services. If you do not agree to these Terms of Use, you may not install, download or use the Services. By installing, downloading or using the Services, you signify your acceptance to the Terms of Use and Privacy Policy (being hereby incorporated by reference herein) which takes effect on the date on which you download, install or use the Services, and create a legally binding arrangements to abide by the same',
//                              style: Theme.of(context).textTheme.display2),
//                          verticalSizedBox(),
//                          Material(
//                            color: Colors.transparent,
//                            child: InkWell(
//                              onTap: () {
//                                _launchURL();
//                              },
//                              child: Container(
//                                child: Text(
//                                  'Read More',
//                                  style: Theme.of(context)
//                                      .textTheme
//                                      .display2
//                                      .copyWith(
//                                        color: blue,
//                                        fontSize: 16,
//                                        decoration: TextDecoration.underline,
//                                        decorationColor: blue,
//                                      ),
//                                ),
//                              ),
//                            ),
//                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
        );
      }),
    );
  }

  _launchURL() async {
    const url = webUrl;
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
  }
}
