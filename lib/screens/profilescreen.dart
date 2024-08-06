import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_chat/helper/constants.dart';
import 'package:lets_chat/helper/helperutils.dart';
import 'package:lets_chat/models/chatmodels.dart';
import 'package:lets_chat/screens/loginscreen.dart';

class profilescreen extends StatefulWidget {
  final ChatModels user;
  const profilescreen({super.key, required this.user});

  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
  final _formkey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //on click on anyehere on screen hide keyboard
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: const Text("Profile Screen"),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 30.0, right: 20.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.grey.shade800,
            onPressed: () async {
              //show circular progress indicator
              helperutils.showCircularIndicator(context);
              await constant.updateActiveStatus(false);
              await FirebaseAuth.instance.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  //on both logout done pop circular progress indicator
                  Navigator.pop(context);
                  //then pop again so that we move to home screen, always we will have only homescreen before profile screen
                  Navigator.pop(context);
                  constant.auth = FirebaseAuth.instance;
                  //replace home screen with login screen
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const loginscreen()));
                });
              });
            },
            label: const Text(
              "LOGOUT",
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ),
        body: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Stack(
                      children: [
                        _image!=null ? ClipRRect(//get local immage from server
                          borderRadius: BorderRadius.circular(75),
                          child: Image.file(
                            File(_image!),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ):
                        ClipRRect(//get local immage from server
                          borderRadius: BorderRadius.circular(75),
                          child: CachedNetworkImage(
                            imageUrl: widget.user.image,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorWidget: (context,url,error)=>
                                const CircleAvatar(
                                  child: Icon(CupertinoIcons.person),
                                )
                          ),
                        ),


                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: () {
                          _showBottomSheet();
                        },
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: const Icon(Icons.edit),
                      ),
                    )
                  ]),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                    child: Text(
                      widget.user.email,
                      style: const TextStyle(fontSize: 17, color: Colors.white),
                    )),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                  child: TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => constant.myinfo.name = val ?? "",
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : "Required Field",
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Colors
                                .white), // Use a variable to control border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Focused border style
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Colors.black), // Black focused border
                      ),
                      hintText: 'eg. Happy Singh',
                      hintStyle: const TextStyle(color: Colors.white),
                      label: const Text(
                        "Name",
                        style: (TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                  child: TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => constant.myinfo.about = val ?? "",
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : "Required Field",
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Focused border style
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Colors.black), // Black focused border
                      ),
                      hintText: 'eg. Feeling Happy',
                      label: const Text(
                        "About",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor:
                    Colors.grey.shade800, // Set background color to black
                  ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      constant.updateuser().then((value) =>
                          helperutils.showSnackBar(
                              context, "Profile Updated Successfully!!"));
                    }
                  },
                  icon: const Icon(
                    Icons.update,
                    color: Colors.white,
                    size: 30,
                  ),
                  label: const Text(
                    "UPDATE",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          height: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  "Pick Profile Photo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async{
                      final ImagePicker imagepicked= ImagePicker();
                      final XFile? image = await imagepicked.pickImage(source: ImageSource.gallery);

                      if(image!=null){
                        setState(() {
                          _image = image.path;
                        });
                        constant.updateprofilepicture(File(_image!));
                        //to hide bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: CircleBorder(),
                      fixedSize: Size(120, 120),
                    ),
                    child: Image.asset('assets/images/profile1.png'),
                  ),

                  const SizedBox(width: 20,),

                  ElevatedButton(
                    onPressed: () async{
                      final ImagePicker imagepicked= ImagePicker();
                      final XFile? image = await imagepicked.pickImage(source: ImageSource.camera);
                      if(image!=null){
                        setState(() {
                          _image = image.path;
                        });
                        constant.updateprofilepicture(File(_image!));
                        //to hide bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: const Size(120, 120),
                    ),
                    child: Image.asset('assets/images/profile2.png'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

