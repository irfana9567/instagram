import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/features/home/screen/home_screen.dart';
import 'package:instagram/features/home/screen/user_profiles/screen/user_account.dart';
import 'package:instagram/features/home/screen/widgets/customAppbar.dart';
import 'package:instagram/features/home/screen/widgets/lay_out.dart';
import 'package:instagram/model/user_model.dart';
import 'package:instagram/navigation/profile.dart';

import '../common/constants/constant.dart';
import '../features/home/controller/home_controller.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  TextEditingController searchController = TextEditingController();
  StateProvider searchKeyProvider =StateProvider((ref) => "");
 final isTapedonSearch=StateProvider((ref) => false,);
  @override
  Widget build(BuildContext context) {
    final searchKey = ref.watch(searchKeyProvider);
    final isTaponSearch = ref.watch(isTapedonSearch);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: Text("Search",style:  TextStyle(
          fontSize: AppSize.scrWidth*0.05,
          fontWeight: FontWeight.w900
         ),)),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.only(left: AppSize.scrWidth*0.05,right: AppSize.scrWidth*0.05,top: AppSize.scrWidth*0.05,),
              child: Container(
                height: AppSize.scrHeight*0.06,
                decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.scrWidth*0.02),
                    border: Border.all(color: Colors.grey)
                ),
                child:  TextFormField(
                  controller: searchController,
                  onChanged: (value) {
                    ref.read(isTapedonSearch.notifier).state=true;
                   ref.read(searchKeyProvider.notifier).state = value.trim();
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Color(0xff828282)),
                      // suffixIcon: searchController.text.isNotEmpty ? IconButton(
                      //   icon:
                      //   const Icon(Icons.cancel, color: Color(0xffB1B0B0)),
                      //   onPressed: () {
                      //     searchController.clear();
                      //     setState(() {});
                      //   },
                      // ) : null,
                      hintText: 'Search',
                      // hintStyle: GoogleFonts.urbanist(
                      //   fontWeight: FontWeight.w500,
                      //   fontSize: height * 0.015,
                      //   color: Palette.greyColor,
                      // ),
                      filled: true,
                      fillColor: Colors.white,
                      enabled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSize.scrWidth * 0.03,
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSize.scrWidth * 0.03,),
                          borderSide: BorderSide.none)),
                      // onChanged: (text) {
                  //   String trimmedValue = text;
                  //   // Update the controller's value with the trimmed value
                  //   search.value = search.value.copyWith(
                  //     text: trimmedValue,
                  //     selection:
                  //     TextSelection.collapsed(offset: trimmedValue.length),
                  //   );
                  //   setState(() {});
                  // },
                ),
              ),
            ),
            SizedBox(height: AppSize.scrHeight*0.03,),
            isTaponSearch?
            SizedBox(
              width: AppSize.scrWidth,
              height: AppSize.scrWidth*0.68,
              child: Consumer(
                  builder: (context,ref,child) {
                    Map data={'search':searchKey};
                    final usersData = ref.watch(getUsersStream(json.encode(data)));
                    return usersData.when(data: (data) {
                      return data.isEmpty
                          ?const Center(child: Text("No user!"))
                          :ListLayout(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                currentUserId==data[index].id ? Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(selectedIndex: 3,),)):
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UserAccount(
                                    userProfile: data[index].profile,
                                    userName: data[index].userName,
                                    postCount: 0,
                                    userBio: data[index].bio,
                                    name: data[index].name,
                                    userId: data[index].id),));
                              },
                              child: SizedBox(
                                height: AppSize.scrHeight * 0.1,
                                width: AppSize.scrWidth * 1,
                                child: ListTile(
                                  leading: data[index].profile.isNotEmpty? CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(data[index].profile)
                                  ) :const CircleAvatar(
                                    radius: 28,
                                    backgroundImage:AssetImage("assets/images/person.png") ,
                                  ),
                                  title: Text(data[index].userName),
                                  subtitle: Text(data[index].name,style: const TextStyle(
                                    color: Colors.grey,
                                  ),),
                                  // trailing: const Icon(Icons.cancel_outlined),
                                ),
                              ),
                            );
                          }
                          );
                    },
                        error: (error, stackTrace) => Text(error.toString()),
                        loading: () => const Center(child: CircularProgressIndicator()));
                  }
              ),
            ):
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('post')
                  .orderBy('uploadDate')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SingleChildScrollView(
                  child: SizedBox(
                    height: AppSize.scrHeight*0.69,
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) => Image.network(
                        (snapshot.data! as dynamic).docs[index]['image'],
                        fit: BoxFit.cover,
                      ),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                  ),
                );
              },
            )
        
          ],
        ),
      ),
    );
  }
}
