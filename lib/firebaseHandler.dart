import 'package:academia/HttpRequest/notificationrequest.dart';
import 'package:academia/LocalRequest/localDatabase.dart';
import 'package:academia/layout/Forum/response.dart';
import 'package:academia/models/problems.dart';
import 'package:academia/models/response.dart';
import 'package:academia/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class MessageHandler extends StatefulWidget {
  final Widget child;
  MessageHandler({this.child});
  @override
  State createState() => MessageHandlerState();
}

class MessageHandlerState extends State<MessageHandler> {
  final FirebaseMessaging fm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Widget child;
  User currentUser;
  @override
  void initState() {
    super.initState();
    child = widget.child;
    onLoad();
    fm.requestNotificationPermissions();
    fm.configure(
      onMessage: (Map<String, dynamic> message) async {
        String screen = message['data']['screen'];
        if (screen == "RESPONSE") {
          _showNotification(
              message['data']['response'], message['data']['problem']);
        } else {
          //do nothing
        }
      },
      onResume: (Map<String, dynamic> message) async {
        String screen = message['data']['screen'];
        print("onMessageResume: $screen");
        if (screen == "RESPONSE") {
          var jsonResponse =
              convert.jsonDecode(message['data']['problem'].toString());
          Problems problem = Problems.fromJson(jsonResponse);
          navigateToResponseScreen(problem);
        } else {
          //do nothing
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onMessageLaunch: ${message['data']['screen']}");
        String screen = message['data']['screen'];
        if (screen == "RESPONSE") {
          var jsonResponse =
              convert.jsonDecode(message['data']['problem'].toString());
          Problems problem = Problems.fromJson(jsonResponse);
          navigateToResponseScreen(problem);
        } else {
          //do nothing
        }
      },
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_ecrite');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  onLoad() async {
    var queryRows = await DatabaseHelper.instance.user();
    currentUser = User.fromJson(queryRows[0]);

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    // Refresh Notifications Token
    String token = await fm.getToken();
    await prefs.setString('tokenfcm', token);
    await NotificationRequest.updateTokenFcm(token);
  }

  navigateToResponseScreen(problem) async {
    var queryRows = await DatabaseHelper.instance.user();
    currentUser = User.fromJson(queryRows[0]);
    Navigator.push(
        context,
        new PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                new ResponseScreen(currentUser, problem)));
  }

  Future onSelectNotification(String payload) {
    var jsonResponse2 = convert.jsonDecode(payload.toString());
    Problems problem = Problems.fromJson(jsonResponse2);
    return navigateToResponseScreen(problem);
  }

  Future<void> _showNotification(resp, prob) async {
    var jsonResponse = convert.jsonDecode(resp.toString());
    Responses response = Responses.fromJson(jsonResponse);
    var jsonResponse2 = convert.jsonDecode(prob.toString());
    Problems problem = Problems.fromJson(jsonResponse2);
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            '${response.idresponses}', 'response.fullname', 'response.content',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    if (response.idusers != currentUser.idusers) {
      await flutterLocalNotificationsPlugin.show(
          response.idresponses,
          '${response.fullname} @${problem.fullname}',
          response.content,
          platformChannelSpecifics,
          payload: prob);
    }
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
