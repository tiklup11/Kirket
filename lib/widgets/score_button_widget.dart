import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/modals/size_config.dart';

class ScoreButton extends StatelessWidget {

  ScoreButton({this.onPressed,this.btnText});

  final Function onPressed;
  final String btnText;

  final double btnHeight=SizeConfig.setHeight(40);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Bounce(
        duration: Duration(milliseconds: 140),
        onPressed: onPressed,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: SizeConfig.setHeight(6),horizontal: SizeConfig.setWidth(1)),
            padding: EdgeInsets.symmetric(vertical: SizeConfig.setHeight(10)),
            decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12,width: 2)
            ),
            // height: btnHeight,
            child: Center(child: Text(btnText))),
      ),
    );
  }

}
