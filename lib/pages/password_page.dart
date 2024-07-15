import 'package:ewallet/pages/wallets_page.dart';
import 'package:ewallet/pages/widgets/numpad_widget.dart';
import 'package:ewallet/pages/widgets/password_char_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});
  static String enteredPassword = "";
  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  late String password;
  int passCharState = 0;
  bool invalidPass = false;

  Future<void> getPassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    password = preferences.getString("password") ?? "0000";
  }

  @override
  void initState() {
    super.initState();
    getPassword();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fillPassChar() async {
    setState(() {
      passCharState = PasswordPage.enteredPassword.length;
    });
  }

  void checkPassword() {
    if (PasswordPage.enteredPassword == password) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => const WalletSelection())));
    } else {
      setState(() {
        invalidPass = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter password",
                style: Theme.of(context).textTheme.titleLarge),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              onEnd: () {
                if (invalidPass) {
                  setState(() {
                    PasswordPage.enteredPassword = "";
                    invalidPass = false;
                    fillPassChar();
                  });
                }
              },
              opacity: invalidPass ? 1 : 0,
              child: Text("Invalid password", //invalid pass
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Colors.redAccent)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedCrossFade(
                    firstChild: passChar(context),
                    secondChild: passCharWhite(context),
                    crossFadeState: passCharState >= 1
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 110)),
                AnimatedCrossFade(
                    firstChild: passChar(context),
                    secondChild: passCharWhite(context),
                    crossFadeState: passCharState >= 2
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 110)),
                AnimatedCrossFade(
                    firstChild: passChar(context),
                    secondChild: passCharWhite(context),
                    crossFadeState: passCharState >= 3
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 110)),
                AnimatedCrossFade(
                    firstChild: passChar(context),
                    secondChild: passCharWhite(context),
                    crossFadeState: passCharState >= 4
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 110))
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PasswordCharacters(
                    number: "1", onTap: fillPassChar, checkPass: checkPassword),
                PasswordCharacters(
                    number: "2", onTap: fillPassChar, checkPass: checkPassword),
                PasswordCharacters(
                    number: "3", onTap: fillPassChar, checkPass: checkPassword),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PasswordCharacters(
                    number: "4", onTap: fillPassChar, checkPass: checkPassword),
                PasswordCharacters(
                    number: "5", onTap: fillPassChar, checkPass: checkPassword),
                PasswordCharacters(
                    number: "6", onTap: fillPassChar, checkPass: checkPassword),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PasswordCharacters(
                    number: "7", onTap: fillPassChar, checkPass: checkPassword),
                PasswordCharacters(
                    number: "8", onTap: fillPassChar, checkPass: checkPassword),
                PasswordCharacters(
                    number: "9", onTap: fillPassChar, checkPass: checkPassword),
              ],
            ),
            PasswordCharacters(
                number: "0", onTap: fillPassChar, checkPass: checkPassword),
            const SizedBox(
              height: 25,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.63,
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    if (PasswordPage.enteredPassword != "" &&
                        // ignore: prefer_is_empty
                        PasswordPage.enteredPassword.length > 0) {
                      PasswordPage.enteredPassword =
                          PasswordPage.enteredPassword.substring(
                              0, PasswordPage.enteredPassword.length - 1);
                    }
                    fillPassChar();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: const Text(
                    "delete",
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
