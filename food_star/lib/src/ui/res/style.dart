import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData appThemeData() {
  return ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    accentColor: Color(0xff9DC40D),
    scaffoldBackgroundColor: Colors.white,
    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline: TextStyle(
        //fontFamily: 'OpenSans',
        fontFamily: 'Montserrat',
        fontSize: 23.0,
        fontWeight: FontWeight.bold,
      ),
      subhead: TextStyle(
        //fontFamily: 'OpenSans',
        fontFamily: 'Montserrat',
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      title: TextStyle(
        //fontFamily: 'OpenSans',
        fontFamily: 'Montserrat',
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),
      subtitle: TextStyle(
        // fontFamily: 'OpenSans',
        fontFamily: 'Montserrat',
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
      body1: TextStyle(
        //fontFamily: 'OpenSans',
        fontFamily: 'Montserrat',
        fontSize: 15.0,
        fontStyle: FontStyle.normal,
        color: Colors.black,
      ),
      body2: TextStyle(
        //fontFamily: 'OpenSans',
        fontFamily: 'Montserrat',
        fontSize: 15.0,
        fontStyle: FontStyle.normal,
        color: Colors.grey,
      ),
      display1: TextStyle(
        fontSize: 15.0,
        fontFamily: 'Montserrat',
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      display2: TextStyle(
        fontSize: 14.0,
        fontFamily: 'Montserrat',
        fontStyle: FontStyle.normal,
        color: Colors.black54,
      ),
      display3: TextStyle(
        fontSize: 14.0,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
  );
}

TextTheme darkTextTheme = TextTheme(
  headline: TextStyle(
      //fontFamily: 'OpenSans',
      fontFamily: 'Montserrat',
      fontSize: 23.0,
      fontWeight: FontWeight.bold,
      color: Colors.white),
  subhead: TextStyle(
    //fontFamily: 'OpenSans',
    fontFamily: 'Montserrat',
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  title: TextStyle(
    //fontFamily: 'OpenSans',
    fontFamily: 'Montserrat',
    fontSize: 18.0,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  ),
  subtitle: TextStyle(
    // fontFamily: 'OpenSans',
    fontFamily: 'Montserrat',
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
  ),
  body1: TextStyle(
    //fontFamily: 'OpenSans',
    fontFamily: 'Montserrat',
    fontSize: 15.0,
    fontStyle: FontStyle.normal,
    color: Colors.white,
  ),
  body2: TextStyle(
    //fontFamily: 'OpenSans',
    fontFamily: 'Montserrat',
    fontSize: 15.0,
    fontStyle: FontStyle.normal,
    color: Colors.grey,
  ),
  display1: TextStyle(
    fontSize: 15.0,
    fontFamily: 'Montserrat',
    color: Colors.white,
    fontWeight: FontWeight.w600,
  ),
  display2: TextStyle(
      fontSize: 14.0,
      fontFamily: 'Montserrat',
      fontStyle: FontStyle.normal,
      color: Colors.white),
  display3: TextStyle(
      fontSize: 14.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w800,
      color: Colors.white),
);

TextTheme textTheme = TextTheme(
  headline: TextStyle(
//fontFamily: 'OpenSans',
    fontFamily: 'Montserrat',
    fontSize: 23.0,
    fontWeight: FontWeight.bold,
  ),
  subhead: TextStyle(
//fontFamily: 'OpenSans',
    fontFamily: 'Montserrat',
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  ),
  title: TextStyle(
//fontFamily: 'OpenSans',
    fontFamily: 'Montserrat',
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  ),
  subtitle: TextStyle(
// fontFamily: 'OpenSans',
    fontFamily: 'Montserrat',
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
  ),
  body1: TextStyle(
//fontFamily: 'OpenSans',
    fontFamily: 'Montserrat',
    fontSize: 15.0,
    fontStyle: FontStyle.normal,
    color: Colors.black,
  ),
  body2: TextStyle(
//fontFamily: 'OpenSans',
    fontFamily: 'Montserrat',
    fontSize: 15.0,
    fontStyle: FontStyle.normal,
    color: Colors.grey,
  ),
  display1: TextStyle(
    fontSize: 15.0,
    fontFamily: 'Montserrat',
    color: Colors.black,
    fontWeight: FontWeight.w600,
  ),
  display2: TextStyle(
    fontSize: 14.0,
    fontFamily: 'Montserrat',
    fontStyle: FontStyle.normal,
    color: Colors.black,
  ),
  display3: TextStyle(
    fontSize: 14.0,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w800,
    color: Colors.black,
  ),
);

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  accentColor: Color(0xff9DC40D),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.black,
  ),
  textTheme: textTheme,
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
  ),
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  accentColor: Color(0xff9DC40D),
  appBarTheme: AppBarTheme(
    color: Colors.black38,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  textTheme: darkTextTheme,
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
  ),
  // scaffoldBackgroundColor: Colors.white,
);
