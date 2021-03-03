import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return backBtn();
  }

  backBtn(){
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
