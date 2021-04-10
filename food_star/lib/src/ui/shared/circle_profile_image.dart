import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ClipRRect circleProfileImage(
        {BuildContext mContext,
        double heightValue,
        double widthValue,
        String image}) =>
    ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(24)),
      child: Container(
        height: heightValue,
        width: widthValue,
        decoration: BoxDecoration(
          color: Theme.of(mContext).backgroundColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.teal[50],
              blurRadius: 10,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Image.asset(
          image,
          fit: BoxFit.fill,
        ),
      ),
    );
