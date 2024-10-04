import 'dart:convert';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:instagram/common/constants/text.dart';
import 'package:instagram/features/home/controller/home_controller.dart';
import 'package:instagram/features/home/screen/widgets/bubbleSpecialOne.dart';
import 'package:instagram/features/home/screen/widgets/chat_bubble.dart';
import 'package:instagram/model/chat_model.dart';
import 'package:instagram/model/user_model.dart';
import 'package:intl/intl.dart';

import '../../../common/constants/constant.dart';
import '../../auth/repository/auth_repository.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key,required this.userDetails});
  final QueryDocumentSnapshot<Object?> userDetails;


  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController chatController=TextEditingController();
  final FocusNode focusNode = FocusNode();
  StateProvider isChangedData=StateProvider((ref) => false,);

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final differenceInDays = now.difference(timestamp).inDays;

    if (differenceInDays == 0) {
      return DateFormat('jm').format(timestamp); // Show time for today's messages
    } else if (differenceInDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('yMMMMd').format(timestamp); // Show full date for older messages
    }
  }

  addMessage()async{
      ChatModel messageData=ChatModel(
          senderId:currentUserId,
          message: chatController.text.trim(),
          messageType:'',
          delete: false,
          dateTime:DateTime.now(),
          id: '',
          read: false,
          receiverId: widget.userDetails["id"], reply: '',
      );
      final isChangeData = ref.watch(isChangedData);
      if(isChangeData){
        ref.read(homeControllerProvider.notifier).addChats(chatmodel: messageData);
        FocusScope.of(context).requestFocus(FocusNode());
        chatController.clear();
      }
  }
  ChatModel? replyData;
  updateReply()async {
    ChatModel? updatedReply =  replyData!.copyWith(
      reply: chatController.text,
    );
    ref.read(homeControllerProvider.notifier).addReply(context: context,uId: widget.userDetails["id"], chatModel: updatedReply, );
  }
  clear(){
    _formKey.currentState?.reset();
  }
  delete(String msgId){
    ref.read(homeControllerProvider.notifier).deleteMsg(context: context, docId:msgId);
  }
  @override
  void dispose() {
    chatController.dispose();
    focusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print(currentUserId);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userDetails["name"]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
          StreamBuilder<QuerySnapshot>(
            stream:FirebaseFirestore.instance.collection("users").doc(currentUserId).collection('chats')
                .where("receiverId",isEqualTo: widget.userDetails.id)
                .where("delete",isEqualTo: false)
                .orderBy("dateTime",descending: false)
                .snapshots(),
            builder: (context, snapshot) {
            if (!snapshot.hasData) {
            return const Center(child:CircularProgressIndicator());
            }
            var data = snapshot.data;
              return
              Column(
                children: [
                SizedBox(
                  height: AppSize.scrHeight*0.75,
                  child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: data!.docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      // onLongPress: () {
                      //   return AppsHelper.showAlert("Do you want to delete this message?",context,true,delete(data.docs[index].id));
                      // },
                      onLongPress: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Are you want to delete this message ?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppSize.scrWidth*0.04,
                                ),
                              ),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      height: AppSize.scrHeight*0.05,
                                      width: AppSize.scrWidth*0.2,
                                      child: const Center(child: Text("No",
                                        style: TextStyle(
                                            color: Colors.black
                                        ),)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap : () {
                                      delete(data.docs[index]["id"]);
                                    },
                                    child: SizedBox(
                                      height: AppSize.scrHeight*0.05,
                                      width: AppSize.scrWidth*0.2,
                                      child: const Center(child: Text("Yes",
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
                      child:
                      // ChatBubble(
                      //     message: data.docs[index]["message"],
                      //     isCurrentUser: currentUserId==data.docs[index]["senderId"]?true:false
                      // )
                      BubbleSpecialOne(
                        text: data.docs[index]["message"],
                        isSender: currentUserId==data.docs[index]["senderId"]?true:false,
                        color: currentUserId==data.docs[index]["senderId"]? Colors.purple.shade500:Colors.grey.shade300,
                        textStyle:  TextStyle(
                          fontSize: 15,
                          color: currentUserId==data.docs[index]["senderId"]? Colors.white:Colors.black,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    );
                  },
                  ),
                ),
                  Padding(
                    padding:  EdgeInsets.all(AppSize.scrWidth*0.04),
                    child: Row(
                      children: [
                        SizedBox(
                          width: AppSize.scrWidth*0.75,
                          child: TextFormField(
                            controller:chatController,
                            focusNode: focusNode,
                            onChanged: (value) {
                              ref.read(isChangedData.notifier).state=true;
                            },
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                              fontSize: AppSize.scrWidth*0.04,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText:"Message",
                              labelStyle: TextStyle(
                                  fontSize:  AppSize.scrWidth*0.04,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:BorderRadius.circular(AppSize.scrWidth*0.06)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:BorderRadius.circular(AppSize.scrWidth*0.06),
                                  borderSide: const BorderSide(
                                      color: Colors.grey
                                  )
                                // )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSize.scrWidth*0.03,),
                        InkWell(
                          onTap: () {
                            addMessage();
                            // updateReply();
                          },
                          child: const CircleAvatar(
                            radius: 23,
                            child: Icon(Icons.send),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
          )
          //       ref.watch(getMsg).when(
          //           data: (data) {
          //             return ListView.builder(
          //               shrinkWrap: true,
          //               physics: const BouncingScrollPhysics(),
          //               scrollDirection: Axis.vertical,
          //               itemCount: data.length,
          //               itemBuilder: (context, index) {
          //                 final userId=data[index].senderId;
          //                 // print(userId);
          //                 return GestureDetector(
          //                     // onLongPress: () => AppsHelper.showAlert("Do you want to delete this message?",context,true,delete(data[index].id)),
          //                   onLongPress: () {
          //                     showDialog(
          //                       barrierDismissible: false,
          //                       context: context,
          //                       builder: (context) {
          //                         return AlertDialog(
          //                           title: Text("Are you want to delete this message ?",
          //                             textAlign: TextAlign.center,
          //                             style: TextStyle(
          //                                 fontSize: AppSize.scrWidth*0.04,
          //                             ),
          //                           ),
          //                           content: Row(
          //                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                             children: [
          //                               InkWell(
          //                                 onTap: () {
          //                                   Navigator.pop(context);
          //                                 },
          //                                 child: SizedBox(
          //                                   height: AppSize.scrHeight*0.05,
          //                                   width: AppSize.scrWidth*0.2,
          //                                   child: const Center(child: Text("No",
          //                                     style: TextStyle(
          //                                         color: Colors.black
          //                                     ),)),
          //                                 ),
          //                               ),
          //                               InkWell(
          //                                 onTap : () {
          //                                   delete(data[index].id);
          //                                 },
          //                                 child: SizedBox(
          //                                   height: AppSize.scrHeight*0.05,
          //                                   width: AppSize.scrWidth*0.2,
          //                                   child: const Center(child: Text("Yes",
          //                                     style: TextStyle(
          //                                         color: Colors.black
          //                                     ),)),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         );
          //                       },
          //                     );
          //                   },
          //                   child: BubbleSpecialOne(
          //                     text:data[index].message,
          //                     isSender:currentUserId==data[index].senderId?true:false,
          //                     // currentUserId==userId?true:false
          //                     color: Colors.grey.shade300,
          //                     textStyle: const TextStyle(
          //                       fontSize: 15,
          //                       color: Colors.black,
          //                       fontStyle: FontStyle.normal,
          //                       // fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                 );
          //               },
          //             );
          //           },
          //           error: (error, stackTrace) => Text(error.toString()),
          //           loading: () => const CircularProgressIndicator(),),
            ],

        ),
      ),
    );
  }
}
