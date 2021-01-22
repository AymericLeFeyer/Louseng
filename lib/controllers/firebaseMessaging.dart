import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:yeeSang/data/models/family.dart';
import 'package:yeeSang/data/models/user.dart';
import 'package:yeeSang/data/provider/firebaseStorage.dart';
import 'package:http/http.dart' as http;

class Messaging {
  static FirebaseMessaging messaging = FirebaseMessaging();

  static String serverToken =
      "AAAARBrkRKc:APA91bFZFGajdKSGyREEDhO9iKF0pL9F6Q1Ic56TAQxZlNBs5fP7fldrdMjNZL9yYP0TnRvp5a3fk6IgHTHszkvjkPuu4aFOvqkmHAa3goaZQQV5jMB7XMiQU1O5Dn_5hgYmXFxlWW31";

  static void start() async {
    await messaging.requestNotificationPermissions();

    Family.current.members[User.current.index].token =
        await messaging.getToken();

    Storage.write(Family.current);

    messaging.configure(onMessage: (Map<String, dynamic> message) async {
      print("NOTIF RECUE : ");
      String state = (message['data'])['id'].toString();
      Storage.refresh(state == 'stir' ? true : false);
    });
  }

  static void sendNotif(Family family, String type) async {
    for (User u in family.members) {
      if (u.token != User.current.token) {
        await http.post(
          'https://fcm.googleapis.com/fcm/send',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverToken',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': 'this is a body',
                'title': 'this is a title'
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': type,
                'status': 'done'
              },
              'to': u.token,
            },
          ),
        );
        print("NOTIF ENVOYEE à " + u.name);
      }
    }
  }
}
