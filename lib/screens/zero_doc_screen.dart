import 'package:flutter/material.dart';

class ZeroDocScreen extends StatelessWidget {

  ZeroDocScreen({this.iconData,this.textMsg});

  final String textMsg;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Container(
        child:Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData),
              SizedBox(height: 4,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(textMsg,textAlign: TextAlign.center,),
              )
            ],
          ),
        ),
    );
  }
}
