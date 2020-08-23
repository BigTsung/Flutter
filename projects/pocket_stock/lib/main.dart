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

class _MyHomePageState extends State<MyHomePage> {
  final stockNamecontroller = TextEditingController();
  final getIDController = TextEditingController();
  String stockContent = "";
  List stocks = [];
  // String stockName = '';

  List<DataRow> _stockList = [
    // DataRow(cells: <DataCell>[
    //   DataCell(Text('')),
    //   DataCell(Text('')),
    //   DataCell(Text('')),
    // ]),
  ];

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

    var classlinks = soup.find_all("table");
    var element = classlinks.firstWhere(
        (element) => element.className == "solid_1_padding_3_1_tbl");

    print(element.text);

    String resultStr = element.text.replaceFirst("期貨標的選擇權標的資料日期:", "");

    // resultStr.replaceFirst(stockID, "");
    // print(resultStr);

    List<String> stockInfoList = resultStr.split(" ");
    stockInfoList.removeWhere((item) => item == "");

    // print("after : ");
    print(stockInfoList);

    _stockList.add(DataRow(cells: <DataCell>[
      DataCell(Text(stockInfoList[0])),
      DataCell(Text(stockID)),
      DataCell(Text(stockInfoList[10])),
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
    getThingsOnStartup().then((value) {
      print("Initial Done!!");
    });
    super.initState();
  }

  Future getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 10));
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
          // Container(
          //     height: 100,
          //     // color: Colors.amber[600],
          //     child: Text(
          //       "Enter a stock name",
          //       style: TextStyle(color: Colors.grey[800], fontSize: 30),
          //     )),
          // Container(
          //   height: 130,
          //   child: Column(
          //     children: <Widget>[
          //       TextField(
          //         controller: getIDController,
          //         onChanged: (text) {
          //           print("$text");
          //         },
          //         decoration: InputDecoration(
          //             focusedErrorBorder: UnderlineInputBorder(
          //                 borderSide: BorderSide(
          //               color: Colors.grey,
          //               width: 5,
          //             )),
          //             prefixIcon: Icon(Icons.save),
          //             labelText: 'Enter a stock Name'),
          //       ),
          //       SizedBox(
          //           height: 50,
          //           width: 50,
          //           child: IconButton(
          //               iconSize: 50,
          //               icon: Icon(Icons.search),
          //               onPressed: getStockIDByName))
          //     ],
          //   ),
          // ),
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
              DataColumn(label: Text("代號")),
              DataColumn(label: Text("股價"))
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
