import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:referral_code_demo/Home/Dashboard.dart';
import 'package:referral_code_demo/Home/RewardScreen.dart';
import 'package:referral_code_demo/Reusable/AppTheme.dart';
import 'package:referral_code_demo/Reusable/ColorExtenstion.dart';
import 'package:referral_code_demo/Reusable/GlobalFile.dart';
import 'package:referral_code_demo/Reusable/IconNames.dart';
import 'package:referral_code_demo/Reusable/SnackbarMessage.dart';
import 'package:string_validator/string_validator.dart';


class SigninScreen extends StatefulWidget {
  var fromDynamicLink;
  String? referenceCode;
  SigninScreen({this.fromDynamicLink,this.referenceCode});

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _refCodeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isPassSecure = true;
  var androidDeviceName = "";
  var allocationStatus = "";
  var androidOSVersion = "";
  var iosDeviceName = "";
  var iosOSVersion = "";
  var userName = "";
  //function for validation
  checkValidation(BuildContext context) {
    if (_emailController.text.isEmpty) {
      SnackbarMessage(context, "Please enter your email address.");
      return false;
    } else if (isEmail(_emailController.text) == false) {
      SnackbarMessage(context, "Please enter valid email address.");
      return false;
    } else if (_passwordController.text.isEmpty) {
      SnackbarMessage(context, "Please enter your password.");
      return false;
    } else if (_passwordController.text.length < 6 ||
        _passwordController.text.length > 20) {
      SnackbarMessage(context, "password should be between 6-20 \ncharacters.");
      return false;
    } else {
      return true;
    }
  }

  //function for fetching device info
  getDeviceNameAndId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      androidDeviceName = androidInfo.model;
      androidOSVersion = androidInfo.version.release;

      var map = {
        "androidDeviceName":androidDeviceName,
        "androidOsVersion":androidOSVersion,
      };
      log("Android data---->$map");
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      iosDeviceName = iosInfo.name;
      iosOSVersion = iosInfo.systemName;

      var map = {
        "iosDeviceName":iosDeviceName,
        "iosOsVersion":iosOSVersion,
      };
      log("IOS data---->$map");
    }
  }

  void addItemsToLocalStorage() {
    SET_INTO_DEFAULT(NAME, _nameController.text);
    SET_INTO_DEFAULT(EMAIL, _emailController.text);
    SET_INTO_DEFAULT(isLogIn, "true");

    final info = json.encode({'email': _emailController.text, 'password': _passwordController.text});
    SET_INTO_DEFAULT(PERSONAL_INFO, info);

    if(_refCodeController.text != ""){
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => RewardScreen()),
              (route) => false);
    }else{
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => Dashboard()),
              (route) => false);
    }
  }




  //Widgets
  _emailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        height: 45,
        // width: MediaQuery.of(context).size.width - 50.w,
        decoration: BoxDecoration(
            border: Border.all(color: AppThemeStyle.textFieldColor())),
        child: Row(
          children: [
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: AppThemeStyle.textFieldColor())),
                ),
                padding:
                const EdgeInsets.only(left: 8, top: 10, right: 5, bottom: 10),
                child: ImageIcon(
                  const AssetImage(IconNames.email_icon),
                  color: AppThemeStyle.mainColor(),
                  size: 5,
                )),
            Expanded(
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: AppThemeStyle.mainColor()),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 12),
                      hintText: "Email Address",
                      hintStyle:
                      TextStyle(color: AppThemeStyle.textFieldHintTextColor())),
                ))
          ],
        ),
      ),
    );
  }

  _refCodeTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        height: 45,
        // width: MediaQuery.of(context).size.width - 50.w,
        decoration: BoxDecoration(
            border: Border.all(color: AppThemeStyle.textFieldColor())),
        child: Row(
          children: [
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: AppThemeStyle.textFieldColor())),
                ),
                padding:
                const EdgeInsets.only(left: 8, top: 10, right: 5, bottom: 10),
                child: ImageIcon(
                  const AssetImage(IconNames.ref_icon),
                  color: AppThemeStyle.mainColor(),
                  size: 5,
                )),
            Expanded(
                child: TextField(
                  controller: _refCodeController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: AppThemeStyle.mainColor()),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 12),
                      hintText: "Reference Code(Optional)",
                      hintStyle:
                      TextStyle(color: AppThemeStyle.textFieldHintTextColor())),
                ))
          ],
        ),
      ),
    );
  }

  _nameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        height: 45,
        // width: MediaQuery.of(context).size.width - 50.w,
        decoration: BoxDecoration(
            border: Border.all(color: AppThemeStyle.textFieldColor())),
        child: Row(
          children: [
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: AppThemeStyle.textFieldColor())),
                ),
                padding:
                const EdgeInsets.only(left: 8, top: 10, right: 5, bottom: 10),
                child: ImageIcon(
                  const AssetImage(IconNames.user_icon),
                  color: AppThemeStyle.mainColor(),
                  size: 5,
                )),
            Expanded(
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: AppThemeStyle.mainColor()),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 12),
                      hintText: "Name",
                      hintStyle:
                      TextStyle(color: AppThemeStyle.textFieldHintTextColor())),
                ))
          ],
        ),
      ),
    );
  }

  _passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          Container(
            height: 45,
            // width: MediaQuery.of(context).size.width - 50.w,
            decoration: BoxDecoration(
                border: Border.all(color: AppThemeStyle.textFieldColor())),
            child: Row(
              children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: AppThemeStyle.textFieldColor())),
                    ),
                    padding:
                    const EdgeInsets.only(left: 8, top: 10, right: 5, bottom: 10),
                    child: ImageIcon(
                      const AssetImage(IconNames.password_icon),
                      color: AppThemeStyle.mainColor(),
                      size: 5,
                    )),
                Expanded(
                    child: TextField(
                      controller: _passwordController,
                      style: TextStyle(color: AppThemeStyle.mainColor()),
                      textInputAction: TextInputAction.done,
                      obscureText: isPassSecure ? true : false,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 12, top: 12),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPassSecure = !isPassSecure;
                                });
                              },
                              icon: isPassSecure
                                  ? const Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.grey,
                              )
                                  : const Icon(Icons.remove_red_eye)),
                          hintText: "Password",
                          hintStyle: TextStyle(
                              color: AppThemeStyle.textFieldHintTextColor())),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    if(widget.referenceCode != null && widget.referenceCode.toString() != ""){
      _refCodeController.text = widget.referenceCode.toString();
    }

    getDeviceNameAndId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  null,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.only(top:120),
          child: Column(
            children: [
              Container(
                height: 95,
                width: 150,
                child: Image.asset(IconNames.logo),
              ),
              SizedBox(height: 70),
              Expanded(
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade500, blurRadius: 10.0)
                      ],
                    ),
                    padding: const EdgeInsets.all(0),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Container(
                                height: 5.w,
                                width: 65.h,
                                decoration: BoxDecoration(
                                    color: HexColor("#DCDCDC"),
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                          ListTile(
                            onTap: (){
                              FocusScope.of(context).unfocus();
                            },
                            title: Text(" Sign In",
                                style: GoogleFonts.jost(
                                    fontWeight: FontWeight.w600, fontSize: 24)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 15.0, left: 5.0),
                              child: Text(
                                  " Login to view your investment dashboard.",
                                  style: GoogleFonts.jost(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppThemeStyle
                                          .greyFooterPaginationTextColor())),
                            ),
                          ),
                          SizedBox(height: 35.h),
                          _nameTextField(),
                          SizedBox(height: 30.h),
                          _emailTextField(),
                          SizedBox(height: 30.h),
                          _passwordTextField(),
                          SizedBox(height: 30.h),
                          _refCodeTextField(),
                          SizedBox(
                            height: 15.w,
                          ),
                          _signInButton(),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return InkWell(
      onTap: () {
        if(checkValidation(context)){
          addItemsToLocalStorage();
        }
      },
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
          color: AppThemeStyle.mainColor(),
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.center,
        child: Text(
          'SIGN IN',
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
