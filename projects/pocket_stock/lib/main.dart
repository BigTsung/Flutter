import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path/path.dart';
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

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  final _controller = TextEditingController();
  String stockContent = "";

  Future<void> getStockIDbyName() async {
    print("getStockIDbyName");

    ByteData data = await rootBundle.load("assets/StockList.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      print(excel.tables[table].maxCols);
      print(excel.tables[table].maxRows);
      for (var row in excel.tables[table].rows) {
        print("$row");
      }
    }
  }

  Future<void> getStockInfoByID() async {
    print(_controller.text);
    var url = 'https://goodinfo.tw/StockInfo/StockDetail.asp?STOCK_ID=' +
        _controller.text;
    var response = await http.get(url);

    List<int> bytes = response.bodyBytes;
    String result = convert.utf8.decode(bytes);

    var soup = Beautifulsoup(result);

    var classlinks = soup.find_all("table");
    var element = classlinks.firstWhere(
        (element) => element.className == "solid_1_padding_3_1_tbl");

    print("before: ");
    print(element.text);

    List<String> stockInfoList = element.text.split(" ");
    stockInfoList.removeWhere((item) => item == "");

    print("after : ");
    print(stockInfoList);

    // Bad progress
    String strStockInfo = stockInfoList[2] +
        "  " +
        stockInfoList[10] +
        "\n" +
        stockInfoList[3] +
        "  " +
        stockInfoList[11] +
        "\n" +
        stockInfoList[4] +
        "  " +
        stockInfoList[12] +
        "\n" +
        stockInfoList[5] +
        "  " +
        stockInfoList[13] +
        "\n" +
        stockInfoList[6] +
        "  " +
        stockInfoList[14] +
        "\n" +
        stockInfoList[7] +
        "  " +
        stockInfoList[15] +
        "\n" +
        stockInfoList[8] +
        "  " +
        stockInfoList[16] +
        "\n" +
        stockInfoList[9] +
        "  " +
        stockInfoList[17] +
        "\n";
    setState(() {
      stockContent = strStockInfo;
    });
  }

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
            // color: Colors.amber[100],
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _controller,
                  onChanged: (text) {
                    print("$text");
                  },
                  decoration: InputDecoration(
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey,
                        width: 5,
                      )),
                      icon: Icon(Icons.save),
                      labelText: 'Enter a stock Name'),
                ),
                SizedBox(
                    height: 50,
                    width: 50,
                    child: IconButton(
                        iconSize: 50,
                        icon: Icon(Icons.search),
                        onPressed: getStockIDbyName))
              ],
            ),
          ),
          Container(
            height: 130,
            // color: Colors.amber[100],
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _controller,
                  onChanged: (text) {
                    print("$text");
                  },
                  decoration: InputDecoration(
                      icon: Icon(Icons.save), labelText: 'Enter a stock ID'),
                ),
                SizedBox(
                    height: 50,
                    width: 50,
                    child: IconButton(
                        iconSize: 50,
                        icon: Icon(Icons.search),
                        onPressed: null))
              ],
            ),
          ),
          Container(
            height: 100,
            // color: Colors.amber[600],
            child: const Center(child: Text('Entry A')),
          ),
          Container(
            height: 100,
            // color: Colors.amber[500],
            child: const Center(child: Text('Entry B')),
          ),
          Container(
            height: 100,
            // color: Colors.amber[100],
            child: const Center(child: Text('Entry C')),
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
