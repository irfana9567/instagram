import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram/common/constants/constant.dart';
import 'package:instagram/common/constants/text.dart';
import 'package:instagram/features/auth/screen/login_page.dart';
import 'package:instagram/navigation/profile.dart';

import '../../../common/constants/imagesConst.dart';
import '../../../common/constants/validator.dart';
import '../../../model/user_model.dart';
import '../controller/auth_controller.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {

  TextEditingController userName=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController confirmpassword=TextEditingController();

  final _formKey = GlobalKey<FormState>();
createUser(){
  if(_formKey.currentState!.validate()){
    // List<String> searchKeywords = AppsHelper.setSearch(userName.text);
    UserModel createdUser=UserModel(
      userName: userName.text,
        email: email.text,
        password: password.text,
        reference: null,
        id:'',
        profile: '',
        name: '',
        bio: '',
        gender: '',
        following: [],
        followers: [],
        search: AppsHelper.setSearch(userName.text),
    );
    ref.read(AuthControllerProvider.notifier).createUser(context,usermodel: createdUser);
    clear();
  }else if(userName.text.isEmpty){
    return AppsHelper.showSnackBar("Enter username", context);
  }else if(email.text.isEmpty){
    return AppsHelper.showSnackBar("Enter your email", context);
  }else if(userName.text.isEmpty){
    return AppsHelper.showSnackBar("Enter password", context);
  }
}

  clear(){
    _formKey.currentState?.reset();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: AppSize.scrHeight*0.11,
                    width: AppSize.scrWidth*0.7,
                    child:const Image(image: AssetImage(imageConst.logotext),fit:BoxFit.fill,),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.025,),
                  TextFormField(
                    controller:userName,
                    keyboardType: TextInputType.text,
                    // textCapitalization: TextCapitalization.words,
                    textInputAction:TextInputAction.newline,
                    style: TextStyle(
                      fontSize: AppSize.scrWidth*0.04,
                      fontWeight: FontWeight.w500,
                    ),
                    autovalidateMode:AutovalidateMode.onUserInteraction,
                    validator:(value) => AppValidators.fieldValidate(value,"UserName"),
                    decoration: InputDecoration(
                      labelText:"UserName" ,
                      labelStyle: TextStyle(
                          fontSize:  AppSize.scrWidth*0.04,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey
                      ),
                      // prefixIcon: Icon(Icons.account_box_sharp),
                      border: OutlineInputBorder(
                          borderRadius:BorderRadius.circular(AppSize.scrWidth*0.02)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                        // )
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.025,),
                  TextFormField(
                    controller:email,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: AppSize.scrWidth*0.04,
                      fontWeight: FontWeight.w500,
                    ),
                    autovalidateMode:AutovalidateMode.onUserInteraction,
                    validator:(value) => AppValidators.validateEmail(value),
                    decoration: InputDecoration(
                      labelText:"Email" ,
                      labelStyle: TextStyle(
                          fontSize:  AppSize.scrWidth*0.04,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey
                      ),
                      // prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                          borderRadius:BorderRadius.circular(AppSize.scrWidth*0.02)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                        // )
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.025,),
                  TextFormField(
                    controller:password,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction:TextInputAction.newline,
                    style: TextStyle(
                      fontSize: AppSize.scrWidth*0.04,
                      fontWeight: FontWeight.w500,
                    ),
                    autovalidateMode:AutovalidateMode.onUserInteraction,
                    validator:(value) => AppValidators.validatePassword(value),
                    decoration: InputDecoration(
                      labelText:"Password" ,
                      labelStyle: TextStyle(
                          fontSize:  AppSize.scrWidth*0.04,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey
                      ),
                      // prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius:BorderRadius.circular(AppSize.scrWidth*0.02)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                        // )
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.025,),
                  TextFormField(
                    controller:confirmpassword,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction:TextInputAction.newline,
                    style: TextStyle(
                      fontSize: AppSize.scrWidth*0.04,
                      fontWeight: FontWeight.w500,
                    ),
                    autovalidateMode:AutovalidateMode.onUserInteraction,
                    validator:(value){
                      if (confirmpassword.text !=
                          password.text) {
                        return "Password does not match";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText:"ConfirmPassword" ,
                      labelStyle: TextStyle(
                          fontSize:  AppSize.scrWidth*0.04,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey
                      ),
                      // prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius:BorderRadius.circular(AppSize.scrWidth*0.02)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                        // )
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.07,),
                  InkWell(
                    onTap: () {
                      createUser();
                      },
                    child: Container(
                      height: AppSize.scrHeight*0.065,
                      width: AppSize.scrWidth*1,
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(AppSize.scrWidth*0.07),
                      ),
                      child: const Center(child: Text("Sign Up",style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.015,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Do you have account? ",style: TextStyle(color: Colors.grey),),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
                        },
                          child: const Text("Login",style: TextStyle(color: Colors.blue),))
                    ],
                  )

                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
