import 'package:flutter/material.dart';
import 'package:umiperer/modals/size_config.dart';

class GifLoader extends StatelessWidget {
  GifLoader({this.runKey});

  final String runKey;

  List<String> loadingWinGifs = [
    "assets/gifs/win.gif",
  ];

  @override
  Widget build(BuildContext context) {
    return loadingGif();
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
            loadingWinGifs[0],
            // gifPaths[3],
            height: (190*SizeConfig.oneH).roundToDouble(),
            width: (190*SizeConfig.oneW).roundToDouble(),
          ),
          Text(
            "Updating Data..",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 15),
          )
        ],
      ),
    );
  }
}
