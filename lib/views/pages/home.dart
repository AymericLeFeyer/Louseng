import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:louseng/data/models/family.dart';
import 'package:louseng/data/models/user.dart';
import 'package:louseng/data/provider/firebaseStorage.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Louseng"),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  Storage.refresh();
                });
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Let's stir the dish !",
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "The dish has already been stired ${Family.current.n} times.",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Click on it to stir it more !",
              style: TextStyle(fontSize: 20),
            ),
            RawMaterialButton(
              onPressed: () {
                setState(() {
                  Family.current.n++;

                  Family.current.members[User.current.index].n += 1;

                  Storage.write(Family.current);
                });
              },
              child: Image.asset("assets/louseng.jpg"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Dish code : ${Family.current.code}",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "${Family.current.members.length} connected",
                  style: TextStyle(fontSize: 16),
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
                  title: Text(item.name),
                  subtitle: Text("Number of stir : ${item.n}"),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
