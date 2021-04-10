import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/ui/res/colors.dart';
//import 'package:url_launcher/url_launcher.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    this.style,
    Key key,
    this.trimLines = 2,
  })  : assert(text != null),
        super(key: key);
  final String text;
  final int trimLines;
  final TextStyle style;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;

  void _onTapLink() {
    setState(() => _readMore = !_readMore);

    if (_readMore) {
      _launchURL();
    }
  }

  _launchURL() async {
    const url = privacyPolicyUrl;
//    if (await canLaunch(url)) {
//      await launch(url, forceWebView: true);
//    } else {
//      throw 'Could not launch $url';
//    }
  }

  @override
  Widget build(BuildContext context) {
    TextSpan textlink = TextSpan(
        text: widget.text,
        style: widget.style,
        recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    TextSpan link = TextSpan(
        text: _readMore ? "... See more" : "  See less",
        style: widget.style.apply(color: darkGreen, fontSizeFactor: 0.9),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        final text = TextSpan(text: widget.text, style: widget.style);
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.ltr,
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        TextPainter textPainter1 = TextPainter(
          text: textlink,
          textDirection: TextDirection.ltr,
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        textPainter1.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        List<LineMetrics> lines = textPainter1.computeLineMetrics();
        int numberOfLines = lines.length;
        final linkSize = textPainter.size;
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        return numberOfLines <= widget.trimLines
            ? Container(
                width: double.infinity,
                child: Text(
                  widget.text,
                  style: widget.style,
                  textAlign: TextAlign.left,
                ))
            : RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                text: TextSpan(
                  text: _readMore
                      ? widget.text.substring(0, endIndex)
                      : widget.text,
                  style: widget.style,
                  /*style: TextStyle(
              color: widgetColor,
            ),*/
                  children: <TextSpan>[link],
                ),
              );
      },
    );
    return result;
  }
}
