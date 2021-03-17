import 'package:flutter/material.dart';
import 'package:umiperer/modals/size_config.dart';

class LoadingProgressWidget extends StatelessWidget {
  const LoadingProgressWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loadingGif(),
    );
  }

  ///when async tasks are performed, this loadingGif
  ///is shown in bottom to restrict users from performing
  ///further action
  Widget loadingGif() {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/gifs/bounce.gif',
            // gifPaths[3],
            height: (180 * SizeConfig.oneH).roundToDouble(),
            width: (180 * SizeConfig.oneW).roundToDouble(),
          ),
          Text(
            "Updating Data..",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          )
        ],
      ),
    );
  }
}
