import 'package:ewallet/pages/password_page.dart';
import 'package:flutter/material.dart';

class PasswordCharacters extends StatelessWidget {
  final Function onTap;
  final Function checkPass;
  final String number;
  const PasswordCharacters({
    Key? key,
    required this.onTap,
    required this.checkPass,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.width * 0.2,
        child: ElevatedButton(
          onPressed: () {
            PasswordPage.enteredPassword =
                PasswordPage.enteredPassword + number;
            onTap();

            if (PasswordPage.enteredPassword.length > 3) {
              checkPass();
            }
          },
          style: ElevatedButton.styleFrom(
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
          ),
          child: Text(
            number,
            style: Theme.of(context)
                .textTheme
                .headline3
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
