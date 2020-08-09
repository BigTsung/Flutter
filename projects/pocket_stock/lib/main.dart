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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  Future<void> _incrementCounter() async {
    // setState(() async {
    print("anson");
    print(_controller.text);

    // var url = 'https://goodinfo.tw/StockInfo/StockDetail.asp?STOCK_ID=0050';
    var url = 'https://goodinfo.tw/StockInfo/StockDetail.asp?STOCK_ID=' +
        _controller.text;
    var response = await http.get(url);

    List<int> bytes = response.bodyBytes;
    String result = convert.utf8.decode(bytes);

    print(result);

    // var soup = Beautifulsoup(result);
    // var tables = soup.find_all("table").map((e) => (e.outerHtml)).toList();
    // print(tables);

    // print(soup.find_all("table").map((e) => (e.outerHtml)).toList());
    // print(soup("title").outerHtml);
    // print(soup("a").outerHtml); //soup.a
    // print(soup("table").attributes["class"]);
    // print(soup.get_text()); //soup.get_text()
    // print(soup.find_all("table").map((e) => soup.attr(e, "class")).toList());
    // print(soup.find(id: "#solid_1_padding_3_1_tbl"));
    // print(soup("table").attributes["class"]);
    // var table = soup.find();

    // print(soup);
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
              decoration: InputDecoration(hintText: 'Enter a search stock ID'),
            ),
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
