import 'package:umiperer/modals/constants.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

//media query r2d

class AboutUsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text("Made with ♥ at",style: TextStyle(fontSize: (SizeConfig.oneW*13).roundToDouble()),)),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: (6*SizeConfig.oneW).roundToDouble()),
                height: (SizeConfig.oneH*100).roundToDouble(),
                width: (SizeConfig.oneW*100).roundToDouble(),
                child: Image.asset('assets/images/aboutUs.png'),
              ),
            ),
            SizedBox(height: (SizeConfig.oneH*50).roundToDouble(),),
            Text("Contact us at :",style: TextStyle(fontSize:( SizeConfig.oneW*13).roundToDouble()),),
            TextButton(
              // padding: EdgeInsets.zero,
              onPressed: _launchEmail,
              child: Text(K_EMAIL,style: TextStyle(fontSize: (SizeConfig.oneW*13).roundToDouble()),),),
            // SizedBox(height: (SizeConfig.oneH*50).roundToDouble(),),
            // Text("CREDITS:"),
            // creditThing(webSiteName: "freepik",msg: "for free resources",url: "https://www.freepik.com/free-photos-vectors/study"),
            // creditThing(webSiteName: "BeFonts ",msg: "for free Fonts", url: "https://befonts.com/lot-font.html"),
          ],
        ),
      ),
    );
  }

  //credit thing for Freepik
  // creditThing({String webSiteName, String msg,String url}){
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Text("> Thanks ",style: TextStyle(fontSize: (SizeConfig.oneW*13).roundToDouble()),),
  //       TextButton(
  //         // padding: EdgeInsets.zero,
  //         onPressed: (){
  //           launchFreepikURL(url);
  //         },
  //         child: Text(webSiteName,style: TextStyle(fontSize: (SizeConfig.oneW*13).roundToDouble(),),),),
  //       Text(msg,style: TextStyle(fontSize: (SizeConfig.oneW*13).roundToDouble()),),
  //     ],
  //   );
  // }
  //
  // launchFreepikURL(String webUrl) async {
  //   final url = webUrl;
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  _launchEmail() async{
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: K_EMAIL,
      // queryParameters: {
      //   'subject': 'Example Subject & Symbols are allowed!'
      // }
    );
    launch(_emailLaunchUri.toString());
  }
}
