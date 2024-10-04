import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/common/constants/imagesConst.dart';
import 'package:instagram/features/home/screen/edit_profile.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../common/constants/constant.dart';
import '../../../model/user_model.dart';
import '../controller/home_controller.dart';

class EditPage extends ConsumerStatefulWidget {
  const EditPage({super.key,required this.title,required this.userDetail,});
  final String title;
  final String userDetail;
  // final UserModel? userData;

  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}
class _EditPageState extends ConsumerState<EditPage> {
  TextEditingController nameController=TextEditingController();
  TextEditingController userNameController=TextEditingController();
  TextEditingController bioController=TextEditingController();
  TextEditingController customController=TextEditingController();
  StateProvider isPressed=StateProvider((ref) => false,);
  UserModel? userData;
  getuserData()async{
    userData=await ref.read(homeControllerProvider.notifier).getUser();
    nameController.text=userData!.name;
    userNameController.text=userData!.userName;
    bioController.text=userData!.bio;
  }
  updateData()async {
    UserModel updatedData = userData!.copyWith(
        name: nameController.text,
        userName: userNameController.text,
        bio: bioController.text,
        gender:selectedGender
    );
    ref.read(homeControllerProvider.notifier).updateUserdata(context, updatedData);
    ref.read(homeControllerProvider.notifier).userDataPost(userNameController.text,nameController.text,bioController.text);
    ref.read(homeControllerProvider.notifier).userDataStory(userNameController.text);
    ref.read(homeControllerProvider.notifier).userDateComment(userNameController.text);
  }
  var selectedGender;
  TextEditingController customGenderController = TextEditingController();
  StateProvider isChangedData=StateProvider((ref) => false,);
  @override
  void initState() {
    // TODO: implement initState
    getuserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final isChangeData = ref.watch(isChangedData);
    final isPress = ref.watch(isPressed);
    return Scaffold(
        appBar: AppBar(
          title:  Text(widget.title,
            style: TextStyle(
                fontSize: AppSize.scrWidth*0.05,
                fontWeight: FontWeight.w900
            ),),
          actions: [
            InkWell(
              onTap: () {
                ref.read(isPressed.notifier).state=true;
                updateData();
              },
              child: isPress?  SizedBox(
                  height: AppSize.scrWidth*0.05,
                  width: AppSize.scrWidth*0.05,
                  child:  const CircularProgressIndicator(strokeWidth: 2,color: Colors.grey,))
                  :SizedBox(
                  height: AppSize.scrWidth*0.09,
                  width: AppSize.scrWidth*0.09,
                  child: SvgPicture.asset(iconConst.tick,color: Colors.blueAccent,)),
            ),
            SizedBox(width: AppSize.scrWidth*0.04,),
          ],
        ),
        body: Padding(
          padding:  EdgeInsets.all(AppSize.scrWidth*0.05),
          child: Column(
            children: [
              widget.title=="Name"?
              Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration:  InputDecoration(
                        labelText: widget.title
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.03,),
                  const Text("""Help people discover your account by using the name you\'re known by: either your full name, nickname, or business name.\nYou can only change your name twice within 14 days.""")
                ],
              ):
              widget.title=="Username"?
              Column(
                children: [
                  TextFormField(
                    controller: userNameController,
                    decoration:  InputDecoration(
                        labelText: widget.title
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.03,),
                  Text("""You\'ll be able to change your username back to ${widget.userDetail} for another 14 days.""")
                ],
              ):
              widget.title=="Bio"?
              // TextFormField(
              //   controller: bioController,
              //   keyboardType: TextInputType.multiline,
              //   decoration:  InputDecoration(
              //       labelText: widget.title
              //   ),
              // )
              TextFormField(
                controller: bioController,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                maxLines: null,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    labelText: widget.title
                ),
              ):
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                        customController.clear();
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                        customController.clear();
                      });
                    },
                  ),
                  // RadioListTile<String>(
                  //   title: const Text('Custom'),
                  //   value: 'Custom',
                  //   // customGenderController.text.isEmpty? 'Custom': customGenderController.text,
                  //   groupValue: selectedGender,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedGender = value;
                  //     });
                  //   },
                  // ),
                  // // if (selectedGender != null && selectedGender == customGenderController.text)
                  // if(selectedGender=="Custom")
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //     child: TextField(
                  //       controller: customController,
                  //       decoration:  InputDecoration(
                  //         labelText: isChangeData? 'Custom Gender':'Gender cannot be empty',
                  //         labelStyle: TextStyle(
                  //           fontSize: AppSize.scrWidth*0.04,
                  //           color: isChangeData? Colors.grey.shade600:Colors.red
                  //         ),
                  //         suffixIcon:isChangeData? null:const Icon(Icons.warning,color: Colors.red,)
                  //       ),
                  //       onChanged: (value) {
                  //         ref.read(isChangedData.notifier).state=value.isNotEmpty;
                  //         setState(() {
                  //           selectedGender = value;
                  //         });
                  //       },
                  //     ),
                  //   ),
                  RadioListTile<String>(
                    title: const Text('Prefer not to say'),
                    value: 'Prefer not to say',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                        customController.clear();
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}

