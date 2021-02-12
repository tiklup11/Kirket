import 'package:flutter/material.dart';
import 'package:umiperer/modals/size_config.dart';

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular((20*SizeConfig.oneW).roundToDouble()),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child:
        Expanded(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((8*SizeConfig.oneW).roundToDouble()),
                // color: Colors.white
            ),
            child:Center(child: CircularProgressIndicator(),),
          ),
        )
    );
  }
}
