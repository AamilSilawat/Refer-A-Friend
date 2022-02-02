import 'dart:convert';
import 'dart:developer';
import 'dart:math' as pi;

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:referral_code_demo/Home/RewardScreen.dart';
import 'package:referral_code_demo/Reusable/AppTheme.dart';
import 'package:referral_code_demo/Reusable/GlobalFile.dart';
import 'package:referral_code_demo/Reusable/IconNames.dart';
import 'package:share_plus/share_plus.dart';

class Dashboard  extends StatefulWidget {


  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? _dynamicLink = "";
  var name = "";

  @override
  void initState() {
    super.initState();
    GET_FROM_DEFAULT(NAME).then((value){
      if(mounted){
        if(value != ""){
          setState(() {
            name = value;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyView(context),
    );
  }



  bodyView(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top:80.0,left: 20,right: 20),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
              child:GestureDetector(
                  onTap: (){
                    showLogoutDialog(context);
                  },
                  child: Image.asset(IconNames.logout_icon,height: 25,width: 25,))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Column(
                   children: [
                     const Text("Referral Selection",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                     const SizedBox(height: 20,),
                   ],
                 ),
               ],
             ),
            Text("Hey $name,",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            const Text("Why don't you introduce us to your friends?",style: const TextStyle(fontSize: 18),),
            const SizedBox(height: 20,),
            const Text("Invite a friend to invest an Bhive.fund and get a cashback equal to 1% of their investment",style: TextStyle(fontSize: 18),),
            const SizedBox(height: 40,),
            _referAFrnd(),
            const SizedBox(height: 20,),
            _refDashboard()
          ],
  ),
        ],
      ),
    );
  }

  shareLink(String link) {
    Share.share(link,subject: sub);
  }

  _generateDynamicLink() async {
    transactionRef = pi.Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");
    final DynamicLinkParameters params = DynamicLinkParameters(
      uriPrefix: "https://refcode.page.link/", // dynamic link without prefix
      link: Uri.parse("https://bhive.page.link/?refrenceCode=$transactionRef"), // created firebase dynamic link
      androidParameters: AndroidParameters(
          packageName: "com.referraldemo.referral_code_demo", minimumVersion: 0),
      iosParameters: IosParameters(
        bundleId: 'com.interiorse.sources',
        minimumVersion: '3.5',
        appStoreId: "",
        fallbackUrl: Uri.parse("https://apps.apple.com/us/app/sources-interior-shopping/id1551932587"),
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    Uri url;

    final ShortDynamicLink shortLink = await params.buildShortLink();
    url = shortLink.shortUrl;

    if (url != "") {
      setState(() {
        _dynamicLink = url.toString();
         shareLink(_dynamicLink.toString());
        // ToastHelper(_dynamicLink.toString(), context);
        log(_dynamicLink.toString());
      });
    }
  }

  Widget _referAFrnd() {
    return InkWell(
      onTap: () {
        _generateDynamicLink();
      },
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
          color: AppThemeStyle.mainColor(),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          'refer a friend'.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppThemeStyle.whiteColor(),
          ),
        ),
      ),
    );
  }



  Widget _refDashboard() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => RewardScreen()));
      },
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
          color: AppThemeStyle.mainColor(),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          'Referral Dashboard'.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppThemeStyle.whiteColor(),
          ),
        ),
      ),
    );
  }
}
