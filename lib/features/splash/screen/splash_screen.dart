import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram/common/constants/constant.dart';
import 'package:instagram/common/constants/imagesConst.dart';
import 'package:instagram/features/auth/screen/login_page.dart';

import '../../auth/controller/auth_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // Future.delayed(Duration(seconds: 5)).then((value) =>  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage(),)),);
    Future.delayed(const Duration(seconds: 3)).then((value) =>
    ref.read(AuthControllerProvider.notifier).keepLogin(context));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: AppSize.scrHeight*0.2,
              width: AppSize.scrWidth*0.4,
              child: const Image(image: AssetImage(imageConst.logo),fit:BoxFit.fill,),
            ),
          ),
        ],
      ),
    );
  }
}
