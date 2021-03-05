import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:umiperer/modals/size_config.dart';

class ShimmerContainer extends StatefulWidget {

  ShimmerContainer({this.height});
  double height;
  @override
  _ShimmerContainerState createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<ShimmerContainer> {

  SizedBox sizedBox = SizedBox(height: SizeConfig.setHeight(20),);
  BoxDecoration _boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(SizeConfig.setWidth(10)),
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          width: 100,
          padding: EdgeInsets.symmetric(
              horizontal: (10 * SizeConfig.oneW).roundToDouble(),
              vertical: (10 * SizeConfig.oneH).roundToDouble()),
          margin: EdgeInsets.symmetric(
              horizontal: (10 * SizeConfig.oneW).roundToDouble(),
              vertical: (10 * SizeConfig.oneH).roundToDouble()),
          decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12,width: 2)
          ),
          height: SizeConfig.setHeight(widget.height.toInt()),
        ),
      );
  }
}
