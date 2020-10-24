import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
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
  bool loaded = false;

  void load(DateTime date) async {
    setState((){
      list = [];
      loaded = false;
    });
    final String key = '0a7200568417cd813479269673833592';
    String url = 'https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json';
    url += '?key=$key';
    url += '&targetDt=${requestFormat.format(date)}';
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    setState(() {
      list = data['boxOfficeResult']['dailyBoxOfficeList'];
      loaded = true;
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
          ( loaded ? Container() : Container(
            padding: EdgeInsets.all(96),
            alignment: Alignment.center,
            child: CircularProgressIndicator()
          ) ),
          Flexible(child: (
            ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MovieDetail(list[index]['movieCd'])),
                      );
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

class MovieDetail extends StatefulWidget {
  String code;
  MovieDetail( String code ) {
    this.code = code;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MovieDetailState();
  }
}

class MovieDetailState extends State<MovieDetail> {
  var movie;

  void load() async {
    final String key = '0a7200568417cd813479269673833592';
    String url = 'https://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json';
    url += '?key=$key';
    url += '&movieCd=${widget.code}';
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    print( 'data : $data');
    setState(() {
      movie = data;
    });
  }

  @override
  void initState() {
    super.initState();
    load();
    print(widget.code);
  }
  @override
  Widget build(BuildContext context) {
    if( movie == null ) {
      return Scaffold(
        body: Center(
          child: (
            CircularProgressIndicator()
          ),
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('영화 상세 정보'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('제목 : ${movie['movieInfoResult']['movieInfo']['movieNm']}'),
          Text('상영시간 : ${movie['movieInfoResult']['movieInfo']['showTm']}분'),
          Flexible( child: (
            ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                if( index == 0 ) {
                  return Text( '출연 :');
                }
                List actors = movie['movieInfoResult']['movieInfo']['actors'];
                return (
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>PeopleList(actors[index-1]['peopleNm']))
                      );
                    },
                    child: Text('${actors[index-1]['peopleNm']}')
                  )
                );
              },
              separatorBuilder: (BuildContext context, int index) => Text(' '),
              itemCount: min(movie['movieInfoResult']['movieInfo']['actors'].length, 7)
            )
          ))
        ],
      )
    );
  }
}

class PeopleList extends StatefulWidget {
  String name;
  PeopleList(String name) {
    this.name = name;
  }

  @override
  State<StatefulWidget> createState() {
    return PeopleListState();
  }
}

class PeopleListState extends State<PeopleList> {
  List list = [];

  void load() async {
    final String key = '0a7200568417cd813479269673833592';
    String url = 'https://www.kobis.or.kr/kobisopenapi/webservice/rest/people/searchPeopleList.json';
    url += '?key=$key';
    url += '&peopleNm=${widget.name}';
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    setState(() {
      list = data['peopleListResult']['peopleList'];
    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text( '영화인 검색 결과' ), ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index ) {
          return (
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PeopleDetail(list[index]['peopleCd']))
                );
              },
              child: (
                Padding(
                  padding: EdgeInsets.all(12),
                  child: (
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( list[index]['peopleNm'] ),
                        Text( '대표작 : ${list[index]['filmoNames']}' ),
                      ],
                    )
                  )
                )
              )
            )
          );
        },
        itemCount: list.length,
      )
    );
  }
}

class PeopleDetail extends StatefulWidget {
  String code;

  PeopleDetail(String code) {
    this.code = code;
  }

  @override
  State<StatefulWidget> createState() {
    return PeopleDetailState();
  }
}

class PeopleDetailState extends State<PeopleDetail> {
  var people;

  void load() async {
    final String key = '0a7200568417cd813479269673833592';
    String url = 'https://www.kobis.or.kr/kobisopenapi/webservice/rest/people/searchPeopleInfo.json';
    url += '?key=$key';
    url += '&peopleCd=${widget.code}';
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    setState(() {
      people = data['peopleInfoResult']['peopleInfo'];
    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    if( people == null ) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator()
        )
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('영화인 상세 조회')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이름 : ${people['peopleNm']}'),
          Text('성별 : ${people['sex']}'),
          Text('역할 : ${people['repRoleNm']}'),
        ],
      )
    );
  }
}
