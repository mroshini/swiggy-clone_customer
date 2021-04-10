import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/provider_viewmodels/auth/auth_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/utils/dots_indicator.dart';
import 'package:provider/provider.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final _controller = new PageController();

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  final _kArrowColor = Colors.black.withOpacity(0.8);

  final List<Widget> _pages = <Widget>[
    onBoardScreenImage('assets/images/login.png'),
    onBoardScreenImage('assets/images/browse_food_menus.png'),
    onBoardScreenImage('assets/images/order_confirmed.png'),
    onBoardScreenImage('assets/images/delivery.png')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            physics: new AlwaysScrollableScrollPhysics(),
            controller: _controller,
            itemCount: _pages.length,
            itemBuilder: (BuildContext context, int index) {
              return _pages[index % _pages.length];
            },
          ),
          new Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: new Container(
              color: Colors.grey[200].withOpacity(0.5),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Center(
                    child: new DotsIndicator(
                      controller: _controller,
                      itemCount: _pages.length,
                      color: appColor,
                      onPageSelected: (int page) {
                        _controller.animateToPage(
                          page,
                          duration: _kDuration,
                          curve: _kCurve,
                        );
                      },
                    ),
                  ),
                  Consumer<AuthViewModel>(builder: (context, model, child) {
                    return GestureDetector(
                      onTap: () {
                        model.saveOnBoardWatched();
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, login);
                      },
                      child: Text(
                        "Skip",
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static onBoardScreenImage(String image) => ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Image.asset(image),
      );
}
