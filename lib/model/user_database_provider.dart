import 'package:ewallet/model/history_model.dart';
import 'package:ewallet/model/out_type_model.dart';
import 'package:ewallet/model/wallet_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class UserDatabaseProvider {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE TBL_WALLETS(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              currency TEXT,
              balance REAL);
              """);
    await database.execute("""CREATE TABLE TBL_HISTORIES(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              balance TEXT,
              moneyInOut TEXT,
              transactionAmount TEXT,
              datetime TEXT,
              availableBalance TEXT,
              description TEXT,
              type INTEGER,
              walletID INTEGER,
              FOREIGN KEY(type) REFERENCES TBL_OUTTYPES (ID),
              FOREIGN KEY(walletID) REFERENCES TBL_WALLETS (ID));
              """);

    await database.execute("""CREATE TABLE TBL_OUTTYPES(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              description TEXT);
              """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      "eWalletUserDatabase.db",
      version: 4,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
        OutType outType = OutType("Other");
        addOutTypes(outType);
      },
    );
  }

  //WALLET CRUD
  static Future<int> addWallet(WalletModel walletModel) async {
    final db = await UserDatabaseProvider.db();

    final data = {
      'name': walletModel.name,
      'currency': walletModel.currency,
      'balance': walletModel.balance
    };
    final id = await db.insert('TBL_WALLETS', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> updateWallet(int id, double newBalance) async {
    final db = await UserDatabaseProvider.db();

    final result = await db.rawUpdate(
        'UPDATE TBL_WALLETS SET balance = ? WHERE id = ?', [newBalance, id]);
    return result;
  }

  static Future<int> deleteWallet(int id) async {
    final db = await UserDatabaseProvider.db();

    var result = await db.rawDelete('DELETE FROM TBL_WALLETS WHERE id=?', [id]);

    return result;
  }

  static Future<List<WalletModel>> getWalletList() async {
    final db = await UserDatabaseProvider.db();

    List<Map<String, dynamic>> result =
        await db.query('TBL_WALLETS', orderBy: "id");
    return List.generate(result.length, (i) {
      return WalletModel.fromMap(result[i]);
    });
  }

  static Future<WalletModel> getWalletWithId(int id) async {
    final db = await UserDatabaseProvider.db();

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM TBL_WALLETS WHERE id=?', [id]);

    if (result.isNotEmpty) {
      return WalletModel.fromMap(result.first);
    }
    return WalletModel.withId(id, "", "", 0);
  }

  //HISTORY CRUD

  static Future<int> addHistory(HistoryModel historyModel) async {
    final db = await UserDatabaseProvider.db();

    final data = {
      'balance': historyModel.balance,
      'moneyInOut': historyModel.moneyInOut,
      'transactionAmount': historyModel.transactionAmount,
      'datetime': historyModel.datetime,
      'availableBalance': historyModel.availableBalance,
      'description': historyModel.description,
      'type': historyModel.type,
      'walletID': historyModel.walletID,
    };
    final id = await db.insert('TBL_HISTORIES', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> deleteHistory(int id) async {
    final db = await UserDatabaseProvider.db();
    var result =
        await db.rawDelete('DELETE FROM TBL_HISTORIES WHERE id=?', [id]);

    return result;
  }

  static Future<List<HistoryModel>> getHistoryList(int id) async {
    final db = await UserDatabaseProvider.db();

    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM TBL_HISTORIES WHERE walletID = ? ORDER BY id DESC',
        [id]);
    return List.generate(result.length, (i) {
      return HistoryModel.fromMap(result[i]);
    });
  }

  static Future<HistoryModel> getHistoryWithId(int id) async {
    final db = await UserDatabaseProvider.db();

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM TBL_HISTORIES WHERE id=?', [id]);

    if (result.isNotEmpty) {
      return HistoryModel.fromMap(result.first);
    }
    return HistoryModel.withId(id, "", "", "", "", "", "", 0, 0);
  }

  static Future<List> getHistoryChart(
      int id, String firstDate, String secondDate) async {
    final db = await UserDatabaseProvider.db();
    List chartData = [];
    // List<Map<String, dynamic>> typesQuery = await db.rawQuery(
    //     "SELECT DISTINCT type FROM TBL_HISTORIES WHERE strftime('%Y-%m-%d', datetime) BETWEEN '$firstDate' AND '$secondDate'");
    List<OutType> outTypes = await getOutTypes();
    for (var element in outTypes) {
      List<Map<String, dynamic>> result = await db.rawQuery(
          "SELECT SUM(CAST(REPLACE(transactionAmount, ',', '') as decimal)) FROM TBL_HISTORIES WHERE walletID = $id AND type = ${element.id} AND moneyInOut = 'OUT' AND strftime('%Y-%m-%d', datetime) BETWEEN '$firstDate' AND '$secondDate'");

      // // double value = result[0]
      // print(element.description);
      // print(result
      //     .first["SUM(CAST(REPLACE(transactionAmount, ',', '') as decimal))"]);

      chartData.add([
        element.description,
        result.first[
                "SUM(CAST(REPLACE(transactionAmount, ',', '') as decimal))"] ??
            0
      ]);
    }

    return chartData;
  }

  static Future<List<OutType>> getOutTypes() async {
    final db = await UserDatabaseProvider.db();

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM TBL_OUTTYPES');
    return List.generate(result.length, (i) {
      return OutType.fromMap(result[i]);
    });
  }

  static Future<int> addOutTypes(OutType outType) async {
    final db = await UserDatabaseProvider.db();

    final data = {'description': outType.description};
    final id = await db.insert('TBL_OUTTYPES', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> deleteOutTypes(int id) async {
    final db = await UserDatabaseProvider.db();

    var count = await db
        .rawQuery('SELECT ID FROM TBL_OUTTYPES WHERE description = "Other"');

    await db.rawUpdate(
        'UPDATE TBL_HISTORIES SET type = ${count[0]["id"]} WHERE type = $id');

    await db.rawDelete('DELETE FROM TBL_OUTTYPES WHERE id=?', [id]);

    // List<OutType> result = await getOutTypes();

    // for (int i = 0; i < result.length; i++) {
    //   print(result[i].description);
    // }

    return 1;
  }

  static Future<int> getOutTypesOtherId() async {
    final db = await UserDatabaseProvider.db();

    var count = await db
        .rawQuery('SELECT ID FROM TBL_OUTTYPES WHERE description = "Other"');

    int otherId = int.parse(count[0]["id"].toString());

    return otherId;
  }

  static Future<String> getOutTypesWithId(int id) async {
    final db = await UserDatabaseProvider.db();
    var result =
        await db.rawQuery('SELECT * FROM TBL_OUTTYPES WHERE id = ?', [id]);

    if (result.isNotEmpty) {
      OutType outType = OutType.fromMap(result.first);
      return outType.description;
    }
    return "";
  }
}
