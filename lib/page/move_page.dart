import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_home/widget/video_demo.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {

  final String beeUri;
  final String title;
  VideoPage({Key key,this.title,this.beeUri}) : super(key:key);
  static const String routeName = '/video';

  @override
  _VideoPageState createState() => _VideoPageState();
}

final DeviceInfoPlugin  deviceInfoPlugin = new DeviceInfoPlugin();

Future<bool> isIOSSimulator() async{
  return Platform.isIOS && !(await deviceInfoPlugin.iosInfo).isPhysicalDevice;
}



class _VideoPageState extends State<VideoPage> with SingleTickerProviderStateMixin{

  VideoPlayerController beeController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final Completer<Null> connectedCompleter = new Completer<Null>();
  bool isSupported = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    beeController = new VideoPlayerController.network(widget.beeUri);

  Future<Null> initController (VideoPlayerController controller) async{
    controller.setLooping(true);
    controller.setVolume(0.0);// 量卷
    controller.play();
    await connectedCompleter.future;
    await controller.initialize();
    setState(() {

    });
  }
  initController(beeController);
  isIOSSimulator().then((bool result){
    isSupported = !result;
  });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    beeController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: const Text('视频详情'),
      ),
      body: isSupported
            ? new ConnectivityOverlay(
        child: new VideoCard(
          title: widget.title,
          subtitle: '',
          controller: beeController,
        ),

        connectedCompleter: connectedCompleter,
        scaffoldKey: scaffoldKey,
      ):
          const Center(
            child: const Text('这个视频展示在ios上是不支持的'),
          )
    );
  }
}
