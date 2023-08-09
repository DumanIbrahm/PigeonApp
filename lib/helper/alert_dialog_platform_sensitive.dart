import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_app/helper/platform_sensitive.dart';
import 'package:pigeon_app/palette.dart';

class AlertDialogPlatformSesitive extends PlatformSensitiveWidget {
  final String title;
  final String content;
  final String defaultActionText;
  final String? cancelActionText;

  const AlertDialogPlatformSesitive(
      {super.key,
      required this.title,
      required this.content,
      required this.defaultActionText,
      this.cancelActionText});

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: dialogButton(context),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))));
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      actions: dialogButton(context),
    );
  }

  List<Widget> dialogButton(BuildContext context) {
    final list = <Widget>[];

    if (Platform.isIOS) {
      if (cancelActionText != null) {
        list.add(CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelActionText!,
            style: TextStyle(color: Pallete.buttonColor),
          ),
        ));
      }
      list.add(CupertinoDialogAction(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(defaultActionText,
            style: TextStyle(color: Pallete.buttonColor)),
      ));
    } else {
      if (cancelActionText != null) {
        list.add(TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelActionText!,
              style: TextStyle(color: Pallete.buttonColor)),
        ));
      }
      list.add(TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(defaultActionText,
            style: TextStyle(color: Pallete.buttonColor)),
      ));
    }
    return list;
  }

  Future<bool?> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
          );
  }
}
