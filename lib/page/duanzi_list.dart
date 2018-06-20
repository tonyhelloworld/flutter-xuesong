import 'dart:io';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home/config.dart';
import 'package:flutter_home/model/duanzi_model.dart';
import 'package:flutter_home/page/image_detail.dart';
import 'package:flutter_home/widget/utils.dart';

class DuanZiList extends StatefulWidget {
  @override
  _DuanZiListState createState() => _DuanZiListState();
}

class _DuanZiListState extends State<DuanZiList> {
  
  List<DuanziModel> mDatas = new List();
  var page = 1;
  var type = '';
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDuanziList();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new GestureDetector(
            onTap: _onTypeSelected,
            child: new Padding(
                padding: const EdgeInsets.all(18.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text('段子类型', style: new TextStyle(fontSize: 18.0),),
                  new Text(_getType(),style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
                ],
              ),
            ),
          ),
          new Divider(),
          new Flexible(
              flex: 1,
              child: new Container(
                padding: const EdgeInsets.all(8.0),
                child: new ListView.builder(itemBuilder: _buildDuanziList, itemCount: mDatas.length,),
              ))
        ],
      ),
    );
  }
  Widget _buildDuanziList(BuildContext context,int index){
    DuanziModel duanziModel = mDatas[index];
    if(index == mDatas.length - 1) {
      setState(() {
        this.page = this.page +1;
        _getDuanziList();
      });
    }
    switch(duanziModel.type){
      case '10': return _buildPicItem(duanziModel);
      case '29': return _buildPicItem(duanziModel);
      case '31': return _buildPicItem(duanziModel);
      case '41': return _buildPicItem(duanziModel);
      default: return new Text('错误类型');
    }
  }
  Widget _buildPicItem(duanziModel) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new Padding(padding: const EdgeInsets.all(8.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Expanded(child: new Text(duanziModel.text),
                ),
                new Container(
                  child: new GestureDetector(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(builder: (context)=>new ImageDetail(image: duanziModel.image0,)));
                    },
                    child: new CachedNetworkImage(
                      errorWidget: new Icon(Icons.error),
                      fadeOutDuration: new Duration(seconds: 1),
                      fadeInDuration: new Duration(seconds: 3),
                      imageUrl: duanziModel.image0,
                      width: 130.0,
                      height: 130.0,
                      fit: BoxFit.cover,// ?????
                    ),
                  ),
                )
              ],
            )

            ,),
          new Divider(),
          _buildItemBottom(duanziModel),
        ],
      ),
    );
  }

  void _getDuanziList() async{
    if(page == 1){
      showLoading(context);
    }
    var httpClient = new HttpClient();
    var url = 'http://route.showapi.com/255-1?showapi_appid=$showApiKey&showapi_sign=$showApiSecret&type=$type&page=$page';

    try{
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if(response.statusCode == HttpStatus.OK){
        var jsonString = await response.transform(utf8.decoder).join();
        var data = json.decode(jsonString);
        List duanList = data['showapi_res_body']['pagebean']['contentlist'];
        List<DuanziModel> list = new List();
        for (var value in duanList){
          list.add(new DuanziModel.fromJson(value));
        }

        if(list.length !=0){
          setState(() {
            if(page == 1){
              Navigator.pop(context);// 隐藏loading
              mDatas = list;
            }else{
              mDatas.addAll(list);
            }
          });
        }
      }
    }catch(exception){
      print(exception);
    }
  }

  // 选择段子类型
  void _onTypeSelected() {
    showModalBottomSheet(context: context, builder:
    (BuildContext context){
      return new Container(
        padding: const EdgeInsets.all(8.0),
        child: new ListView(
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.select_all),
              title: new Text('全部'),
              onTap: (){
                _onSelectedTpye('');
              },
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.picture_in_picture),
              title: new Text('文本'),
              onTap: (){
                _onSelectedTpye('29');
              },
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.picture_in_picture),
              title: new Text('图片'),
              onTap: (){
                _onSelectedTpye('10');
              },
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.picture_in_picture),
              title: new Text('声音'),
              onTap: (){
                _onSelectedTpye('31');
              },
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.picture_in_picture),
              title: new Text('视频'),
              onTap: (){
                _onSelectedTpye('41');
              },
            )
          ],
        ),
      );
    }
    );
  }

  Row _buildItemBottom(duanziModel) {
    return  new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Row(children: <Widget>[
          new Container(
            width:  35.0,
            height: 35.0,
            padding: const EdgeInsets.all(8.0),
            child: new CircleAvatar(
              backgroundImage: new NetworkImage(duanziModel.userIcon),
            ),
          ),
          new Padding(padding: const EdgeInsets.only(left: 8.0),child: new Text(duanziModel.userName),)

        ],),
        new Row(
          children: <Widget>[
            new Icon(Icons.thumb_up,size: 14.0,),
            new Padding(padding: const EdgeInsets.only(left: 8.0),child: new Text(duanziModel.love),),
            new Padding(padding: const EdgeInsets.only(left: 8.0),child: new Icon(Icons.thumb_down,size: 14.0,),),
            new Padding(padding: const EdgeInsets.only(left: 8.0,right: 8.0),child: new Text(duanziModel.hate),)
          ],
        )
      ],
    );
  }

  void _onSelectedTpye(String s) {
    setState(() {
      this.page = 1;
      this.type = s;
      _getDuanziList();
    });
    Navigator.pop(context);
  }
  String _getType(){
    switch(this.type) {
      case '10': return '图片';
      case '29': return '文本';
      case '31': return '声音';
      case '41': return '视频';
      default: return '全部';
    }
  }


}
