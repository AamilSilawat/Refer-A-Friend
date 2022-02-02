import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:referral_code_demo/Reusable/AppTheme.dart';
import 'package:referral_code_demo/Reusable/GlobalFile.dart';
import 'package:referral_code_demo/Reusable/IconNames.dart';
import 'dart:math' as pi;

import 'package:share_plus/share_plus.dart';

class RewardScreen extends StatefulWidget {

  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> with SingleTickerProviderStateMixin{
  AnimationController? _controller;
  String? _dynamicLink = "";



  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: bodyView(context),
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
        bundleId: 'com.referraldemo.referral_code_demo',
        minimumVersion: '1.0',
        appStoreId: "",
        fallbackUrl: Uri.parse(""),
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

  bodyView(BuildContext context){
    var ht = 15.0;
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
                  child:  Image.asset(IconNames.logout_icon,height: 25,width: 25,))),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children:  [
                        const Text("Referral Dashboard",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 20,),
                        SizedBox(
                          height: 195,
                          width: 300,
                          child: Lottie.asset(
                            'assets/home_icons/reward.json',
                            controller: _controller,
                            repeat: true,
                            onLoaded: (composition) {
                              // Configure the AnimationController with the duration of the
                              // Lottie file and start the animation.
                              _controller!
                                ..duration = composition.duration
                                ..repeat();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                 const SizedBox(height: 20,),
                 const Text("Your Rewards:",style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                 SizedBox(height: ht,),
                 const Text("Total Cash Earned: ₹150",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                 SizedBox(height: ht,),
                const Divider(thickness: 1.2,),
                 SizedBox(height: ht,),
                const Text("Your Referrals",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text("Name",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color:AppThemeStyle.mainColor()),),
                     Text("Reward Status",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color:AppThemeStyle.mainColor()),),
                     Text("Investment Status",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color:AppThemeStyle.mainColor()),),
                  ],
                ),
                const Divider(thickness: 1.2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Aadil",textAlign: TextAlign.start,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                    Text("Pending",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,),),
                    Text("Pending",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,),),
                  ],
                ),
                const Divider(thickness: 1.2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Test",textAlign: TextAlign.start,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                    Text("Approved",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,),),
                    Text("Approved",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                  ],
                ),
                const Divider(thickness: 1.2,),
                const SizedBox(height: 25,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:10.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      _generateDynamicLink();
                         },
                      child : Text("Refer A Friend",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: AppThemeStyle.mainColor()),)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
