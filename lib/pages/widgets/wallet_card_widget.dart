import 'package:easy_localization/easy_localization.dart';
import 'package:ewallet/model/wallet_model.dart';
import 'package:ewallet/pages/home_page.dart';
import 'package:flutter/material.dart';

class WalletCard extends StatelessWidget {
  final WalletModel wallet;
  const WalletCard({
    Key? key,
    required this.wallet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => HomePage(
                  wallet: wallet,
                ))));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Wallet Name",
                          style: Theme.of(context).textTheme.subtitle1,
                        ).tr(),
                        Text(
                          wallet.name,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Balance",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ).tr(),
                      Text(
                        "${NumberFormat.currency(locale: "en_US", symbol: "").format(wallet.balance)} ${wallet.currency}",
                        style: wallet.balance < 0
                            ? Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Colors.red)
                            : Theme.of(context).textTheme.labelLarge,
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
