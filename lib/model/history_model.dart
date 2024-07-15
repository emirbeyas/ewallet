class HistoryModel {
  late int id;
  late String balance;
  late String moneyInOut;
  late String transactionAmount;
  late String datetime;
  late String availableBalance;
  late String description;
  late int type;
  late int walletID;

  HistoryModel(
      this.balance,
      this.moneyInOut,
      this.transactionAmount,
      this.datetime,
      this.availableBalance,
      this.description,
      this.type,
      this.walletID);

  HistoryModel.withId(
      this.id,
      this.balance,
      this.moneyInOut,
      this.transactionAmount,
      this.datetime,
      this.availableBalance,
      this.description,
      this.type,
      this.walletID);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["balance"] = balance;
    map["moneyInOut"] = moneyInOut;
    map["transactionAmount"] = transactionAmount;
    map["datetime"] = datetime;
    map["availableBalance"] = availableBalance;
    map["description"] = description;
    map["type"] = type;
    map["walletID"] = walletID;
    return map;
  }

  HistoryModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    balance = map["balance"];
    moneyInOut = map["moneyInOut"];
    transactionAmount = map["transactionAmount"];
    datetime = map["datetime"];
    availableBalance = map["availableBalance"];
    description = map["description"];
    type = map["type"];
    walletID = map["walletID"];
  }
}









// import 'package:hive/hive.dart';

// @HiveType(typeId: 1)
// class History {
//   @HiveField(0)
//   String balance;

//   @HiveField(1)
//   String moneyInOut;

//   @HiveField(2)
//   String transactionAmount;

//   @HiveField(3)
//   String datetime;

//   @HiveField(4)
//   String availableBalance;

//   @HiveField(5)
//   String? description;

//   @HiveField(6)
//   String type;

//   History(this.balance, this.moneyInOut, this.transactionAmount, this.datetime,
//       this.availableBalance, this.description, this.type);
// }
