import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  DateTime date = DateTime.now().subtract(Duration(days: 1));
  List list = [];
  DateFormat requestFormat = DateFormat('yyyyMMdd');
  DateFormat displayFormat = DateFormat('yyyy년 MM월 dd일');

  void load(DateTime date) async {
    setState((){
      list = [];
    });
    final String key = '0a7200568417cd813479269673833592';
    String url = 'https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json';
    url += '?key=$key';
    url += '&targetDt=${requestFormat.format(date)}';
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    setState(() {
      list = data['boxOfficeResult']['dailyBoxOfficeList'];
    });
  }

  @override
  void initState() {
    super.initState();
    load(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일간 박스 오피스'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RaisedButton(
                onPressed: (){
                  setState(() {
                    date = date.subtract(Duration(days:1));
                    load(date);
                  });
                },
                child: Text( '이전' ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(displayFormat.format(date)),
              ),
              RaisedButton(
                onPressed: (){
                  date = date.add(Duration(days:1));
                  load(date);
                },
                child: Text( '다음' ),
              ),
            ]
          ),
          Flexible(child: (
            ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () {
                      print( 'movie code : ${list[index]['movieCd']}');
                    },
                    child: Text('${list[index]['rnum']}위 ${list[index]['movieNm']}'),
                  ),
                );
              },
              itemCount: list.length,
            )
          ))
        ],
      ),
    );
  }
}
