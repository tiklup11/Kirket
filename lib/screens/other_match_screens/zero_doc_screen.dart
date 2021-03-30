import 'package:flutter/material.dart';

class ZeroDocScreen extends StatelessWidget {
  ZeroDocScreen(
      {this.iconData, this.textMsg, this.showLearnMore, this.dialogText});

  final String textMsg;
  final IconData iconData;
  bool showLearnMore;
  final String dialogText;

  @override
  Widget build(BuildContext context) {
    if (showLearnMore == null) {
      showLearnMore = false;
    }

    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 120,
              color: Colors.black26,
            ),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                textMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black38),
              ),
            ),
            showLearnMore
                ? TextButton(
                    onPressed: () {
                      showLearnModeDialog(context);
                    },
                    child: Text(
                      "Learn More",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }

  showLearnModeDialog(context) async {
    await showDialog<String>(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "Note";
        String message = dialogText;
        String btnLabel = "Okays";
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child:
                  Text(btnLabel, style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
