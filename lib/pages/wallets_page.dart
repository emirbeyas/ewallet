import 'package:ewallet/constant/constants.dart';
import 'package:ewallet/model/user_database_provider.dart';
import 'package:ewallet/model/wallet_model.dart';
import 'package:ewallet/pages/widgets/settings_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ewallet/provider/currency_text_formatter.dart';
import 'widgets/wallet_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class WalletSelection extends StatefulWidget {
  const WalletSelection({super.key});

  @override
  State<WalletSelection> createState() => _WalletSelectionState();
}

class _WalletSelectionState extends State<WalletSelection> {
  final _balanceTextController = TextEditingController();
  final _walletNameTextController = TextEditingController();
  bool isLoading = false;
  String _selectedCurrency = "TRY";
  int _settingsState = 0;
  late bool darkThemeSwitch;
  late bool passwordSwitch;
  List<WalletModel> walletList = [];
  late String language;

  @override
  void initState() {
    super.initState();
    fillWalletList();
  }

  Future<void> fillWalletList() async {
    setState(() => isLoading = true);
    walletList = await UserDatabaseProvider.getWalletList();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Wallet").tr(),
          actions: [
            IconButton(
              highlightColor: Colors.transparent,
              icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => RotationTransition(
                        turns: child.key == const ValueKey('icon1')
                            ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                            : Tween<double>(begin: 0.75, end: 1).animate(anim),
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                  child: _settingsState == 0
                      ? const Icon(Icons.settings, key: ValueKey('icon1'))
                      : const Icon(
                          Icons.settings,
                          key: ValueKey('icon2'),
                        )),
              onPressed: () {
                setState(() {
                  _settingsState = _settingsState == 0 ? 1 : 0;
                });

                settingsMenu(context);
              },
            )
          ],
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: fillWalletList,
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        for (int i = 0; i < walletList.length; i++)
                          WalletCard(wallet: walletList[i]),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              _balanceTextController.text = "";
                              _walletNameTextController.text = "";
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 150,
                                                child: CupertinoPicker(
                                                  itemExtent: 50,
                                                  children: [
                                                    for (var currency
                                                        in Currency.values)
                                                      Center(
                                                        child: Text(
                                                          currency.name,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ).tr(),
                                                      )
                                                  ],
                                                  onSelectedItemChanged:
                                                      (value) {
                                                    _selectedCurrency = Currency
                                                        .values[value].name
                                                        .toString();
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  controller:
                                                      _walletNameTextController,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Wallet Name".tr(),
                                                      focusedBorder: const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 2,
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15))),
                                                      enabledBorder: const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 2,
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15))),
                                                      prefixIcon:
                                                          const Icon(Icons.label_important_rounded)),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  controller:
                                                      _balanceTextController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    CurrencyTextInputFormatter()
                                                  ],
                                                  decoration: InputDecoration(
                                                      hintText: "Balance".tr(),
                                                      focusedBorder: const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 2,
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15))),
                                                      enabledBorder: const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 2,
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15))),
                                                      prefixIcon:
                                                          const Icon(Icons.wallet)),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ButtonStyle(
                                                              foregroundColor:
                                                                  MaterialStateProperty.all<Color>(
                                                                      Colors
                                                                          .white),
                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15)),
                                                                  side: BorderSide(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .grey)))),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 62,
                                                            child: const Text(
                                                                    "Cancel")
                                                                .tr(),
                                                          )),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                          onPressed: () {
                                                            if (_walletNameTextController
                                                                        .text !=
                                                                    "" ||
                                                                _balanceTextController
                                                                        .text !=
                                                                    "") {
                                                              WalletModel walletModel = WalletModel(
                                                                  _walletNameTextController
                                                                      .text,
                                                                  _selectedCurrency,
                                                                  double.parse(_balanceTextController
                                                                      .text
                                                                      .replaceAll(
                                                                          ",",
                                                                          "")));
                                                              UserDatabaseProvider
                                                                  .addWallet(
                                                                      walletModel);
                                                            }
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {
                                                              fillWalletList();
                                                            });
                                                          },
                                                          style: ButtonStyle(
                                                              foregroundColor:
                                                                  MaterialStateProperty.all<Color>(
                                                                      Colors
                                                                          .white),
                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15)),
                                                                  side: BorderSide(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .grey)))),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 62,
                                                            child: const Text(
                                                                    "Add")
                                                                .tr(),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: const Icon(
                                Icons.add_circle_outline_rounded,
                                size: 55,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ));
  }
}
