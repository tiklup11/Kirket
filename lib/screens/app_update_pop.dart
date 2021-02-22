import 'package:flutter/material.dart';

class AppUpdateDialog extends StatefulWidget {
  @override
  _AppUpdateDialogState createState() => _AppUpdateDialogState();
}

class _AppUpdateDialogState extends State<AppUpdateDialog> {

  executeAfterBuild(BuildContext context){
    showAlertDialog(context: context);
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_)
    {
      executeAfterBuild(context);
    }
    );


    return Scaffold(
        appBar: AppBar(title: Text("Update"),),
        body: Container());
  }

  showAlertDialog({BuildContext context}) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget logoutButton = TextButton(
      child: Text("Update"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Update"),
      content: Text("Please Update App"),
      actions: [
        cancelButton,
        logoutButton,
      ],
    );
  }
}

