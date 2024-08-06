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

class viewprofilescreen extends StatefulWidget {
  final ChatModels user;
  const viewprofilescreen({super.key, required this.user});

  @override
  State<viewprofilescreen> createState() => _viewprofilescreenState();
}

class _viewprofilescreenState extends State<viewprofilescreen> {

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
          title: Text(widget.user.name),
        ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                const Text("Joined On: ",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w500),),
                Text(
                  helperutils.getLastMessageTime(context: context, time: widget.user.createdAt, showYear: true),
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
              ]),
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Center(
                child: ClipRRect(//get local image from server
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  const Text("About: ",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w500),),
                  Text(
                  widget.user.about,
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
              ]),


            ],
          ),
        ),
      ),
    );
  }

}

