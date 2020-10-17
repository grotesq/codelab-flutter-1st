import 'dart:math';

import 'package:flutter/material.dart';

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
      home: ThanosClick(),
    );
  }
}

class ThanosClick extends StatefulWidget {
  @override
  ThanosClickState createState() {
    return ThanosClickState();
  }
}

class ThanosClickState extends State<ThanosClick> {
  int result;

  @override
  void initState() {
    super.initState();

    result = new Random().nextInt(2);
  }

  renderResult() {
    if( result == null ) {
      return Text( '' );
    }
    else if( result == 0 ) {
      return Text( '당신은 우주의 균형을 위해 먼지가 되었습니다.' );
    }
    else {
      return Text( '당신은 살아남았습니다.' );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( title: Text( '타노스가 손가락을 튕겼습니다' ) ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text( '딱!', style: TextStyle( fontSize: 96, fontWeight: FontWeight.bold ), ),
                renderResult(),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      result = new Random().nextInt(2);
                    });
                  },
                  child: Text('타임스톤으로 시간 되돌리기'),
                )
              ],
            )
        )
    );
  }
}
