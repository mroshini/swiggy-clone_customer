import 'package:flutter/material.dart';

class SocialAuthButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const SocialAuthButton({
    Key key,
    @required this.title,
    @required this.onPressed,
  })  : assert(title != ''),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.only(left: 0, top: 12, right: 10, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/google_logo.png',
              height: 20.0,
              width: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(
                'Sign In with Google',
                style: Theme.of(context).textTheme.body2,
              ),
            )
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}
