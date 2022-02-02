import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:referral_code_demo/Reusable/AppTheme.dart';

SnackbarMessage(BuildContext context, String message) {
  HapticFeedback.lightImpact();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.floating,
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Expanded(
                child: Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text("Dismiss",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppThemeStyle.mainColor())))
          ],
        ),
      )));
}
