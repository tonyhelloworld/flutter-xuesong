import 'dart:_http';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:http/http.dart';


class VsersePage extends StatefulWidget {
  @override
  _VsersePageState createState() => new _VsersePageState();
}

class _VsersePageState extends State<VsersePage> {
  TextEditingController _controller = new TextEditingController();
  List<String> result = new List();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('为你写诗'),
      ),
     body: new Container(
       padding: const EdgeInsets.all(8.0),
       child: new Column(children: <Widget>[
         new Expanded(
             child: new Padding(
               padding: const EdgeInsets.all(18.0),
               child: new ListView.builder(itemBuilder: _buildItem),
             )
         ),
         new Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
             new Flexible(
                 child: new Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: new TextField(
                       controller: _controller,
                       maxLength: 8,
                       decoration: new InputDecoration(
                         hintText: '请输入文字吧'
                       ),
                     ),
                 )),
             new Container(
               margin: new EdgeInsets.symmetric(horizontal: 4.0),
               child: new IconButton(icon: new Icon(Icons.send),
               onPressed: (){
                 _generate();
               },
               ),
             )
           ],
         ),
       ],),
     ),
    );
  }

  // 生成藏头的诗
  void _generate() async{
    String text = Uri.encodeFull(_controller.text);
    String url =
        "http://route.showapi.com/950-1?showapi_appid=$showApiKey&showapi_sign=$showApiSecret&num=7&type=1&yayuntype=2&key=$text";
    var httpClient = new HttpClient();
    try{
      var req = await httpClient.getUrl(Uri.parse(url));
      var res = await req.close();
      if(res.statusCode == HttpStatus.OK){
        var jsonString = await res.transform(utf8.decoder).join();
        var jsonstr = json.decode(jsonString);
        if(jsonstr['showapi_res_body']['list'].length > 0){
          setState(() {
            this.result.clear();
            for(var value in jsonstr['showapi_res_body']['list']){// ??
              this.result.add(value);
            }
            _controller.clear();
            SystemChannels.textInput.invokeMethod('TextInput.hide');// ??
          });
        }else{
          _showError();
        }
      }

    }catch(exception){
      print('$exception');
      _showError();
    }
  }

  Widget _buildItem(BuildContext context, int index) {
  }

  void _showError() {
    showDialog(context: context,
       builder: (_)=> new AlertDialog(
         title: new Text('提示'),
         content: new Text('抱歉！你输入的${_controller.text}没有搜索到结果'),
       )
    );
  }
}
