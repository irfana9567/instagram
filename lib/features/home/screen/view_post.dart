import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/common/constants/text.dart';
import 'package:instagram/features/home/controller/home_controller.dart';
import 'package:instagram/features/home/screen/widgets/HeartAnimationWidget.dart';
import 'package:instagram/model/user_model.dart';
import 'package:instagram/navigation/profile.dart';
import 'package:readmore/readmore.dart';

import '../../../common/constants/constant.dart';
import '../../../common/constants/imagesConst.dart';
import '../../../model/comment_model.dart';
import '../../../model/post_model.dart';

class ViewPost extends ConsumerStatefulWidget {
  const ViewPost({super.key,required this.postUrl,required this.userId,required this.initialIndex,required this.postId});
  // final QuerySnapshot postDetails;
  final String postUrl;
  final String userId;
  final String postId;
  final int initialIndex;

  @override
  ConsumerState<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends ConsumerState<ViewPost> {
  List posts=[];
  delete(){
    ref.read(homeControllerProvider.notifier).deletePost(context: context, docId: widget.postId);
  }

  String? highlightedCommentId;

  bool isUploading = false;
  bool isLikeAnimating = false;

  final _formKey = GlobalKey<FormState>();

  PostModel? postData;
  TextEditingController commentController=TextEditingController();
  final FocusNode focusNode = FocusNode();
  StateProvider isChangedData=StateProvider((ref) => false,);


  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        FirebaseFirestore.instance.collection('post').doc(postId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        FirebaseFirestore.instance.collection('post').doc(postId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {
      error.toString();
    }
  }

  Future<void> savePost(String postId, String uid, List saveUser) async {
    try {
      if (saveUser.contains(uid)) {
        FirebaseFirestore.instance.collection('post').doc(postId).update({
          'saveUser': FieldValue.arrayRemove([uid])
        });
      } else {
        FirebaseFirestore.instance.collection('post').doc(postId).update({
          'saveUser': FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {
      error.toString();
    }
  }

  Future<void> likeComment(String postId,String commentId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        FirebaseFirestore.instance.collection('post').doc(postId).collection('comments').doc(commentId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        FirebaseFirestore.instance.collection('post').doc(postId).collection('comments').doc(commentId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {
      error.toString();
    }
  }

  addComment(String pId)async{
    CommentModel commentData=CommentModel(
        commentId: '',
        postId: pId,
        userId: currentUserId,
        comment: commentController.text,
        date: DateTime.now(),
        userName: currentUser?.userName??"",
        userProfile: currentUser?.profile??"",
        like: [],
        delete: false
    );

    final isChangeData = ref.watch(isChangedData);
    if(isChangeData){
      ref.read(homeControllerProvider.notifier).addComments(pId, commentModel: commentData);
      commentController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  deleteComments(String cmtId,String postId){
    ref.read(homeControllerProvider.notifier).deleteComment(context: context, pId: postId, cId: cmtId);
  }
  clear(){
    _formKey.currentState?.reset();
  }
  @override
  void dispose() {
    commentController.dispose();
    focusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          //   ListView.separated(
          //   physics: const BouncingScrollPhysics(),
          //   shrinkWrap: true,
          //   itemCount:posts.length,
          //   scrollDirection: Axis.vertical,
          //   itemBuilder: (context, index) {
          //     return  Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding:  EdgeInsets.all(AppSize.scrWidth*0.03),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Row(
          //                 children: [
          //                   posts.isNotEmpty? CircleAvatar(
          //                       backgroundImage: NetworkImage( posts[index]["userProfile"])
          //                   ) :const CircleAvatar(
          //                     backgroundImage:AssetImage("assets/images/person.png") ,
          //                   ),
          //                   SizedBox(width: AppSize.scrWidth*0.02,),
          //                   Text( posts[index]["userName"]),
          //                 ],
          //               ),
          //               SizedBox(
          //                   height: AppSize.scrHeight*0.03,
          //                   width: AppSize.scrWidth*0.06,
          //                   child: SvgPicture.asset(iconConst.dots,)),
          //             ],
          //           ),
          //         ),
          //         SizedBox(
          //           height: AppSize.scrHeight*0.62,
          //           width: AppSize.scrWidth*1,
          //           child: Image(image: NetworkImage( posts[index]["image"]),fit: BoxFit.fill,),
          //         ),
          //         Padding(
          //           padding: EdgeInsets.all(AppSize.scrWidth*0.03),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Row(
          //                     children: [
          //                       SizedBox(
          //                           height: AppSize.scrHeight*0.03,
          //                           width: AppSize.scrWidth*0.06,
          //                           child: SvgPicture.asset(iconConst.notification,)),
          //                       SizedBox(width: AppSize.scrWidth*0.02,),
          //                       SizedBox(
          //                           height: AppSize.scrHeight*0.036,
          //                           width: AppSize.scrWidth*0.08,
          //                           child: SvgPicture.asset(iconConst.comment,fit: BoxFit.fill,)),
          //                       SizedBox(width: AppSize.scrWidth*0.02,),
          //                       SizedBox(
          //                           height: AppSize.scrHeight*0.03,
          //                           width: AppSize.scrWidth*0.06,
          //                           child: SvgPicture.asset(iconConst.share,)),
          //                     ],
          //                   ),
          //                   SizedBox(
          //                       height: AppSize.scrHeight*0.03,
          //                       width: AppSize.scrWidth*0.06,
          //                       child: SvgPicture.asset(iconConst.save,)),
          //                 ],
          //               ),
          //               SizedBox(height: AppSize.scrWidth*0.03,),
          //               ReadMoreText( posts[index]["description"],
          //                 trimMode: TrimMode.Line,
          //                 trimLines: 2,
          //                 colorClickableText: Colors.pink,
          //                 trimCollapsedText: 'more',
          //                 trimExpandedText: 'less',
          //                 moreStyle: const TextStyle(
          //                     color: Colors.black45,
          //                     fontWeight: FontWeight.bold
          //                 ),
          //                 lessStyle: const TextStyle(
          //                     color: Colors.black45,
          //                     fontWeight: FontWeight.bold
          //                 ),
          //               ),
          //               // Text(data[index].description)
          //             ],
          //           ),
          //         ),
          //       ],
          //     );
          //   },
          //   separatorBuilder: (context, index) {
          //     return SizedBox(
          //       height: AppSize.scrHeight*0.02,
          //     );
          //   },
          // )
            StreamBuilder<QuerySnapshot>(
                stream:FirebaseFirestore.instance.collection("post")
                    .where("uId",isEqualTo: widget.userId)
                    .where("delete",isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child:CircularProgressIndicator());
                  }
                  var data = snapshot.data!.docs;
                  return ListView.separated(
                    // controller:  _pageController,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:  EdgeInsets.all(AppSize.scrWidth*0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Profile(),), (route) => false,);
                                  },
                                  child: Row(
                                    children: [
                                      data[index]["userProfile"].isNotEmpty? CircleAvatar(
                                          backgroundImage: NetworkImage(data[index]["userProfile"])
                                      ) :const CircleAvatar(
                                        backgroundImage:AssetImage("assets/images/person.png") ,
                                      ),
                                      SizedBox(width: AppSize.scrWidth*0.02,),
                                      Text(data[index]["userName"]),
                                    ],
                                  ),
                                ),

                                data[index]["uId"]==currentUserId?PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      AppsHelper.showAlert("Do you want delete this post",context,true,delete);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text('Delete',style: Theme.of(context).textTheme.titleSmall,),
                                        onTap: () {
                                        },
                                      ),

                                    ];
                                  },
                                ):
                                SizedBox(
                                  height: AppSize.scrHeight*0.03,
                                  width: AppSize.scrWidth*0.06,
                                  child: SvgPicture.asset(iconConst.dots),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onDoubleTap: () {
                              likePost(
                                data[index]["id"],
                                currentUserId,
                                data[index]["like"],
                              );
                              setState(() {
                                isLikeAnimating = true;
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: AppSize.scrHeight * 0.62,
                                  width: AppSize.scrWidth * 1,
                                  child: Image(
                                    image: NetworkImage(data[index]["image"]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: isLikeAnimating ? 1 : 0,
                                  child: LikeAnimation(
                                    isAnimating: isLikeAnimating,
                                    duration: const Duration(
                                      milliseconds: 400,
                                    ),
                                    onEnd: () {
                                      setState(() {
                                        isLikeAnimating = false;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 100,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(AppSize.scrWidth * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        LikeAnimation(
                                          isAnimating: data[index]["like"].contains(currentUserId),
                                          smallLike: true,
                                          child: IconButton(
                                            icon: data[index]["like"].contains(currentUserId)
                                                ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                                : const Icon(
                                              Icons.favorite_border,
                                            ),

                                            onPressed: ()=>
                                                likePost(
                                                  data[index]["id"],
                                                  currentUserId,
                                                  data[index]["like"],
                                                ),


                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                              showDragHandle: true,
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                  height: AppSize.scrHeight*0.9,
                                                  child: Column(
                                                    children: [
                                                      const Text("Comments",style: TextStyle(
                                                          fontWeight: FontWeight.bold
                                                      ),),
                                                      Expanded(
                                                          child: StreamBuilder<QuerySnapshot>(
                                                              stream: FirebaseFirestore.instance.collection('post').doc(data[index].id)
                                                                  .collection('comments')
                                                                  .where('postId',isEqualTo: data[index].id)
                                                                  .where('delete',isEqualTo: false)
                                                                  .orderBy('date',descending: true)
                                                                  .snapshots(),
                                                              builder: (context, snapshot) {
                                                                if (!snapshot.hasData) {
                                                                  return const Center(child:CircularProgressIndicator());
                                                                }
                                                                var data = snapshot.data;
                                                                return
                                                                  SizedBox(
                                                                    child: data!.docs.isEmpty? const Center(child: Text("No comments yet!")):
                                                                    ListView.separated(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      shrinkWrap: true,
                                                                      itemCount:data.docs.length,
                                                                      itemBuilder: (context, index) {
                                                                        return GestureDetector(
                                                                          onLongPress: () {
                                                                            showDialog(
                                                                              barrierDismissible: false,
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return AlertDialog(
                                                                                  title: Text(" Do you want to delete this comment?",
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
                                                                                          deleteComments(data.docs[index]["commentId"],data.docs[index]["postId"]);
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
                                                                          child: Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              data.docs[index]["userProfile"] == ""
                                                                                  ? const CircleAvatar(
                                                                                backgroundImage: AssetImage("assets/images/person.png"),
                                                                              )
                                                                                  : CircleAvatar(
                                                                                backgroundImage: NetworkImage(data.docs[index]["userProfile"]),
                                                                              ),
                                                                              SizedBox(width: AppSize.scrWidth * 0.03),
                                                                              Expanded(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      data.docs[index]["userName"],
                                                                                      style: TextStyle(
                                                                                          fontSize: AppSize.scrWidth * 0.03, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    Text(data.docs[index]["comment"]),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: AppSize.scrHeight*0.03,
                                                                                    width: AppSize.scrWidth*0.08,
                                                                                    child: LikeAnimation(
                                                                                      isAnimating: data.docs[index]["like"].contains(currentUserId),
                                                                                      smallLike: true,
                                                                                      child: IconButton(
                                                                                        icon: data.docs[index]["like"].contains(currentUserId)
                                                                                            ? Icon(
                                                                                          Icons.favorite,
                                                                                          color: Colors.red,
                                                                                          size: AppSize.scrWidth * 0.04,
                                                                                        )
                                                                                            : Icon(
                                                                                          Icons.favorite_outline,
                                                                                          color: Colors.grey,
                                                                                          size: AppSize.scrWidth * 0.04,
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          likeComment(
                                                                                            data.docs[index]["postId"],
                                                                                            data.docs[index]["commentId"],
                                                                                            currentUserId,
                                                                                            data.docs[index]["like"],
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  data.docs[index]['like'].length!=0? Text( data.docs[index]['like'].length.toString(),
                                                                                    style: TextStyle(fontSize: AppSize.scrWidth * 0.03),
                                                                                  ):const Text("")
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                      separatorBuilder: (BuildContext context, int index) {
                                                                        return SizedBox(height: AppSize.scrHeight*0.015,);
                                                                      },
                                                                    ),
                                                                  );
                                                              }
                                                          )
                                                      ),

                                                      Padding(
                                                        padding:  EdgeInsets.only(
                                                          right: AppSize.scrWidth*0.04,
                                                          left: AppSize.scrWidth*0.04,
                                                          bottom: MediaQuery.of(context).viewInsets.bottom,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: AppSize.scrWidth*0.75,
                                                              child: TextFormField(
                                                                controller:commentController,
                                                                focusNode:focusNode,
                                                                onChanged: (value) {
                                                                  ref.read(isChangedData.notifier).state=true;
                                                                },
                                                                keyboardType: TextInputType.multiline,
                                                                style: TextStyle(
                                                                  fontSize: AppSize.scrWidth*0.04,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                                decoration: InputDecoration(
                                                                  labelText:"Add a comment...",
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
                                                                addComment(data[index].id);
                                                              },
                                                              child:  Container(
                                                                height: AppSize.scrWidth*0.12,
                                                                width: AppSize.scrWidth*0.12,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(AppSize.scrWidth*0.02),
                                                                  color: Colors.blueAccent,
                                                                ),
                                                                child: const Icon(Icons.arrow_upward,color: Colors.white,),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                      // Padding(
                                                      //   padding: const EdgeInsets.all(8.0),
                                                      //   child: Row(
                                                      //     children: [
                                                      //       Expanded(
                                                      //         child: TextFormField(
                                                      //           controller: commentController,
                                                      //           keyboardType: TextInputType.multiline,
                                                      //           decoration: InputDecoration(
                                                      //             hintText: "Add a comment...",
                                                      //             border: OutlineInputBorder(
                                                      //               borderRadius: BorderRadius.circular(30),
                                                      //               borderSide: BorderSide.none,
                                                      //             ),
                                                      //             filled: true,
                                                      //             fillColor: Colors.grey[200],
                                                      //             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //       CircleAvatar(
                                                      //         child: IconButton(
                                                      //             icon: const Icon(Icons.send, color: Colors.black),
                                                      //             onPressed: () {
                                                      //               addComment(data[index].id);
                                                      //             }
                                                      //         ),
                                                      //       ),
                                                      //     ],
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );

                                          },
                                          child: SizedBox(
                                            height: AppSize.scrHeight * 0.036,
                                            width: AppSize.scrWidth * 0.08,
                                            child: SvgPicture.asset(iconConst.comment, fit: BoxFit.fill),
                                          ),
                                        ),
                                        SizedBox(width: AppSize.scrWidth * 0.02),
                                        // SizedBox(
                                        //   height: AppSize.scrHeight * 0.03,
                                        //   width: AppSize.scrWidth * 0.06,
                                        //   child: SvgPicture.asset(iconConst.share),
                                        // ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          savePost(data[index].id,currentUserId,data[index]["saveUser"])
                                      ,
                                      icon: data[index]["saveUser"].contains(currentUserId) ?
                                      SizedBox(
                                          height: AppSize.scrHeight * 0.03,
                                          width: AppSize.scrWidth * 0.08,
                                          child: SvgPicture.asset(iconConst.filledBookmark,color: Colors.black,fit: BoxFit.fill,))
                                          : SizedBox(
                                          height: AppSize.scrHeight * 0.025,
                                          width: AppSize.scrWidth * 0.07,
                                          child: SvgPicture.asset(iconConst.save,color: Colors.black,)),

                                    )
                                  ],
                                ),
                                SizedBox(height: AppSize.scrWidth * 0.01),
                                Row(
                                  children: [
                                    Text("${data[index]["like"].length.toString()} Likes",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSize.scrWidth * 0.01),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      showDragHandle: true,
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: AppSize.scrHeight*0.6,
                                          child: Column(
                                            children: [
                                              const Text("Comments",style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),),
                                              Expanded(
                                                  child: StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore.instance.collection('post').doc(data[index].id)
                                                          .collection('comments')
                                                          .where('postId',isEqualTo: data[index].id)
                                                          .where('delete',isEqualTo: false)
                                                          .orderBy('date',descending: true)
                                                          .snapshots(),
                                                      builder: (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return const Center(child:CircularProgressIndicator());
                                                        }
                                                        var cmdDoc = snapshot.data!.docs;
                                                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                                                        //   setState(() {
                                                        //     cmdCount = cmdDoc.length;
                                                        //   });
                                                        // });
                                                        return
                                                          SizedBox(
                                                            child: cmdDoc.isEmpty? const Center(child: Text("No comments yet!")):
                                                            ListView.separated(
                                                              padding: const EdgeInsets.all(8.0),
                                                              shrinkWrap: true,
                                                              itemCount:cmdDoc.length,
                                                              itemBuilder: (context, index) {
                                                                return GestureDetector(
                                                                  onLongPress: () {
                                                                    showDialog(
                                                                      barrierDismissible: false,
                                                                      context: context,
                                                                      builder: (context) {
                                                                        return AlertDialog(
                                                                          title: Text(" Do you want to delete this comment?",
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
                                                                                  deleteComments(cmdDoc[index]["commentId"],cmdDoc[index]["postId"]);
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
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      cmdDoc[index]["userProfile"] == ""
                                                                          ? const CircleAvatar(
                                                                        backgroundImage: AssetImage("assets/images/person.png"),
                                                                      )
                                                                          : CircleAvatar(
                                                                        backgroundImage: NetworkImage(cmdDoc[index]["userProfile"]),
                                                                      ),
                                                                      SizedBox(width: AppSize.scrWidth * 0.03),
                                                                      Expanded(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              cmdDoc[index]["userName"],
                                                                              style: TextStyle(
                                                                                  fontSize: AppSize.scrWidth * 0.03, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(cmdDoc[index]["comment"]),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                            height: AppSize.scrHeight*0.03,
                                                                            width: AppSize.scrWidth*0.08,
                                                                            child: LikeAnimation(
                                                                              isAnimating: cmdDoc[index]["like"].contains(currentUserId),
                                                                              smallLike: true,
                                                                              child: IconButton(
                                                                                icon: cmdDoc[index]["like"].contains(currentUserId)
                                                                                    ? Icon(
                                                                                  Icons.favorite,
                                                                                  color: Colors.red,
                                                                                  size: AppSize.scrWidth * 0.04,
                                                                                )
                                                                                    : Icon(
                                                                                  Icons.favorite_outline,
                                                                                  color: Colors.grey,
                                                                                  size: AppSize.scrWidth * 0.04,
                                                                                ),
                                                                                onPressed: () {
                                                                                  likeComment(
                                                                                    cmdDoc[index]["postId"],
                                                                                    cmdDoc[index]["commentId"],
                                                                                    currentUserId,
                                                                                    cmdDoc[index]["like"],
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          cmdDoc[index]['like'].length!=0? Text( cmdDoc[index]['like'].length.toString(),
                                                                            style: TextStyle(fontSize: AppSize.scrWidth * 0.03),
                                                                          ):const Text("")
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),

                                                                );
                                                              },
                                                              separatorBuilder: (BuildContext context, int index) {
                                                                return SizedBox(height: AppSize.scrHeight*0.015,);
                                                              },
                                                            ),
                                                          );
                                                      }
                                                  )
                                              ),
                                              Padding(
                                                padding:  EdgeInsets.only(
                                                  right: AppSize.scrWidth*0.04,
                                                  left: AppSize.scrWidth*0.04,
                                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: AppSize.scrWidth*0.75,
                                                      child: TextFormField(
                                                        controller:commentController,
                                                        focusNode:focusNode,
                                                        onChanged: (value) {
                                                          ref.read(isChangedData.notifier).state=true;
                                                        },
                                                        keyboardType: TextInputType.multiline,
                                                        style: TextStyle(
                                                          fontSize: AppSize.scrWidth*0.04,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        decoration: InputDecoration(
                                                          labelText:"Add a comment...",
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
                                                        addComment(data[index].id);
                                                      },
                                                      child:  Container(
                                                        height: AppSize.scrWidth*0.12,
                                                        width: AppSize.scrWidth*0.12,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(AppSize.scrWidth*0.02),
                                                          color: Colors.blueAccent,
                                                        ),
                                                        child: const Icon(Icons.arrow_upward,color: Colors.white,),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                  },
                                  child:    const Row(
                                    children: [
                                      Text('Comments',style:TextStyle(
                                          color: Colors.grey
                                      ),),
                                    ],
                                  ),
                                ),
                                SizedBox(height: AppSize.scrWidth * 0.01),
                                ReadMoreText(
                                  data[index]["description"],
                                  // trimMode: TrimMode.Line,
                                  trimLines: 2,
                                  colorClickableText: Colors.pink,
                                  trimCollapsedText: 'more',
                                  trimExpandedText: 'less',
                                  moreStyle: const TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  lessStyle: const TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: AppSize.scrHeight*0.02,
                      );
                    },
                  ) ;

                }
            ),
        
          ],
        ),
      ),

    );
  }
}
