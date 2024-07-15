class WalletModel {
  late int id;
  late String name;
  late String currency;
  late double balance;

  WalletModel(this.name, this.currency, this.balance);

  WalletModel.withId(this.id, this.name, this.currency, this.balance);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["currency"] = currency;
    map["balance"] = balance;
    return map;
  }

  WalletModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    currency = map["currency"];
    balance = map["balance"];
  }
}

















// import 'package:hive/hive.dart';
// import 'package:ewallet/model/history_model.dart';

// part 'wallet_model.g.dart';

// @HiveType(typeId: 0)
// class Wallet extends HiveObject {
//   @HiveField(0)
//   String walletName;

//   @HiveField(1)
//   String currency;

//   @HiveField(2)
//   double balance;

//   @HiveField(3)
//   List<History>? histories;

//   Wallet(this.walletName, this.currency, this.balance);
// }







//   // void addTransaction(String moneyInOut, double transactionAmount,
//   //     String description, String payType) {
//   //   String datetime = DateFormat('dd.MM.yy d kk:mm').format(DateTime.now());

//   //   if (moneyInOut == "IN") {
//   //     var availableBalance = Decimal.parse(balance.toString()) -
//   //         Decimal.parse(transactionAmount.toString());
//   //     final history = History(
//   //         balance.toString(),
//   //         moneyInOut,
//   //         transactionAmount.toString(),
//   //         datetime,
//   //         availableBalance.toString(),
//   //         description,
//   //         payType);

//   //     histories!.add(history);
//   //     balance = double.parse(availableBalance.toString());
//   //   } else if (moneyInOut == "OUT") {
//   //     var availableBalance = Decimal.parse(balance.toString()) +
//   //         Decimal.parse(transactionAmount.toString());
//   //     final history = History(
//   //         balance.toString(),
//   //         moneyInOut,
//   //         transactionAmount.toString(),
//   //         datetime,
//   //         availableBalance.toString(),
//   //         description,
//   //         payType);

//   //     histories!.add(history);
//   //     balance = double.parse(availableBalance.toString());
//   //   }
//   // }