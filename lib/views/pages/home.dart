import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:louseng/constants/colors.dart';
import 'package:louseng/controllers/firebaseMessaging.dart';
import 'package:louseng/data/models/family.dart';
import 'package:louseng/data/models/user.dart';
import 'package:louseng/data/provider/firebaseStorage.dart';
import 'package:louseng/views/components/title.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    initState() {
      refresh() {
        setState(() {});
      }

      Storage.homeview = refresh;

      Messaging.sendNotif(Family.current);
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.yellow, Colors.red])),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: MyTitle(title: "Let's stir the dish !"),
                ),
                Text(
                  "The dish has already been stired ${Family.current.n} times.",
                  style: TextStyle(
                      fontSize: 20, color: MyTheme.light.primaryColor),
                ),
                Text(
                  "Give this code to your family : ${Family.current.code}",
                  style: TextStyle(
                      fontSize: 20, color: MyTheme.light.primaryColor),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                  child: RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        Family.current.n++;

                        Family.current.members[User.current.index].n += 1;

                        Storage.write(Family.current);

                        Messaging.sendNotif(Family.current);
                      });
                    },
                    child: Image.asset("assets/louseng.jpg"),
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
}
