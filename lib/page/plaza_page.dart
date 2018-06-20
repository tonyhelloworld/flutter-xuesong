import 'package:flutter/material.dart';
import 'package:flutter_home/page/douban_move_list.dart';
import 'package:flutter_home/page/duanzi_list.dart';

class PlazaPage extends StatefulWidget {
  @override
  _PlazaPageState createState() => _PlazaPageState();
}

class _PlazaPageState extends State<PlazaPage> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: new AppBar(
            title: new TabBar(
              tabs: [new Text('豆瓣电影'),new Text('各种段子')],
              indicatorSize: TabBarIndicatorSize.label,// 指示器的大小
              indicatorWeight: 1.0,
            ),
          ),
          body: new TabBarView(
              children: [new DoubanMoveList(),new DuanZiList(),]
          ),
        )
    );
  }
}
