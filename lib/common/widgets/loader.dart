import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mod_game/utils/constants/colors.dart';
import 'package:mod_game/utils/constants/images.dart';
import 'package:mod_game/utils/helper/navigation.dart';

class XLoader {
  XLoader._();

  static show() {
    Get.dialog(
      const LoadingWidget(),
      barrierDismissible: false,
      barrierColor: XColor.black.withOpacity(.75),
    );
  }

  static hide() {
    Navigation.pop();
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.transparent,
        width: 150.h,
        height: 150.h,
        child: Image.asset(XImage.loader),
      ),
    );
  }
}
