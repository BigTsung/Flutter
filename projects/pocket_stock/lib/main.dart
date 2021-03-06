import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Stock Pocket'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class StockTable {
  String name;
  String id;

  StockTable(this.name, this.id);
}

class Stock {
  String name;
  String id;
  String closingPrice;
  String cashDividend;
  String dividend;

  Stock(
      this.name, this.id, this.closingPrice, this.cashDividend, this.dividend);
}

class Today {
  String year;
  String month;
  String day;
  String weekday;

  Today(this.year, this.month, this.day, this.weekday);

  String getWeekday() {
    return weekday;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final stockNamecontroller = TextEditingController();
  final getIDController = TextEditingController();
  String stockContent = "";
  Today today;

  List stocks = [];
  List<String> closeDays = [];

  List<Stock> stockList = [];

  List<Stock> pocket = [];

  Future<void> loadCloseDateData() async {
    ByteData data = await rootBundle.load("assets/OpenDate_2020.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      for (int i = 0; i < excel.tables[table].rows.length; i++) {
        if (i > 0) {
          String strCloseDate =
              excel.tables[table].rows[i].toString().replaceFirst(".0", "");

          closeDays.add(strCloseDate);
        }
      }
    }

    print(closeDays);
  }

  String getToday() {
    var now = new DateTime.now();

    print("weekday: " + now.weekday.toString());

    today = new Today(now.year.toString(), now.month.toString(),
        now.day.toString(), now.weekday.toString());

    String todayStr = now.year.toString().padLeft(4, '0') +
        now.month.toString().padLeft(2, '0') +
        now.day.toString().padLeft(2, '0');
    print("today: " + todayStr);
    return todayStr;
  }

  bool isCloseday() {
    bool close = true;

    String todayStr = getToday();

    // default weekday == 6 || 7 is close day
    if (today.weekday == "6" || today.weekday == "7") {
      return true;
    }

    if (closeDays != null && todayStr != "") {
      close = closeDays.any((e) => e.contains(todayStr));
    }

    return close;
  }

  void addStockToPocket(String id) {
    pocket.add(stockList.firstWhere((element) => element.id == id));
  }

  Future<void> initStockTable() async {
    print("getStockIDbyName");

    ByteData data = await rootBundle.load("assets/ListedCompany.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      for (List row in excel.tables[table].rows) {
        String name = row[1].toString();
        String id = row[0].toString();
        stocks.add(StockTable(name, id));
      }
    }

    ByteData otcData =
        await rootBundle.load("assets/OverTheCounterCompany.xlsx");
    var otcBytes = otcData.buffer
        .asUint8List(otcData.offsetInBytes, otcData.lengthInBytes);
    var otcExcel = Excel.decodeBytes(otcBytes);

    for (var table in otcExcel.tables.keys) {
      for (List row in otcExcel.tables[table].rows) {
        String name = row[1].toString();
        String id = row[0].toString();
        stocks.add(StockTable(name, id));
      }
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null ||
        int.parse(s, onError: (e) => null) != null;
  }

  Future<void> searchStock() async {
    String input = stockNamecontroller.text;

    print(input);

    if (isNumeric(input)) {
      getStockInfoByID(input);
    } else {
      String stockID = getStockIDByName(input);
      getStockInfoByID(stockID);
    }
  }

  String getStockIDByName(String targetName) {
    String stockID;
    int targetIndex =
        stocks.indexWhere((element) => element.name == targetName);
    if (targetIndex > 0)
      stockID = stocks[targetIndex].id;
    else
      stockID = "Nore";
    return stockID;
  }

  String getStockNameByID(String targetID) {
    String stockName;
    int targetIndex = stocks.indexWhere((element) => element.id == targetID);
    if (targetIndex > 0)
      stockName = stocks[targetIndex].name;
    else
      stockName = "Nore";
    return stockName;
  }

  Future<void> getStockInfoByID(String stockID) async {
    var url =
        'https://goodinfo.tw/StockInfo/StockDetail.asp?STOCK_ID=' + stockID;
    var response = await http.get(url);

    List<int> bytes = response.bodyBytes;
    String result = convert.utf8.decode(bytes);

    var soup = Beautifulsoup(result);

    var classlinks = soup.find_all("table");
    var basicData = classlinks.firstWhere(
        (basicData) => basicData.className == "solid_1_padding_3_1_tbl");

    String resultStr = basicData.text;
    resultStr = resultStr.replaceFirst("期貨標的選擇權標的資料日期:", "");
    resultStr = resultStr.replaceFirst("期貨標的資料日期:", "");
    resultStr = resultStr.replaceFirst("資料日期:", "");

    List<String> stockInfoList = resultStr.split(" ");
    stockInfoList.removeWhere((item) => item == "");

    // the last "solid_1_padding_4_4_tbl" is target class
    var dividendsData = classlinks.lastWhere((dividendsData) =>
        dividendsData.className == "solid_1_padding_4_4_tbl");

    String dividendsStr = dividendsData.text;

    List<String> stockDividendsList = dividendsStr.split(" ");
    stockDividendsList.removeWhere((item) => item == "");

    stockList.add(new Stock(
        getStockNameByID(stockID.replaceFirst("00", "")),
        stockID,
        stockInfoList[10],
        stockDividendsList[6],
        stockDividendsList[7]));

    setState(() {});
  }

  void onclickAddedButton(String id) {
    print("onclickAddedButton");
    addStockToPocket(id);
    stockList.removeWhere((element) => element.id == id);
    setState(() {});
  }

  void onclickRemoveButton(String id) {
    print("onclickRemoveButton");
    pocket.removeWhere((element) => element.id == id);
    setState(() {});
  }

// =======================================================
// ====== InitState ======================================
// =======================================================

  @override
  void initState() {
    print("Init State!!");
    initStockTable();
    loadCloseDateData();

    getThingsOnStartup().then((value) {
      print(isCloseday());
      print("Initial Done!!");
    });
    super.initState();
  }

  Future getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 3));
  }

// =======================================================
// ====== UI Widget ======================================
// =======================================================

  Widget appBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: new AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Stock Pocket",
          style: TextStyle(color: Colors.white, fontSize: 32),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: <Widget>[
          new SizedBox(
            height: 70,
            width: 70,
            child: new IconButton(
                iconSize: 35,
                color: Colors.white70,
                disabledColor: Colors.white38,
                icon: Icon(Icons.add_alert),
                onPressed: () {}),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20 / 4,
      ),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          TextField(
            controller: stockNamecontroller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                // icon: Icon(
                //   Icons.search,
                //   color: Colors.white,
                // ),
                hintText: 'Enter a stock ID or Name',
                hintStyle: TextStyle(color: Colors.white)),
          ),
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                searchStock();
              })
        ],
      ),
    );
  }

  Widget tabBar() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: FlatButton(
            onPressed: () {},
            child: Text("Browse", style: TextStyle(color: Colors.white)),
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {},
            child: Text(
              "Pocket",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {},
            child: Text(
              "Setting",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    ));
  }

// =======================================================
// ======= build =========================================
// =======================================================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.green[300],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: appBar(),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              searchBox(),
              tabBar(),
              SizedBox(height: 20),
              Expanded(
                  child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                  ),
                  ListView.builder(
                      itemCount: stockList.length,
                      itemBuilder: (context, index) => StockCard(
                            stockIndex: index,
                            stock: stockList[index],
                          ))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class StockCard extends StatelessWidget {
  const StockCard({Key key, this.stockIndex, this.stock}) : super(key: key);

  final int stockIndex;

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("Size:      " + size.toString());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: 160,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: 136,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.green[700],
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey,
              //       blurRadius: 10.0,
              //       offset: Offset(10.0, 10.0)),
              // ]
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(22)),
            ),
          ),
          Positioned(
              left: 0,
              top: -20,
              child: SizedBox(
                height: 136,
                width: size.width,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 136 / 2, 0, 0),
                      child: Text(stock.name,
                          style: TextStyle(color: Colors.white70, fontSize: 20)
                          // style: Theme.of(context).textTheme.button,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 136 / 2, 0, 0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text("CLOSE",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15)
                                  // style: Theme.of(context).textTheme.button,
                                  ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(stock.closingPrice,
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15)
                                  // style: Theme.of(context).textTheme.button,
                                  ),
                            ],
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Column(
                            children: [
                              Text("CASH_D",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15)
                                  // style: Theme.of(context).textTheme.button,
                                  ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(stock.cashDividend,
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15)
                                  // style: Theme.of(context).textTheme.button,
                                  ),
                            ],
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Column(
                            children: [
                              Text("STOCK_D",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15)
                                  // style: Theme.of(context).textTheme.button,
                                  ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(stock.dividend,
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15)
                                  // style: Theme.of(context).textTheme.button,
                                  ),
                            ],
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Column(
                            children: [
                              Text("PER",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15)
                                  // style: Theme.of(context).textTheme.button,
                                  ),
                              SizedBox(
                                height: 30,
                              ),
                              Text("PER",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15)
                                  // style: Theme.of(context).textTheme.button,
                                  ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

// appBar: AppBar(
//       title: Text(widget.title),
//       backgroundColor: Colors.grey[600],
//     ),
//     body: ListView(
//       padding: const EdgeInsets.all(8),
//       children: <Widget>[
//         Container(
//           height: 130,
//           child: Column(
//             children: <Widget>[
//               TextField(
//                 controller: stockNamecontroller,
// decoration: InputDecoration(
//     prefixIcon: Icon(Icons.save),
//     labelText: 'Enter a stock ID or Name'),
//               ),
//               SizedBox(
//                   height: 50,
//                   width: 50,
//                   child: IconButton(
//                       iconSize: 50,
//                       icon: Icon(Icons.search),
//                       onPressed: searchStock))
//             ],
//           ),
//         ),
//         Container(
//           height: 130,
//           child: DataTable(
//               columnSpacing: 20,
//               columns: [
//                 DataColumn(label: Text("名稱", textAlign: TextAlign.center)),
//                 DataColumn(label: Text("股價", textAlign: TextAlign.center)),
//                 DataColumn(label: Text("配息", textAlign: TextAlign.center)),
//                 DataColumn(label: Text("配股", textAlign: TextAlign.center)),
//                 DataColumn(label: Text("加入", textAlign: TextAlign.center))
//               ],
//               rows: stockList
//                   .map((e) => DataRow(cells: [
//                         DataCell(Text(e.id + " " + e.name)),
//                         DataCell(Text(e.closingPrice)),
//                         DataCell(Text(e.cashDividend)),
//                         DataCell(Text(e.dividend)),
//                         DataCell(IconButton(
//                             icon: Icon(Icons.add),
//                             onPressed: () {
//                               onclickAddedButton(e.id);
//                             }))
//                       ]))
//                   .toList()),
//         ),
//         Container(
//           height: 130,
//           child: DataTable(
//               columnSpacing: 20,
//               columns: [
//                 DataColumn(label: Text("名稱", textAlign: TextAlign.center)),
//                 DataColumn(label: Text("股價", textAlign: TextAlign.center)),
//                 DataColumn(label: Text("配息", textAlign: TextAlign.center)),
//                 DataColumn(label: Text("配股", textAlign: TextAlign.center)),
//                 DataColumn(label: Text("加入", textAlign: TextAlign.center))
//               ],
//               rows: pocket
//                   .map((e) => DataRow(cells: [
//                         DataCell(Text(e.id + " " + e.name)),
//                         DataCell(Text(e.closingPrice)),
//                         DataCell(Text(e.cashDividend)),
//                         DataCell(Text(e.dividend)),
//                         DataCell(IconButton(
//                             icon: Icon(Icons.remove),
//                             onPressed: () {
//                               onclickRemoveButton(e.id);
//                             }))
//                       ]))
//                   .toList()),
//         ),
//       ],
//     ),
