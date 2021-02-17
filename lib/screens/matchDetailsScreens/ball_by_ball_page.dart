import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';

///not in use currently u0coming feature

class BallByBallPage extends StatefulWidget {
  @override
  _BallByBallPageState createState() => _BallByBallPageState();
}

class _BallByBallPageState extends State<BallByBallPage> {

  List<String> forSix = [
    "Noice! Its a six",
    "Wow! There it is, a bigy"
  ] ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 6,vertical: 10),
        child: ListView(
          children: [
            oneBallDataWidget(),
            oneBallDataWidget(),
          ],
        ),
      ),
    );
  }

  List<Widget> everyBallData;

  Widget oneBallDataWidget({Ball ball}){

    SizedBox space = new SizedBox(width: 6,);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 0),
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white
          ),
          height: 48,
          child: Row(
            children: [
              Text("1.1"),
              // Text("${ball.currentOverNo}.${ball.currentBallNo}"),
              space,
              CircleAvatar(backgroundColor: Colors.blueAccent,child: Text("1"),),
              space,
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rupal to Shahrukh"),
                  Text("It's a four")
                ],
              )

            ],
          ),
        ),
        ///this is the line
        // ball.currentBallNo==1 && ball.currentOverNo==0?
        //     Container():
        Row(
          children: [
            SizedBox(width: 14,),
            Container(
              height: 12,
              width: 4,
              color: Colors.white,
            ),
          ],
        )
      ],
    );
  }

}
