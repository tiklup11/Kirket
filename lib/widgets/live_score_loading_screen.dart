import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:umiperer/modals/size_config.dart';

class LiveScoreLoadingFullPage extends StatefulWidget {
  @override
  _LiveScoreLoadingFullPageState createState() => _LiveScoreLoadingFullPageState();
}

class _LiveScoreLoadingFullPageState extends State<LiveScoreLoadingFullPage> {

  SizedBox sizedBox = SizedBox(height: SizeConfig.setHeight(20),);
  BoxDecoration _boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(SizeConfig.setWidth(10)),
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.setWidth(16), vertical: SizeConfig.setHeight(16)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.setHeight(260),
                    decoration: _boxDecoration,
                    ),
                  sizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(height: SizeConfig.setHeight(80),
                        width: SizeConfig.setWidth(250),
                        decoration: _boxDecoration,
                      ),
                      SizedBox(width: SizeConfig.setWidth(10),),
                      Container(height: SizeConfig.setHeight(80),
                        width: SizeConfig.setWidth(100),
                        decoration: _boxDecoration,
                      ),
                    ],
                  ),
                  sizedBox,
                  Container(
                    height: SizeConfig.setHeight(260),
                    decoration: _boxDecoration,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
