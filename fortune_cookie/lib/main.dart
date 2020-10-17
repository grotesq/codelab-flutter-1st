import 'package:flutter/material.dart';

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
      home: FortuneCookie(),
    );
  }
}

class FortuneCookie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FortuneCookieState();
  }
}

class FortuneCookieState extends State<FortuneCookie> {
  var url = 'https://www.astrology.com/images-US/games/game-fortune-cookie-1.png';
  var messages = [
    '기다리던 일이 오늘 이루어질 것입니다.',
    '건강에 유의하고 외출을 삼가세요',
    '발 밑을 조심하세요!',
    '금전운이 있을 날입니다',
    '반가운 연락이 오는 날입니다',
    '행운의 색은 핑크색이에요!',
  ];
  shuffle() {
    setState(() {
      messages.shuffle();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: shuffle,
              child: Image.network(url),
            ),
            Text(messages[ 0 ])
          ]
        )
      )
    );
  }
}
