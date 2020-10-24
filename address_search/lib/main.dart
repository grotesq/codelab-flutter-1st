import 'dart:convert';

import 'package:flutter/material.dart';
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = new TextEditingController();
  List list = [];

  void search( String keyword ) async {
    // GET 방식의 요청
    final String key = 'devU01TX0FVVEgyMDIwMTAyNDEwMTEwMDExMDMyNzI=';
    // String url = 'http://www.juso.go.kr/addrlink/addrLinkApi.do';
    // url += '?confmKey=$key'; // template 문법 `confmKey=${key}`
    // url += '&keyword=$keyword';
    // url += '&resultType=json';
    // url += '&countPerPage=100';
    // var response = await http.get(url);
    // var data = jsonDecode(response.body);

    // POST 방식의 요청
    final String url = 'http://www.juso.go.kr/addrlink/addrLinkApi.do';
    Map<String, String> params = {
      'confmKey': key,
      'keyword': keyword,
      'resultType': 'json',
      'countPerPage': '100',
    };
    var response = await http.post(url, body: params, headers: {
      'content-type': 'application/x-www-form-urlencoded'
    });
    var data = jsonDecode(response.body);
    setState(() {
      list = data['results']['juso'];
    });
    print('response : ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주소 검색기'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Flexible(
                  child: TextField( controller: controller,),
                ),
                RaisedButton(onPressed: (){
                  search(controller.text);
                }, child: Text('검색'))
              ],
            ),
            Flexible(child: (
              ListView.builder(
                itemBuilder: (BuildContext context, int index){
                  return (
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: (
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 3, right: 6),
                              child: Text('[${list[index]['zipNo']}] '),
                            ),
                            Flexible(child: (
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(list[index]['roadAddr']),
                                  Text(list[index]['jibunAddr']),
                                ],
                              )
                            ))
                          ]
                        )
                      )
                    )
                  );
                },
                itemCount: list.length,
              )
            ))
          ],
        ),
      ),
    );
  }
}
