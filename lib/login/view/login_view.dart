import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo/common_widgets/buttons/primary_button.dart';
import 'package:todo/constant/assets_path.dart';
import 'package:todo/constant/colors.dart';
import 'package:todo/home/controller/home_controller.dart';
import 'package:todo/home/view/home_view.dart';
import 'package:todo/login/controller/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('login view');
    return Scaffold(
      body: Center(
        child: Consumer<LoginController>(builder: (context, data, child) {
          return data.isLoading
              ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator())
              : PrimaryButton(
                  buttonTxt: 'Google SignIn',
                  color: AppColors.primaryColor.withOpacity(0.5),
                  leadingWidget: SvgPicture.asset(AssetsPath.googleLogo),
                  onTap: () async {
                    await data.googleSignInCall();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => HomeController(),
                          child: HomeView(),
                        ),
                      ),
                    );
                  });
        }),
      ),
    );
  }
}
