

import 'package:flutter/material.dart';
import 'package:todo/constant/colors.dart';
import 'package:todo/constant/font_style.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({Key? key, required this.hint, required this.onChanged, this.keyboardType, this.textEditingController})
      : super(key: key);
  final String hint;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      onChanged: onChanged,
      controller: textEditingController,
      decoration: InputDecoration(
          label: Text(hint, style: AppTextStyle.textStyle16W700),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: AppColors.grey7),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: AppColors.grey7),
          )),
    );
  }
}