import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram/common/constants/constant.dart';
import 'package:instagram/features/home/screen/chat_screen.dart';
import 'package:instagram/features/home/screen/widgets/customAppbar.dart';
import 'package:instagram/features/home/screen/widgets/lay_out.dart';
import 'package:instagram/model/user_model.dart';

import '../../auth/repository/auth_repository.dart';
import '../controller/home_controller.dart';

class Messages extends ConsumerStatefulWidget {
  const Messages({super.key});

  @override
  ConsumerState<Messages> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<Messages> {
  TextEditingController search=TextEditingController();
 final  String _value="one";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:CustomAppBar(
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _value,
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem(
                value: 'one',
                child: Row(
                  children: [
                    Text(currentUser?.userName??"",style: const TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ],
            onChanged: (value){},
          ),
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(top: AppSize.scrHeight*0.05,left: AppSize.scrWidth*0.03,right: AppSize.scrWidth*0.03),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("users").where("id",isNotEqualTo:currentUserId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var data = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      // final userData=data[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(userDetails: data[index],)));
                        },
                        child: SizedBox(
                          height: AppSize.scrHeight * 0.1,
                          width: AppSize.scrWidth * 1,
                          child: ListTile(
                            leading: data[index]["profile"].isNotEmpty? CircleAvatar(
                              radius: 28,
                                backgroundImage: NetworkImage(data[index]["profile"])
                            ) :const CircleAvatar(
                              radius: 28,
                              backgroundImage:AssetImage("assets/images/person.png") ,
                            ),
                            title: Text(data[index]["userName"]),
                            trailing: const Icon(Icons.camera_alt_rounded),
                          ),
                        ),
                      );
                    },
                  );
                }
    )
            ],
          ),
        ),
      ),
    );
  }
}
