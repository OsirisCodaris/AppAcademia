import 'dart:io';

import 'package:academia/Components/handleError.dart';
import 'package:academia/HttpRequest/updaterequest.dart';
import 'package:academia/layout/Documentation/documentation.dart';
import 'package:academia/layout/Update/doNotAsAgain.dart';
import 'package:academia/models/app_version.dart';
import 'package:academia/utils/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateApp extends StatefulWidget {
  final Widget child;

  UpdateApp({this.child});

  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  @override
  void initState() {
    super.initState();

    checkLatestVersion(context);
  }

  checkLatestVersion(context) async {
    try {
      AppVersion appVersion = await UpdateRequest.checkUpdate();
      Version minAppVersion = Version.parse(appVersion.minAppVersion);
      Version latestAppVersion = Version.parse(appVersion.version);

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      Version currentVersion = Version.parse(packageInfo.version);

      if (minAppVersion > currentVersion) {
        _showCompulsoryUpdateDialog(
          context,
          "Veuillez télécharger la nouvelle version pour continuer\n\n${appVersion.title}\n\n${appVersion.about ?? ""}",
        );
      } else if (latestAppVersion > currentVersion) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        bool showUpdates = false;
        showUpdates =
            sharedPreferences.getBool('academia${appVersion.idappversions}');
        if (showUpdates != null && showUpdates == false) {
          return;
        }

        _showOptionalUpdateDialog(
            context,
            "Une nouvelle version est disponible\n${appVersion.about ?? ""}",
            'academia${appVersion.idappversions}');
      } else {}
    } catch (e) {
      HandleError.buildError(context, e).then((r) {
        checkLatestVersion(context);
      });
    }
  }

  _showOptionalUpdateDialog(context, String message, String keyUpdate) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        String title = "Mise à Jour Disponible";
        String btnLabel = "Mettre à jour";
        String btnLabelCancel = "Plus tard";
        String btnLabelDontAskAgain = "Ne plus afficher ce message";
        return DoNotAskAgainDialog(
          keyUpdate,
          title,
          message,
          btnLabel,
          btnLabelCancel,
          _onUpdateNowClicked,
          doNotAskAgainText: Platform.isIOS
              ? btnLabelDontAskAgain
              : 'Ne plus afficher ce message',
        );
      },
    );
  }

  _onUpdateNowClicked() async {
    if (await canLaunch(Url.UPDATE_APP_URL)) {
      await launch(Url.UPDATE_APP_URL);
    } else {
      Navigator.of(context).pop(false);
    }
  }

  _showCompulsoryUpdateDialog(context, String message) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "Mise à jour Disponible";
        String btnLabel = "Mettre à jour";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      btnLabel,
                    ),
                    isDefaultAction: true,
                    onPressed: _onUpdateNowClicked,
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(
                  title,
                  style: TextStyle(fontSize: 22),
                ),
                content: FittedBox(fit: BoxFit.cover, child: Text(message)),
                actions: <Widget>[
                  RaisedButton(
                      onPressed: _onUpdateNowClicked,
                      color: Theme.of(context).primaryColor,
                      child: Text(btnLabel)),
                ],
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
