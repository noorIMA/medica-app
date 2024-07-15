import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  triggerNotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: "basic_channel",
            title: "Hello",
            body: "amani"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: triggerNotification,
          child: Text('Send Message'),
        ),
      ),
    );
  }
}
