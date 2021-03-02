import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class NextOverButton extends StatelessWidget {

  NextOverButton({this.onPressed,this.bowlerName});

  final String bowlerName;

  final Function(String bowlerName) onPressed;
  @override
  Widget build(BuildContext context) {

    return Bounce(
        onPressed: (){
          onPressed(bowlerName);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.blueGrey,
              ),
              child: Center(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Next Over"),
                  Icon(Icons.arrow_forward,size: 18,)
                ],
              )),
            ),
          ],
        )
    );
  }
}
