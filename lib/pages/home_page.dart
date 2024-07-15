import 'package:easy_localization/easy_localization.dart';
import 'package:ewallet/model/history_model.dart';
import 'package:ewallet/model/out_type_model.dart';
import 'package:ewallet/model/user_database_provider.dart';
import 'package:ewallet/model/wallet_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ewallet/provider/currency_text_formatter.dart';

class HomePage extends StatefulWidget {
  final WalletModel wallet;
  const HomePage({
    Key? key,
    required this.wallet,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _balanceTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var _tabController;
  List<HistoryModel> history = [];
  List<OutType> outTypeList = [];
  bool isLoading = false;
  bool isLoadingHistory = false;
  late WalletModel wallet;
  late HistoryModel transactionHistory;
  String selectedType = "Select Type".tr();
  int cupertinoValue = 0;
  String historyType = "";

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    wallet = widget.wallet;
    fillHistory();
    fillOutType();
  }

  Future<void> fillOutType() async {
    outTypeList = await UserDatabaseProvider.getOutTypes();
  }

  Future<void> fillHistory() async {
    setState(() => isLoading = true);
    history = await UserDatabaseProvider.getHistoryList(wallet.id);
    wallet = await UserDatabaseProvider.getWalletWithId(wallet.id);
    setState(() => isLoading = false);
  }

  Future<void> getHistory(int id) async {
    setState(() => isLoadingHistory = true);
    transactionHistory = await UserDatabaseProvider.getHistoryWithId(id);
    setState(() => isLoadingHistory = false);
  }

  Future<void> getHistoryType(int id) async {
    historyType = await UserDatabaseProvider.getOutTypesWithId(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      elevation: 0,
                      pinned: true,
                      centerTitle: false,
                      expandedHeight: 200,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Container(
                          padding: const EdgeInsets.only(top: 33),
                          alignment: Alignment.center,
                          child: Text(
                            "${NumberFormat.currency(locale: "en_US", symbol: "").format(wallet.balance)} ${wallet.currency}",
                            textAlign: TextAlign.center,
                            style: wallet.balance < 0
                                ? Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(color: Colors.red)
                                : Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        background: Container(
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.only(bottom: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        selectedType = "Select Type".tr();
                                        inOutMoneyDialog(context, "Gelir");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_downward_rounded,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  const Text("Income").tr()
                                ],
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        selectedType = "Select Type".tr();

                                        inOutMoneyDialog(context, "Gider");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_upward_rounded,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  const Text("Expense").tr()
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Theme.of(context).colorScheme.secondary),
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                width: 1, color: Colors.grey))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat.d().format(DateFormat(
                                                  'yyyy-MM-dd HH:mm')
                                              .parse(history[index].datetime)),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                        ),
                                        Text(
                                          DateFormat.LLLL().format(DateFormat(
                                                  'yyyy-MM-dd HH:mm')
                                              .parse(history[index].datetime)),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        Text(
                                          DateFormat.Hm().format(DateFormat(
                                                  'yyyy-MM-dd HH:mm')
                                              .parse(history[index].datetime)),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    history[index].description,
                                                    maxLines: 3,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        ?.copyWith(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Text(
                                                      "${history[index].moneyInOut == "OUT" ? "-" : "+"}${history[index].transactionAmount} ${wallet.currency}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge
                                                          ?.copyWith(
                                                              color: history[index]
                                                                          .moneyInOut ==
                                                                      "OUT"
                                                                  ? Colors
                                                                      .red[800]
                                                                  : Colors.green[
                                                                      900]),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        getHistoryType(
                                                            history[index]
                                                                .type);
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                      "Transaction Detail")
                                                                  .tr(),
                                                              content: SizedBox(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      if (history[index]
                                                                              .moneyInOut ==
                                                                          "OUT")
                                                                        ListTile(
                                                                          contentPadding: const EdgeInsets.symmetric(
                                                                              horizontal: 0.0,
                                                                              vertical: 0.0),
                                                                          visualDensity: const VisualDensity(
                                                                              horizontal: 0,
                                                                              vertical: -4),
                                                                          title:
                                                                              Text("Payment Type", style: Theme.of(context).textTheme.bodyLarge).tr(),
                                                                          trailing: Text(
                                                                              historyType,
                                                                              style: Theme.of(context).textTheme.labelLarge),
                                                                        ),
                                                                      ListTile(
                                                                        contentPadding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                0.0,
                                                                            vertical:
                                                                                0.0),
                                                                        visualDensity: const VisualDensity(
                                                                            horizontal:
                                                                                0,
                                                                            vertical:
                                                                                -4),
                                                                        title: Text("Date",
                                                                                style: Theme.of(context).textTheme.bodyLarge)
                                                                            .tr(),
                                                                        trailing: Text(
                                                                            "${DateFormat.yMMMEd().format(DateFormat('yyyy-MM-dd HH:mm').parse(history[index].datetime))} ${DateFormat.Hm().format(DateFormat('yyyy-MM-dd HH:mm').parse(history[index].datetime))}",
                                                                            style:
                                                                                Theme.of(context).textTheme.labelLarge),
                                                                      ),
                                                                      ListTile(
                                                                        contentPadding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                0.0,
                                                                            vertical:
                                                                                0.0),
                                                                        visualDensity: const VisualDensity(
                                                                            horizontal:
                                                                                0,
                                                                            vertical:
                                                                                -4),
                                                                        title: Text("Amount",
                                                                                style: Theme.of(context).textTheme.bodyLarge)
                                                                            .tr(),
                                                                        trailing: Text(
                                                                            "${history[index].moneyInOut == "OUT" ? "-" : "+"}${history[index].transactionAmount} ${wallet.currency}",
                                                                            style:
                                                                                Theme.of(context).textTheme.labelLarge?.copyWith(color: history[index].moneyInOut == "OUT" ? Colors.red[800] : Colors.green[900])),
                                                                      ),
                                                                      ListTile(
                                                                        contentPadding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                0.0,
                                                                            vertical:
                                                                                0.0),
                                                                        visualDensity: const VisualDensity(
                                                                            horizontal:
                                                                                0,
                                                                            vertical:
                                                                                -4),
                                                                        title: Text("Available balance",
                                                                                style: Theme.of(context).textTheme.bodyLarge)
                                                                            .tr(),
                                                                        trailing: Text(
                                                                            NumberFormat.currency(locale: "en_US", symbol: "").format(double.parse(history[index]
                                                                                .availableBalance)),
                                                                            style:
                                                                                Theme.of(context).textTheme.labelLarge),
                                                                      ),
                                                                      Text("Description",
                                                                              style: Theme.of(context).textTheme.bodyLarge)
                                                                          .tr(),
                                                                      const Divider(
                                                                        thickness:
                                                                            1,
                                                                      ),
                                                                      Text(
                                                                          history[index]
                                                                              .description,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyLarge)
                                                                    ]),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                      ),
                                                      highlightColor:
                                                          Colors.transparent,
                                                      icon: const Icon(
                                                        Icons
                                                            .description_rounded,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            NumberFormat.currency(
                                                    locale: "en_US", symbol: "")
                                                .format(double.parse(
                                                    history[index]
                                                        .availableBalance)),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                            textAlign: TextAlign.end,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: history.length,
                    ))
                  ],
                ),
                DonutChart(
                  walletid: wallet.id,
                  walletHeadline: wallet.name,
                )
              ],
            ),
    );
  }

  Future<dynamic> inOutMoneyDialog(
      BuildContext context, String inOutState) async {
    _balanceTextController.text = "";
    _descriptionTextController.text = "";
    int paymentType = await UserDatabaseProvider.getOutTypesOtherId();
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: Text("$inOutState ekle"),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (inOutState == "Gider")
                          InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Select Type").tr(),
                                  content: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 150,
                                            child: CupertinoPicker(
                                              itemExtent: 50,
                                              children: [
                                                Center(
                                                    child: const Text("Other")
                                                        .tr()),
                                                for (int i = 1;
                                                    i < outTypeList.length;
                                                    i++)
                                                  Center(
                                                      child: Text(outTypeList[i]
                                                          .description)),
                                              ],
                                              onSelectedItemChanged: (value) {
                                                cupertinoValue = value;
                                                paymentType =
                                                    outTypeList[value].id;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  selectedType = outTypeList[
                                                          cupertinoValue]
                                                      .description;
                                                  Navigator.of(context).pop();
                                                  setState(() {});
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
                                        ]),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border:
                                      Border.all(color: Colors.grey, width: 2)),
                              child: Text(
                                selectedType,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextField(
                            controller: _balanceTextController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              CurrencyTextInputFormatter()
                            ],
                            decoration: InputDecoration(
                                hintText: "Balance".tr(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                prefixIcon: const Icon(Icons.wallet)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextField(
                            controller: _descriptionTextController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                                hintText: "Description".tr(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                prefixIcon:
                                    const Icon(Icons.label_important_rounded)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                double availableBalance = inOutState == "Gelir"
                                    ? wallet.balance +
                                        double.parse(_balanceTextController.text
                                            .replaceAll(",", ""))
                                    : wallet.balance -
                                        double.parse(_balanceTextController.text
                                            .replaceAll(",", ""));
                                HistoryModel history = HistoryModel(
                                    wallet.balance.toString(),
                                    inOutState == "Gelir" ? "IN" : "OUT",
                                    _balanceTextController.text,
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(DateTime.now()),
                                    availableBalance.toString(),
                                    _descriptionTextController.text,
                                    paymentType,
                                    wallet.id);
                                UserDatabaseProvider.addHistory(history);
                                UserDatabaseProvider.updateWallet(
                                    wallet.id, availableBalance);
                                fillHistory();

                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          side: BorderSide(
                                              width: 2, color: Colors.grey)))),
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                child: const Text("Save").tr(),
                              )),
                        ),
                      ]),
                ),
              ),
            ));
  }
}

class DonutChart extends StatefulWidget {
  final int walletid;
  final String walletHeadline;
  const DonutChart(
      {Key? key, required this.walletid, required this.walletHeadline})
      : super(key: key);

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  List<ChartData> chartData = [
    ChartData('Empty', 100, const Color.fromRGBO(9, 0, 136, 1)),
  ];
  late String walletHeadLine;
  late int walletid;
  String firstLine = "GraphFirstLine".tr();
  String secondLine = "GraphSecondLine".tr();

  @override
  void initState() {
    super.initState();
    walletHeadLine = widget.walletHeadline;
    walletid = widget.walletid;
    drawChart("1970-01-01", "2024-01-01");
  }

  List<Color> colorList = [
    const Color.fromRGBO(255, 255, 204, 1),
    const Color.fromRGBO(255, 204, 204, 1),
    const Color.fromRGBO(255, 153, 204, 1),
    const Color.fromRGBO(255, 102, 204, 1),
    const Color.fromRGBO(255, 51, 204, 1),
    const Color.fromRGBO(153, 0, 204, 1),
    const Color.fromRGBO(153, 51, 204, 1),
    const Color.fromRGBO(153, 102, 204, 1),
    const Color.fromRGBO(153, 153, 204, 1),
    const Color.fromRGBO(153, 204, 204, 1),
    const Color.fromRGBO(153, 255, 204, 1),
    const Color.fromRGBO(51, 255, 204, 1),
    const Color.fromRGBO(51, 204, 204, 1),
    const Color.fromRGBO(51, 153, 204, 1),
    const Color.fromRGBO(51, 102, 204, 1),
    const Color.fromRGBO(51, 51, 204, 1),
    const Color.fromRGBO(51, 0, 204, 1),
    const Color.fromRGBO(21, 101, 192, 1),
    const Color.fromRGBO(0, 131, 143, 1),
    const Color.fromRGBO(128, 222, 234, 1),
  ];

  Future<void> drawChart(String firstDate, String lastDate) async {
    List data = await UserDatabaseProvider.getHistoryChart(
        walletid, firstDate, lastDate);

    chartData.clear();
    for (int i = 0; i < data.length; i++) {
      chartData.add(ChartData(
          data[i][0], double.parse(data[i][1].toString()), colorList[i]));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              walletHeadLine,
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, -MediaQuery.of(context).size.width * 0.06),
          child: SfCircularChart(series: <CircularSeries>[
            // Renders doughnut chart
            DoughnutSeries<ChartData, String>(
                dataSource: chartData,
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y)
          ]),
        ),
        Transform.translate(
          offset: Offset(0, -MediaQuery.of(context).size.width * 0.06),
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.38,
              width: MediaQuery.of(context).size.width * 0.38,
              child: ElevatedButton(
                onPressed: () {
                  String firstDate = "First Date".tr();
                  String lastDate = "Last Date".tr();

                  showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                            builder: (context, setState) => AlertDialog(
                              title: const Text("Select Range").tr(),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        onTap: () async {
                                          DateTime? firstDateTime =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime.now(),
                                          );
                                          if (firstDateTime != null) {
                                            firstDate = DateFormat('yyyy-MM-dd')
                                                .format(firstDateTime);
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 2)),
                                          child: Text(
                                            firstDate.toString(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      InkWell(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        onTap: () async {
                                          DateTime? lastDateTime =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime.now(),
                                          );
                                          if (lastDateTime != null) {
                                            lastDate = DateFormat('yyyy-MM-dd')
                                                .format(lastDateTime);
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 2)),
                                          child: Text(
                                            lastDate.toString(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            drawChart(firstDate, lastDate);
                                            firstLine = firstDate;
                                            secondLine = lastDate;
                                          },
                                          style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(15)),
                                                      side: BorderSide(
                                                          width: 2,
                                                          color:
                                                              Colors.grey)))),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 50,
                                            child: const Text("Save").tr(),
                                          )),
                                    ]),
                              ),
                            ),
                          ));
                },
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      firstLine,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      secondLine,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.335,
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 8),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.28,
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 8, right: 8),
                    leading: SizedBox(
                      height: double.infinity,
                      child: Icon(
                        Icons.square_rounded,
                        color: chartData[0].color,
                        size: 20,
                      ),
                    ),
                    minLeadingWidth: 10,
                    title: Text(
                      "Other",
                      style: Theme.of(context).textTheme.labelLarge,
                    ).tr(),
                  ),
                ),
                for (int i = 1; i < chartData.length; i++)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 8, right: 8),
                      leading: SizedBox(
                        height: double.infinity,
                        child: Icon(
                          Icons.square_rounded,
                          color: chartData[i].color,
                          size: 20,
                        ),
                      ),
                      minLeadingWidth: 10,
                      title: Text(
                        chartData[i].x.toString(),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
