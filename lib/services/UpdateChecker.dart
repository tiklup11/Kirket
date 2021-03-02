import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:umiperer/modals/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker{

  UpdateChecker({this.context});

  BuildContext context;
  String playStoreUrl = PLAY_STORE_URL;
  double _currentVersionOnApp;
  double _latestAppVersion;

  void _setCurrentBuildNo(double value){
    _currentVersionOnApp = value;
  }

  void _setLatestBuildNo(double value){
    _latestAppVersion=value;
  }

  _showUpdateDialog(){
    if (_latestAppVersion > _currentVersionOnApp) {
      _showVersionDialog(context);
    }
  }

  check(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentBuildNo = double.parse(info.buildNumber.trim().replaceAll(".", ""));

    _setCurrentBuildNo(currentBuildNo);

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('force_update_current_version');

      double newVersion = double.parse(remoteConfig
          .getString('force_update_build_no'));

      _setLatestBuildNo(newVersion);

      print(newVersion);
      print(currentBuildNo);

      _showUpdateDialog();

    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There are some issues in this version. Please update. If you don't see update option, First uninstall and then install.";
        String btnLabel = "Update Now";
        // String btnLabelCancel = "Later";
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => _launchOnPs(PLAY_STORE_URL),
            ),
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => _launchOnPs(PLAY_STORE_URL),
            ),
          ],
        );
      },
    );
  }

  _launchOnPs(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}