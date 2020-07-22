import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 25),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.chevronLeft),
            Spacer(),
            Icon(FontAwesomeIcons.commentAlt),
            SizedBox(
              width: 25,
            ),
            Icon(FontAwesomeIcons.headphonesAlt),
            SizedBox(
              width: 25,
            ),
            Icon(FontAwesomeIcons.externalLinkAlt),
          ],
        ),
      ),
    );
  }
}
