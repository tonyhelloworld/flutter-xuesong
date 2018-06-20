import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_home/page/find_page.dart';
import 'package:flutter_home/page/plaza_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
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
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  SystemUiOverlayStyle overlayStyle = const SystemUiOverlayStyle(
    systemNavigationBarColor: const Color(0xffff0000),
    systemNavigationBarDividerColor: const Color(0xff00ff00),
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    statusBarColor: const Color(0x00000000),
    statusBarIconBrightness: Brightness.dark,
  );
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(icon: new Icon(Icons.email), title: new Text('广场')),
            new BottomNavigationBarItem(icon: new Icon(Icons.edit), title: new Text('发现'))
          ],
        currentIndex: _currentIndex,
        onTap: (index) {
            _currentIndex = index;
        },
      ),
      body:
      _setupCurrentPage(_currentIndex),
    );

  }

 Widget _setupCurrentPage(int currentIndex) {
    switch (_currentIndex){
      case 0: return new PlazaPage();
      case 1: return new FindPage();
      default: return new PlazaPage();
    }
 }



}
