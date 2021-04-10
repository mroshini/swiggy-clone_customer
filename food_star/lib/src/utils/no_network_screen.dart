import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/common_strings.dart';

class NoNetworkConnectionScreen extends StatefulWidget {
  @override
  _NoNetworkConnectionScreenState createState() =>
      _NoNetworkConnectionScreenState();
}

class _NoNetworkConnectionScreenState extends State<NoNetworkConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        CommonStrings.appName,
        style: Theme.of(context).textTheme.headline2,
      )),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/no_internet.png',
                height: 120,
                width: 120,
              ),
              Text(
                'No Internet connection',
                style: Theme.of(context).textTheme.subhead,
              )
            ],
          ),
        ),
      ),
    );
  }
}
