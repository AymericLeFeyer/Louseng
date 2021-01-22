import 'dart:async';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:yeeSang/constants/colors.dart';
import 'package:yeeSang/controllers/firebaseMessaging.dart';
import 'package:yeeSang/data/models/family.dart';
import 'package:yeeSang/data/models/user.dart';
import 'package:yeeSang/data/provider/firebaseStorage.dart';
import 'package:yeeSang/views/components/title.dart';
import 'package:video_player/video_player.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  var _controller = VideoPlayerController.asset('assets/video.mp4')
    ..initialize();

  var _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    initState() {
      refresh() {
        setState(() {});
      }

      Storage.homeview = refresh;

      Messaging.sendNotif(Family.current);

      super.initState();
    }

    Messaging.start();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.light.accentColor),
          onPressed: () => Get.back(),
          tooltip: "Back to home",
        ),
        title: Text(
          "Yee Sang",
          style: TextStyle(color: MyTheme.light.accentColor),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: MyTheme.light.accentColor,
              ),
              tooltip: "Manually refresh",
              onPressed: () {
                setState(() {
                  Storage.refresh();
                });
              })
        ],
      ),
      body: Container(
        height: Get.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.jpg"), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: MyTitle(title: "Let's Lou Yee Sang !"),
                ),
                MyTitle(title: "HUAT AH!"),
                BorderedText(
                  strokeWidth: 5,
                  child: Text(
                    "The dish has already been stired ${Family.current.n} times.",
                    style: TextStyle(
                        fontSize: 20, color: MyTheme.light.accentColor),
                  ),
                ),
                BorderedText(
                  child: Text(
                    "Give this code to your family : ${Family.current.code}",
                    style: TextStyle(
                        fontSize: 20, color: MyTheme.light.accentColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                  child: Container(
                    width: Get.width,
                    height: Get.width,
                    child: RawMaterialButton(
                        onPressed: () {
                          Duration difference = DateTime.now().difference(_now);

                          if (difference.inMilliseconds > 1000) {
                            setState(() {
                              // Reset now
                              _now = DateTime.now();

                              // Increase counters
                              Family.current.n++;
                              Family.current.members[User.current.index].n += 1;

                              // Refresh the db
                              Storage.write(Family.current);

                              // Send the notif
                              Messaging.sendNotif(Family.current);

                              // Play the video
                              playVideo();
                            });
                          }
                        },
                        child: VideoPlayer(_controller)),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Center(
                      child: Card(
                        elevation: 16,
                        child: Container(
                          width: Get.width - 40,
                          child: Center(
                              child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 36.0),
                                    child: Text(
                                      "${Family.current.members.length} joined",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: MyTheme.light.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: Family.current.members.length,
                                itemBuilder: (context, index) {
                                  final item = Family.current.members[index];

                                  return ListTile(
                                    title: Text(item.name,
                                        style: TextStyle(
                                            color: MyTheme.light.primaryColor,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text("Number of stir : ${item.n}",
                                        style: TextStyle(
                                            color: MyTheme.light.primaryColor)),
                                  );
                                },
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                    FractionalTranslation(
                      translation: Offset(0.0, -0.4),
                      child: Align(
                        child: CircleAvatar(
                          radius: 25.0,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          backgroundColor: MyTheme.light.primaryColor,
                        ),
                        alignment: FractionalOffset(0.5, 0.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  void playVideo() {
    // Pause the video
    _controller.pause();
    // Start the video
    _controller.play();
    startTimeout();
  }

  startTimeout() {
    var duration = const Duration(seconds: 1);
    return new Timer(duration, handleTimeout);
  }

  void handleTimeout() {
    _controller.pause();
  }
}
