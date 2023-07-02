

import 'package:flutter/material.dart';
import 'package:todo/constant/colors.dart';

import '../../constant/font_style.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key? key,required this.buttonTxt,this.leadingWidget,required this.onTap,this.color}) : super(key: key);
  final String buttonTxt;
  final Widget? leadingWidget;
  final Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color ?? AppColors.primaryColor
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leadingWidget ?? const SizedBox.shrink(),
            if(leadingWidget != null)
              const SizedBox(width: 10),
            Text(buttonTxt,style: AppTextStyle.textStyle16W500.copyWith(color: AppColors.whiteColor)),
          ],
        ),
      ),
    );
  }
}
