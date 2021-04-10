import 'package:flutter/material.dart';
import 'package:foodstar/src/core/models/sample_models/order_track_model.dart';

class StepProgressView extends StatelessWidget {
  final double _width;
  final List<IconData> _icons;
  final List<OrderTrackModel> _titles;
  final int _curStep;
  final Color _activeColor;
  final Color _inactiveColor = Colors.grey;
  final double lineWidth = 4.0;

  StepProgressView(
      {Key key,
      @required List<IconData> icons,
      @required int curStep,
      List<OrderTrackModel> titles,
      @required double width,
      @required Color color})
      : _icons = icons,
        _titles = titles,
        _curStep = curStep,
        _width = width,
        _activeColor = color,
        assert(curStep > 0 == true && curStep <= icons.length),
        assert(width > 0),
        super(key: key);

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 32.0,
        left: 24.0,
        right: 24.0,
      ),
      width: this._width,
      child: Column(
        children: <Widget>[
          Row(
            children: _iconViews(context),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _titleViews(),
          ),
        ],
      ),
    );
  }

  List<Widget> _iconViews(BuildContext context) {
    var list = <Widget>[];
    _icons.asMap().forEach((i, icon) {
      //colors according to state
      var circleColor = (i == 0 || _curStep > i + 1)
          ? Theme.of(context).primaryColor
          : _inactiveColor;

      var lineColor = _curStep > i + 1
          ? Theme.of(context).primaryColor
          : Theme.of(context).primaryColorDark;

      var iconColor = (i == 0 || _curStep > i + 1)
          ? Theme.of(context).accentColor
          : Theme.of(context).primaryColor;

      list.add(
        //dot with icon view
        Container(
          width: 40.0,
          height: 40.0,
          padding: EdgeInsets.all(0),
          child: Icon(
            icon,
            color: iconColor,
            size: 15.0,
          ),
          decoration: new BoxDecoration(
            color: circleColor,
            borderRadius: new BorderRadius.all(new Radius.circular(25.0)),
            border: new Border.all(
              color: _activeColor,
              width: 2.0,
            ),
          ),
        ),
      );

      //line between icons
      if (i != _icons.length - 1) {
        list.add(Expanded(
            child: Container(
          height: lineWidth,
          color: lineColor,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, text) {
      list.add(
        Text(
          text.title,
          style: TextStyle(color: _activeColor, fontSize: 16),
        ),
      );
    });
    return list;
  }
}
