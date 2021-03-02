import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class BounceButton extends StatelessWidget {

  BounceButton({this.onPressed,this.btnText,this.btnWidth,this.iconData});
  final Function onPressed;
  final String btnText;
  double btnWidth;
  final IconData iconData;
    @override
  Widget build(BuildContext context) {
    return Container();
  }

  fabBtn(){

    if(btnWidth==null){
      btnWidth=double.infinity;
    }
    return Bounce(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey
        ),
        margin: EdgeInsets.only(left: 24,right:24,top: 10),
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 10),
        width: btnWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(btnText),
            iconData!=null?Icon(iconData):Container(),
          ],
        ),
      ),
    );
  }

}
