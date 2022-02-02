import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:referral_code_demo/Authentication/SignInScreen.dart';
import 'package:referral_code_demo/Reusable/AppTheme.dart';
import 'package:referral_code_demo/Reusable/IconNames.dart';
import 'package:shared_preferences/shared_preferences.dart';

var transactionRef;
var isLogIn = "isLogIn";
var NAME = "NAME";
var EMAIL = "EMAIL";
var PERSONAL_INFO = "PERSONAL_INFO";
var sub = "Hey, have you tried BHIVE.fund?\nI've been Investing with them and thought you'd love it tool.\n\nBHIVE.fund is one of the India's largest and fastest-growing investment platforms.\n\nInvesting with them is fast & easy.\nClick on the link to start Investing.\n\n";

SET_INTO_DEFAULT(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<String> GET_FROM_DEFAULT(String key) async {
  var value = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString(key) != null) {
    value = prefs.getString(key)!;
  }
  return value;
}

removeAllData()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}



showLogoutDialog(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                width: 180,
                padding: const EdgeInsets.only(left: 15),
                child: Image.asset(IconNames.logo),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Are you sure want to logout?",
                style:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 45,
                    width: 120,
                    child: RaisedButton(
                        child: const Text("Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                  Container(
                    height: 45,
                    width: 120,
                    child: RaisedButton(
                        child: const Text("Logout",
                            style:  TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                        color: AppThemeStyle.mainColor(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          removeAllData();
                          Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(builder: (context) => SigninScreen()),
                                  (route) => false);
                        }),
                  )
                ],
              )
            ],
          ),
        );
      });
}