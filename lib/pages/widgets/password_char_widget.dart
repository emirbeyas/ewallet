import 'package:flutter/material.dart';

Widget passChar(BuildContext context) {
  return Container(
    margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
    height: MediaQuery.of(context).size.width * 0.05,
    width: MediaQuery.of(context).size.width * 0.05,
    decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
            color: Theme.of(context).colorScheme.primary, width: 1.3)),
  );
}

Widget passCharWhite(BuildContext context) {
  return Container(
    margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
    height: MediaQuery.of(context).size.width * 0.05,
    width: MediaQuery.of(context).size.width * 0.05,
    decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
            color: Theme.of(context).colorScheme.primary, width: 1.3)),
  );
}
