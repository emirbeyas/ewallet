import 'package:easy_localization/easy_localization.dart';
import 'package:ewallet/constant/constants.dart';
import 'package:ewallet/model/out_type_model.dart';
import 'package:ewallet/model/user_database_provider.dart';
import 'package:ewallet/provider/theme_manager.dart';
import 'package:ewallet/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> settingsMenu(BuildContext context) async {
  var preferences = await SharedPreferences.getInstance();
  bool darkThemeSwitch = preferences.getBool("theme") ?? true;
  // bool passwordSwitch = preferences.getBool("passwordstate") ?? false;
  String language = preferences.getString("language") ?? "TURKISH";

  TextEditingController outMoneyTypeTextController = TextEditingController();

  List<OutType> outTypeList = await UserDatabaseProvider.getOutTypes();

  bool isTypeDisable = outTypeList.length >= 12 ? true : false;

  int selectedLanguageIndex = 0;
  // ignore: use_build_context_synchronously
  final themeManager = Provider.of<ThemeManager>(context, listen: false);
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Preferences",
                        style: Theme.of(context).textTheme.headline5,
                      ).tr(),
                      const SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: const SizedBox(
                          height: double.infinity,
                          child: Icon(
                            Icons.dark_mode_outlined,
                            size: 30,
                          ),
                        ),
                        title: Text("Dark mode",
                                style: Theme.of(context).textTheme.bodyLarge)
                            .tr(),
                        trailing: Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            trackColor: Colors.red, // **INACTIVE STATE COLOR**
                            activeColor: Colors.green, // **ACTIVE STATE COLOR**
                            value: darkThemeSwitch,
                            onChanged: (isOn) async {
                              (isOn)
                                  ? themeManager.setTheme(MyThemes.darkTheme)
                                  : themeManager.setTheme(MyThemes.lightTheme);
                              setState(() {
                                darkThemeSwitch = isOn;
                              });
                              var preferences =
                                  await SharedPreferences.getInstance();
                              preferences.setBool("theme", isOn);
                            },
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      ListTile(
                          onTap: () {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Select language",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            ).tr(),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            SizedBox(
                                              height: 150,
                                              child: CupertinoPicker(
                                                itemExtent: 50,
                                                children: [
                                                  for (var language
                                                      in Language.values)
                                                    Center(
                                                      child: Text(
                                                        language.name,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                ],
                                                onSelectedItemChanged: (value) {
                                                  selectedLanguageIndex = value;
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    var preferences =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    preferences.setString(
                                                        "language",
                                                        Language
                                                            .values[
                                                                selectedLanguageIndex]
                                                            .name
                                                            .toString());
                                                    setState(() {
                                                      language = Language
                                                          .values[
                                                              selectedLanguageIndex]
                                                          .name;
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  },
                                                  style: ButtonStyle(
                                                      foregroundColor:
                                                          MaterialStateProperty.all<Color>(
                                                              Colors.white),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          15)),
                                                              side: BorderSide(
                                                                  width: 2,
                                                                  color: Colors.grey)))),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 50,
                                                    child:
                                                        const Text("Save").tr(),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          minLeadingWidth: 10,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: const SizedBox(
                            height: double.infinity,
                            child: Icon(
                              Icons.language_rounded,
                              size: 30,
                            ),
                          ),
                          title: Text("Language",
                                  style: Theme.of(context).textTheme.bodyLarge)
                              .tr(),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                language,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    ?.copyWith(color: Colors.white54),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                              ),
                            ],
                          )),
                      const Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => StatefulBuilder(
                                  builder: (context, setState) => AlertDialog(
                                        title:
                                            const Text("Out Money Types").tr(),
                                        content: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.45,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 0.0,
                                                          vertical: 0.0),
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal: 0,
                                                          vertical: -4),
                                                  title: Text("Other",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge)
                                                      .tr(),
                                                  trailing: const IconButton(
                                                    color: Colors.red,
                                                    icon: Icon(Icons
                                                        .remove_circle_outline_rounded),
                                                    onPressed: null,
                                                  ),
                                                ),
                                                for (int i = 1;
                                                    i < outTypeList.length;
                                                    i++)
                                                  ListTile(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 0.0,
                                                            vertical: 0.0),
                                                    visualDensity:
                                                        const VisualDensity(
                                                            horizontal: 0,
                                                            vertical: -4),
                                                    title: Text(
                                                        outTypeList[i]
                                                            .description,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge),
                                                    trailing: IconButton(
                                                      color: Colors.red,
                                                      icon: const Icon(Icons
                                                          .remove_circle_outline_rounded),
                                                      onPressed: () async {
                                                        await UserDatabaseProvider
                                                            .deleteOutTypes(
                                                                outTypeList[i]
                                                                    .id);
                                                        outTypeList =
                                                            await UserDatabaseProvider
                                                                .getOutTypes();
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ListTile(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 0.0,
                                                            vertical: 0.0),
                                                    visualDensity:
                                                        const VisualDensity(
                                                            horizontal: 0,
                                                            vertical: -4),
                                                    title: SizedBox(
                                                      height: 34,
                                                      child: TextField(
                                                        controller:
                                                            outMoneyTypeTextController,
                                                        decoration:
                                                            InputDecoration(
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 1.5,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary),
                                                          ),
                                                        ),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge,
                                                      ),
                                                    ),
                                                    trailing: IconButton(
                                                        onPressed: isTypeDisable
                                                            ? null
                                                            : () async {
                                                                if (outMoneyTypeTextController
                                                                        .text
                                                                        .length >=
                                                                    3) {
                                                                  OutType
                                                                      outType =
                                                                      OutType(outMoneyTypeTextController
                                                                          .text);
                                                                  await UserDatabaseProvider
                                                                      .addOutTypes(
                                                                          outType);
                                                                  outTypeList =
                                                                      await UserDatabaseProvider
                                                                          .getOutTypes();
                                                                  outMoneyTypeTextController
                                                                      .clear();
                                                                  isTypeDisable =
                                                                      outTypeList.length >=
                                                                              12
                                                                          ? true
                                                                          : false;
                                                                  setState(
                                                                      () {});
                                                                } else {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                          contentPadding: const EdgeInsets.only(
                                                                              top: 30,
                                                                              left: 12,
                                                                              right: 12),
                                                                          content: Text(
                                                                            "out money type cannot be less than 3 characters.",
                                                                            style:
                                                                                Theme.of(context).textTheme.bodyLarge,
                                                                          ).tr(),
                                                                          actions: [
                                                                            TextButton(
                                                                                onPressed: () => Navigator.of(context).pop(),
                                                                                child: Text(
                                                                                  "Ok",
                                                                                  style: Theme.of(context).textTheme.bodyLarge,
                                                                                ).tr())
                                                                          ]);
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                        icon: const Icon(Icons
                                                            .add_circle_outline_rounded))),
                                              ]),
                                        ),
                                      )));
                        },
                        minLeadingWidth: 10,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: const SizedBox(
                          height: double.infinity,
                          child: Icon(
                            Icons.add_circle_outline_rounded,
                            size: 30,
                          ),
                        ),
                        title: Text("Out Money Type",
                                style: Theme.of(context).textTheme.bodyLarge)
                            .tr(),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ));
}
