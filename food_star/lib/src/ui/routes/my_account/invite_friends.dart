import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';

class InviteFriendsScreen extends StatefulWidget {
  @override
  _InviteFriendsScreenState createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(
          CommonStrings.inviteFriends,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Invite your friends',
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(fontSize: 20),
                          ),
                          verticalSizedBox(),
//                          Text(
//                            'Refer friends to get ahed in the queu (5 friends)',
//                            style: Theme.of(context).textTheme.display1,
//                          ),
                          Center(
                            child: Image.asset(
                              'assets/images/refer.png',
                              width: 200,
                              height: 200,
                            ),
                          ),
                          verticalSizedBox(),
                          Container(
                            decoration: BoxDecoration(
                              color: appColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: FlatButton(
                              color: appColor,
                              child: Text(
                                CommonStrings.inviteFriends,
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                              ),
                              onPressed: () {
                                showShareIntent(
                                    CommonStrings.inviteFriendsShareContent);
                              },
                            ),
                          )
//                          Text(
//                            'Just share this code with your friends and ask them to singup and add this code. Both of you will get ahead of the wait list',
//                            style: Theme.of(context)
//                                .textTheme
//                                .display3
//                                .copyWith(
//                                    color: Colors.grey,
//                                    fontWeight: FontWeight.w600),
//                          ),
//                          verticalSizedBoxTwenty(),
//                          Padding(
//                            padding: const EdgeInsets.all(10.0),
//                            child: Container(
//                              height: 60,
//                              width: MediaQuery.of(context).size.width,
//                              decoration: BoxDecoration(
//                                color: Colors.grey[100],
//                                borderRadius: BorderRadius.circular(
//                                  40.0,
//                                ),
//                              ),
//                              child: Row(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                                  Container(
//                                    width:
//                                        MediaQuery.of(context).size.width / 2,
//                                    decoration: BoxDecoration(
//                                      borderRadius: BorderRadius.only(
//                                        topLeft: Radius.circular(40),
//                                        bottomLeft: Radius.circular(40),
//                                      ),
//                                    ),
//                                    child: Center(
//                                      child: Text(
//                                        'MARATAE2134',
//                                        style: Theme.of(context)
//                                            .textTheme
//                                            .display1
//                                            .copyWith(color: Colors.black),
//                                      ),
//                                    ),
//                                  ),
//                                  Container(
//                                    width:
//                                        MediaQuery.of(context).size.width / 3,
//                                    decoration: BoxDecoration(
//                                      color: Colors.grey[500],
//                                      borderRadius: BorderRadius.only(
//                                        topRight: Radius.circular(40),
//                                        bottomRight: Radius.circular(40),
//                                      ),
//                                    ),
//                                    child: Center(
//                                      child: Text(
//                                        'Share Code',
//                                        style: Theme.of(context)
//                                            .textTheme
//                                            .display1
//                                            .copyWith(
//                                              color: white,
//                                            ),
//                                      ),
//                                    ),
//                                  )
//                                ],
//                              ),
//                            ),
//                          )
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
}
