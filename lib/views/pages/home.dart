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
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  // Video
  var _controller = VideoPlayerController.asset('assets/video.mp4')
    ..initialize();

  // Time stamps
  var timeIndex = 0;
  final times = [
    4130,
    1970,
    1960,
    1960,
    1980,
    1200,
    1850,
    1170,
    1910,
    1150,
    1840,
    1140,
    1500,
    1100,
    1810,
    1150,
    1860,
    2250
  ];
  var cooldown = 500;

  var _now = DateTime.now();
  var showProgressBar = false;

  @override
  void initState() {
    // Storage service
    Storage.homeview = this;

    // Tell the family you're here !
    Messaging.sendNotif(Family.current, 'join');

    // Messaging service
    Messaging.start();

    // Progress bar service
    startTimeoutProgressBar();

    // First frames
    playVideo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: MyTheme.light.accentColor),
              onPressed: () {
                Get.back();
              },
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
                      Storage.refresh(false, '');
                    });
                  })
            ],
            bottom: TabBar(tabs: [
              Tab(
                  icon: Icon(
                Icons.home,
                color: MyTheme.light.accentColor,
              )),
              Tab(icon: Icon(Icons.group, color: MyTheme.light.accentColor))
            ]),
          ),
          body: TabBarView(
            children: [
              Container(
                height: Get.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/background.jpg"),
                        fit: BoxFit.cover)),
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
                            textAlign: TextAlign.center,
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
                        BorderedText(
                          child: Text(
                            "Swipe it up !",
                            style: TextStyle(
                                fontSize: 24, color: MyTheme.light.accentColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                          child: showProgressBar == true
                              ? LinearProgressIndicator(
                                  backgroundColor: Colors.red,
                                )
                              : Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                          child: Container(
                            width: Get.width * 0.9,
                            height: Get.width * 0.9,
                            child: GestureDetector(
                                onVerticalDragUpdate: (details) {
                                  if (details.delta.dy < 0) {
                                    Duration difference =
                                        DateTime.now().difference(_now);

                                    if (difference.inMilliseconds > cooldown) {
                                      if (timeIndex < 18) {
                                        Get.snackbar("The dish is stiring !",
                                            "You are stiring the dish",
                                            colorText:
                                                MyTheme.light.accentColor);
                                      } else {
                                        Get.snackbar("The dish is ready !",
                                            "You can't stir the dish anymore",
                                            colorText:
                                                MyTheme.light.accentColor);
                                      }

                                      setState(() {
                                        // Reset now
                                        _now = DateTime.now();

                                        startTimeoutProgressBar();

                                        // Increase counters
                                        Family.current.n++;
                                        Family.current
                                            .members[User.current.index].n += 1;

                                        // Refresh the db
                                        Storage.write(Family.current);

                                        // Send the notif
                                        Messaging.sendNotif(
                                            Family.current, 'stir');

                                        // Play the video
                                        playVideo();
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                    width: Get.width,
                                    height: Get.width,
                                    child: VideoPlayer(_controller))),
                          ),
                        ),
                        timeIndex >= 18
                            ? RaisedButton(
                                color: MyTheme.light.accentColor,
                                textColor: MyTheme.light.primaryColor,
                                onPressed: () {
                                  Get.defaultDialog(
                                      title: "Lucky Number",
                                      titleStyle: TextStyle(
                                          color: MyTheme.light.accentColor,
                                          fontSize: 30),
                                      backgroundColor:
                                          MyTheme.light.primaryColor,
                                      content: Text(
                                        Family.current.lucky,
                                        style: TextStyle(
                                            fontSize: 26,
                                            color: MyTheme.light.accentColor),
                                      ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Lucky number",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ))
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: Get.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/background.jpg"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Card(
                          elevation: 16,
                          child: Container(
                            height: Get.width,
                            width: Get.width - 40,
                            child: Center(
                                child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 36.0, bottom: 16),
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
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: Family.current.members.length,
                                    itemBuilder: (context, index) {
                                      final item =
                                          Family.current.members[index];

                                      return ListTile(
                                        title: Text(item.name,
                                            style: TextStyle(
                                                color:
                                                    MyTheme.light.primaryColor,
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Text(
                                            "Number of stir : ${item.n}",
                                            style: TextStyle(
                                                color: MyTheme
                                                    .light.primaryColor)),
                                      );
                                    },
                                  ),
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
                ),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  void playVideo() {
    if (timeIndex < 18) {
      print("NOTIF video");
      // Pause the video
      _controller.pause();
      // Start the video
      _controller.play();

      startTimeout(times[timeIndex]);

      timeIndex++;
    }
  }

  startTimeout(int t) {
    var duration = Duration(milliseconds: t);
    return new Timer(duration, handleTimeout);
  }

  void handleTimeout() {
    _controller.pause();
    if (timeIndex == 18) {
      Get.snackbar(
          "The dish is ready !", "You can now discover your lucky number !",
          colorText: MyTheme.light.accentColor);
    }
  }

  startTimeoutProgressBar() {
    setState(() {
      showProgressBar = true;
    });
    var duration = Duration(milliseconds: cooldown);
    print("time :" + duration.toString());
    return new Timer(duration, handleTimeoutProgressBar);
  }

  void handleTimeoutProgressBar() {
    setState(() {
      showProgressBar = false;
    });
  }
}
