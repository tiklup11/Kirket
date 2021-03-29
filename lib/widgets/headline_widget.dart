import 'package:flutter/material.dart';
import 'package:umiperer/modals/size_config.dart';

class HeadLineWidget extends StatelessWidget {
  HeadLineWidget({this.headLineString});

  final String headLineString;

  @override
  Widget build(BuildContext context) {
    return headLine(headLineString: headLineString);
  }

  headLine({String headLineString}) {
    return Container(
      margin: EdgeInsets.only(top: (10 * SizeConfig.oneH).roundToDouble()),
      padding: EdgeInsets.only(
        left: (16 * SizeConfig.oneW).roundToDouble(),
      ),
      child: Text(
        headLineString.toUpperCase(),
        maxLines: 2,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black38),
      ),
    );
  }
}
