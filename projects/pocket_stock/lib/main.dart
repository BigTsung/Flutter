import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:beautifulsoup/beautifulsoup.dart';

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

  Future<void> _incrementCounter() async {
    print(_controller.text);

    // var url = 'https://goodinfo.tw/StockInfo/StockDetail.asp?STOCK_ID=0050';
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
    // stockInfoList[18] + "  " + stockInfoList[26] + "\n" +
    // stockInfoList[19] + "  " + stockInfoList[27] + "\n" +
    // stockInfoList[20] + "  " + stockInfoList[28] + "\n" +
    // stockInfoList[21] + "  " + stockInfoList[29] + "\n" +
    // stockInfoList[22] + "  " + stockInfoList[30] + "\n" +
    // stockInfoList[23] + "  " + stockInfoList[31] + "\n" +
    // stockInfoList[24] + "  " + stockInfoList[32] + "\n" +
    // stockInfoList[33] + "  " + stockInfoList[39] + "\n" +
    // stockInfoList[34] + "  " + stockInfoList[40] + "\n" +
    // stockInfoList[35] + "  " + stockInfoList[41] + "\n" +
    // stockInfoList[36] + "  " + stockInfoList[42] + "\n" +
    // stockInfoList[37] + "  " + stockInfoList[43] + "\n" +
    // stockInfoList[38] + "  " + stockInfoList[44] + "\n" + ;

    // for (int i = 2; i < stockInfoList.length; i++) {
    //   print(i.toString() + "  " + stockInfoList[i]);
    // }
    setState(() {
      stockContent = strStockInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _controller,
              onChanged: (text) {
                print("First text field: $text");
              },
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[0-9]")),
              ],
              decoration: InputDecoration(hintText: 'Enter a stock ID'),
            ),
            Text("$stockContent"),
            // DataTable(columns: [
            //   DataColumn(label: Text("Item")),
            //   DataColumn(label: Text("Value")),
            // ], rows: [
            //   DataRow(cells: [DataCell(Text("data")), DataCell(Text("aaa"))]),
            //   // DataRow(cells: [DataCell(Text("anson")), DataCell(Text('data'))]),
            // ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
