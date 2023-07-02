import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/common_widgets/buttons/primary_button.dart';
import 'package:todo/common_widgets/text_field/text_field.dart';
import 'package:todo/constant/colors.dart';
import 'package:todo/constant/font_style.dart';

class AddBottomSheet extends StatelessWidget {
  const AddBottomSheet(
      {Key? key,
      required this.onChangedDate,
      required this.onChangedDescription,
      required this.onChangedName,
      this.taskName,
      this.taskDescription,
      this.initialDate,
      required this.onTap})
      : super(key: key);
  final Function(String)? onChangedName;
  final Function(String)? onChangedDescription;
  final Function(DateTime) onChangedDate;
  final void Function()? onTap;
  final String? taskName, taskDescription, initialDate;

  // final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(taskName != null ? 'Edit Todo':'Add New Todo', style: AppTextStyle.textStyle16W700),
          const SizedBox(height: 16),
          const Divider(thickness: 1),
          const SizedBox(height: 16),
          AppTextField(hint: taskName ?? 'Task Name', onChanged: onChangedName),
          const SizedBox(height: 16),
          AppTextField(hint: taskDescription ?? 'Description', onChanged: onChangedDescription),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              initialDateTime: initialDate != null ? DateTime.parse(initialDate!) : DateTime.now().add(Duration(seconds: 5)),
              onDateTimeChanged: onChangedDate,
              minimumDate: DateTime.now(),
              maximumDate: DateTime(5000),
              mode: CupertinoDatePickerMode.dateAndTime,
            ),
          ),
          const SizedBox(height: 16),
          // isLoading
          //     ? Transform.scale(child: const CircularProgressIndicator())
          //     :
          PrimaryButton(buttonTxt: taskName != null ? 'Edit Todo' :'Add Todo', onTap: onTap),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
