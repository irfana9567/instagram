import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/features/home/screen/saved_media.dart';
import 'package:instagram/features/home/screen/widgets/customAppbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constants/constant.dart';
import '../../../common/constants/imagesConst.dart';
import '../../../model/user_model.dart';
import '../../auth/screen/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    currentUserId='';
    currentUser=null;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage(),), (route) => false,);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: CustomAppBar(
        title: Text("Settings and activity",style:  TextStyle(
            fontSize: AppSize.scrWidth*0.05,
            fontWeight: FontWeight.w900
        ),),
        showBackArrow: true,
      ),
      body: Column(
        children: [
          Container(
            height: AppSize.scrHeight*0.3,
            width: AppSize.scrWidth*1,
            padding: EdgeInsets.all(AppSize.scrWidth*0.03),
            color: Colors.white,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("How you use instagram",style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: AppSize.scrWidth*0.035,
                  color: Colors.grey
                ),),
                ListTile(
                  leading:SizedBox(
                      height: AppSize.scrHeight * 0.02,
                      width: AppSize.scrWidth * 0.05,
                      child: SvgPicture.asset(iconConst.save,color: Colors.black,)),

                  title: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>const SavedMedia(title: 'Saved',) ,));
                      },
                      child: const Text("Saved",style: TextStyle(
                        fontWeight: FontWeight.w700
                      ),)),
                  trailing:  Icon(Icons.arrow_forward_ios,size: AppSize.scrWidth*0.04,color: Colors.grey,),
                ),
                ListTile(
                  leading:SizedBox(
                      height: AppSize.scrHeight * 0.02,
                      width: AppSize.scrWidth * 0.05,
                      child:const Icon(Icons.auto_graph),),

                  title: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedMedia(title: "Your activity",) ,));
                      },
                      child: const Text("Your activity",style: TextStyle(
                        fontWeight: FontWeight.w700
                      ),)),
                  trailing:  Icon(Icons.arrow_forward_ios,size: AppSize.scrWidth*0.04,color: Colors.grey,),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSize.scrHeight*0.01,),
          Container(
            height: AppSize.scrHeight*0.3,
            width: AppSize.scrWidth*1,
            padding: EdgeInsets.all(AppSize.scrWidth*0.03),
            color: Colors.white,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("Login",style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: AppSize.scrWidth*0.035,
                  color: Colors.grey
                ),),
                ListTile(
                  title: InkWell(
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Are you sure? you want to logout?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: AppSize.scrHeight*0.02,
                                    fontWeight: FontWeight.w600
                                ),),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const SizedBox(
                                      height: 30,
                                      width: 100,
                                      child: Center(child: Text("No",
                                        style: TextStyle(
                                            color: Colors.black
                                        ),)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      logout();
                                    },
                                    child: const SizedBox(
                                      height: 30,
                                      width: 100,
                                      child: Center(child: Text("Yes",
                                        style: TextStyle(
                                            color: Colors.black
                                        ),)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Text("Logout",style: TextStyle(
                        color: Colors.red
                      ),)),
                ),
                // SizedBox(height: scrHeight*0.01,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
