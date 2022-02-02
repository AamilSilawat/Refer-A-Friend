import 'dart:async';
import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:referral_code_demo/Home/Dashboard.dart';
import 'package:referral_code_demo/Reusable/GlobalFile.dart';
import 'package:referral_code_demo/Reusable/IconNames.dart';
import 'package:referral_code_demo/Authentication/SignInScreen.dart';

class SplashScreen  extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1800), vsync: this, value: 0.4)
      ..addListener(() {
        setState(() {});
      });
    _animation =
        CurvedAnimation(parent: _controller!, curve: Curves.easeOutQuad);

    _controller!.forward();
    moveUserToScreen();
    initDynamicLinks();
  }

  moveUserToScreen()async{
    var logInStatus = await GET_FROM_DEFAULT(isLogIn);
    if(logInStatus == "true"){
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => Dashboard()),
                (route) => false);
      });
    }else{
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => SigninScreen(fromDynamicLink: false,referenceCode: "",)),
                (route) => false);
      });
    }

  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void initDynamicLinks() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
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

    final Uri dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink dynamicShortUrl = await parameters.buildShortLink();

    log("Dynamic Link Path----->${dynamicUrl.path}");
    log("Dynamic Short Link Path----->${dynamicShortUrl.shortUrl.path}");

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          final Uri? deepLink = dynamicLink?.link;

          if (deepLink != null) {
            handleLinkData(dynamicLink);
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      handleLinkData(data);
    }
  }

  void handleLinkData(PendingDynamicLinkData? data) {
    final Uri? uri = data?.link;
    if (uri != null) {
      log("Url---->$uri");
      final queryParams = uri.queryParameters;
      // ToastHelper(queryParams.toString(), context);
      if (queryParams.length > 0) {
        if (queryParams.containsKey("refrenceCode")) {
          String? refCode = queryParams["refrenceCode"];
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                  builder: (context) => SigninScreen(
                    fromDynamicLink: true,
                    referenceCode: refCode,
                  )),
                  (route) => false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.white,
        child: Center(
          child: ScaleTransition(
            scale: _animation!,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*Image.asset(
                  IconNames.final_appIcon,
                  height: 90,
                  width: 90,
                ),*/
                Image.asset(IconNames.logo,height: 200,width: 200,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
