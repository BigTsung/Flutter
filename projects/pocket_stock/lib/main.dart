import 'dart:ffi';

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
  Float eps;
  Float closingPrice;

  Stock(this.name, this.id, this.eps, this.closingPrice);
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
  // String stockName = '';
  List<String> closeDays = [];

  List<DataRow> _stockList = [
    // DataRow(cells: <DataCell>[
    //   DataCell(Text('')),
    //   DataCell(Text('')),
    //   DataCell(Text('')),
    // ]),
  ];

  Future<void> loadCloseDateData() async {
    ByteData data = await rootBundle.load("assets/OpenDate_2020.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      for (int i = 0; i < excel.tables[table].rows.length; i++) {
        if (i > 0) {
          // print(excel.tables[table].rows[i].toString());
          String strCloseDate =
              excel.tables[table].rows[i].toString().replaceFirst(".0", "");
          // print(strCloseDate);

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
    // today = new Today(now.year.toString(), now.month.toString(), .nowday.toString(), now.weekday.toString()) as String;
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
    print(isNumeric(input));
    if (isNumeric(input)) {
      getStockInfoByID(input);
    } else {
      print("input:" + input);
      String stockID = getStockIDByName(input);
      getStockInfoByID(stockID);
      print(stockID.toString());
    }
  }

  String getStockIDByName(String targetName) {
    // print(getIDController.text);
    String stockID;
    int targetIndex =
        stocks.indexWhere((element) => element.name == targetName);
    // print(targetIndex);
    if (targetIndex > 0)
      stockID = stocks[targetIndex].id;
    else
      stockID = "Nore";

    print(stockID);
    return stockID;
  }

  Future<void> getStockInfoByID(String stockID) async {
    // String stockID = stockNamecontroller.text;
    var url =
        'https://goodinfo.tw/StockInfo/StockDetail.asp?STOCK_ID=' + stockID;
    var response = await http.get(url);

    List<int> bytes = response.bodyBytes;
    String result = convert.utf8.decode(bytes);

    var soup = Beautifulsoup(result);

    print(stockID);
    print(soup);

    var classlinks = soup.find_all("table");
    var basicData = classlinks.firstWhere(
        (basicData) => basicData.className == "solid_1_padding_3_1_tbl");

    String resultStr = basicData.text;
    resultStr = resultStr.replaceFirst("期貨標的選擇權標的資料日期:", "");
    resultStr = resultStr.replaceFirst("期貨標的資料日期:", "");
    resultStr = resultStr.replaceFirst("資料日期:", "");
    // print(resultStr);

    List<String> stockInfoList = resultStr.split(" ");
    stockInfoList.removeWhere((item) => item == "");

    var dividendsData = classlinks.lastWhere((dividendsData) =>
        dividendsData.className == "solid_1_padding_4_4_tbl");

    print(dividendsData.text);

    String dividendsStr = dividendsData.text;

    List<String> stockDividendsList = dividendsStr.split(" ");
    stockDividendsList.removeWhere((item) => item == "");
    // print("after : ");
    print(stockDividendsList);

    _stockList.add(DataRow(cells: <DataCell>[
      DataCell(Text(stockInfoList[0])),
      DataCell(Text(stockInfoList[10])),
      DataCell(Text(stockDividendsList[6])),
      DataCell(Text(stockDividendsList[7]))
    ]));

    setState(() {
      // stockContent = strStockInfo;
    });
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
    await Future.delayed(Duration(seconds: 5));
  }

// =======================================================
// ======= build =========================================
// =======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.grey[600],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Container(
            height: 130,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: stockNamecontroller,
                  onChanged: (text) {
                    print("$text");
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.save),
                      labelText: 'Enter a stock ID or Name'),
                ),
                SizedBox(
                    height: 50,
                    width: 50,
                    child: IconButton(
                        iconSize: 50,
                        icon: Icon(Icons.search),
                        onPressed: searchStock))
              ],
            ),
          ),
          Container(
            height: 130,
            child: DataTable(columns: [
              DataColumn(label: Text("名稱")),
              DataColumn(label: Text("股價")),
              DataColumn(label: Text("配息")),
              DataColumn(label: Text("配股"))
            ], rows: _stockList),
          ),
        ],
      ),
    );
  }
}

// Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             TextField(
//               controller: _controller,
//               onChanged: (text) {
//                 print("$text");
//               },
//               decoration: InputDecoration(hintText: 'Enter a stock Name'),
//             ),
//             IconButton(icon: Icon(Icons.search), onPressed: getStockIDbyName),
//             TextField(
//               controller: _controller,
//               onChanged: (text) {
//                 print("First text field: $text");
//               },
//               inputFormatters: [
//                 WhitelistingTextInputFormatter(RegExp("[0-9]")),
//               ],
//               decoration: InputDecoration(hintText: 'Enter a stock ID'),
//             ),
//             IconButton(icon: Icon(Icons.search), onPressed: getStockInfoByID),
//             Text("$stockContent"),
//             // DataTable(columns: [
//             //   DataColumn(label: Text("Item")),
//             //   DataColumn(label: Text("Value")),
//             // ], rows: [
//             //   DataRow(cells: [DataCell(Text("data")), DataCell(Text("aaa"))]),
//             //   // DataRow(cells: [DataCell(Text("anson")), DataCell(Text('data'))]),
//             // ]),
//           ],
//         ),
//       ),
