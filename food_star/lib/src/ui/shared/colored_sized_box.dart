import 'package:flutter/material.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/theme_changer.dart';
import 'package:provider/provider.dart';

class VerticalColoredSizedBox extends StatefulWidget {
  @override
  _VerticalColoredSizedBoxState createState() =>
      _VerticalColoredSizedBoxState();
}

class _VerticalColoredSizedBoxState extends State<VerticalColoredSizedBox> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (BuildContext context, theme, Widget child) {
        return SizedBox(
          height: 10,
          child: Container(
              color: theme.darkMode ? Colors.grey[700] : Colors.grey[300]),
        );
      },
    );
  }
}
