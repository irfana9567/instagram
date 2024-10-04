import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flml_internet_checker/flml_internet_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/common/constants/constant.dart';
import 'package:instagram/features/home/controller/home_controller.dart';
import 'package:instagram/model/post_model.dart';
import 'package:instagram/model/user_model.dart';
import 'package:lottie/lottie.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../features/home/screen/widgets/customAppbar.dart';

class AddPost extends ConsumerStatefulWidget {
  const AddPost({super.key});

  @override
  ConsumerState<AddPost> createState() => _AddState();
}

class _AddState extends ConsumerState<AddPost> {

  StateProvider isPressed=StateProvider((ref) => false,);
  TextEditingController description=TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
  late final String url;
  Future<void> uploadPost(XFile image, String userId) async {
    if (image != null) {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child('posts/$fileName');
      UploadTask uploadTask = ref.putFile(File(image.path));

      final TaskSnapshot downloadUrl = await uploadTask;
       url = await downloadUrl.ref.getDownloadURL();
      addPost();
    }
  }
  addPost(){
    PostModel addedPost=PostModel(
        uId: currentUserId,
        id: '',
        image: url,
        description: description.text,
        like: [],
        uploadDate: DateTime.now(),
        delete: false,
        userName: currentUser?.userName??"",
        userProfile: currentUser?.profile??"",
        userBio: currentUser?.bio??"",
        name: currentUser?.name??"",
        likeCount: 0,
        reference: null, saveUser: [],
    );

    ref.read(homeControllerProvider.notifier).addPosts(context,postmodel:addedPost);
  }

  @override
  Widget build(BuildContext context) {
    final isPress = ref.watch(isPressed);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:CustomAppBar(title: Text("New post",style:  TextStyle(
          fontSize: AppSize.scrWidth*0.05,
          fontWeight: FontWeight.w900
      ),),
        actions: [
          if(!isPress)SizedBox(
            height: AppSize.scrWidth*0.06,
            width: AppSize.scrWidth*0.14,
            child:InkWell(
              onTap: () {
                ref.read(isPressed.notifier).state=true;
              },
              child: const Center(
                child: Text("Next",
                  style: TextStyle(
                      color: Colors.blueAccent
                  ),
                ),
              ),
            ) ,
          ),
          SizedBox(width: AppSize.scrWidth*0.03,)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSize.scrWidth*0.05),
          child: Column(
                children: [
                  if (_image != null)
                    SizedBox(
                      height: AppSize.scrHeight*0.5,
                      child: Image.file(
                        File(_image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(height: AppSize.scrHeight*0.02,),
                  isPress? Column(
                    children: [
                      SizedBox(height: AppSize.scrHeight*0.02,),
                      TextFormField(
                        controller: description,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        maxLines: null,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: AppSize.scrWidth*0.05,right: AppSize.scrWidth*0.05),
                            border:InputBorder.none,
                            hintText: "Write a caption here...",
                            hintStyle: TextStyle(
                                fontSize: AppSize.scrWidth*0.04
                            )
                        ),
                      ),
                      SizedBox(height: AppSize.scrHeight*0.03,),
                      RoundedLoadingButton(
                        borderRadius: AppSize.scrWidth*0.02,
                        color:Colors.blue[700] ,
                        controller: btnController,
                        onPressed: () {
                          uploadPost(_image!, currentUserId);
                        },
                        child: const Text('Share', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                  : Column(
                    children: [
                      const Divider(),
                      TextButton.icon(
                        icon: Icon(Icons.photo_library,color: Colors.grey.shade700,),
                        label: Text('Select Image',
                        style: TextStyle(color: Colors.grey.shade700),),
                        onPressed: _pickImage,
                      ),
                    ],
                  ),
                ],
              ),
        ),
      )


    );
  }
}

