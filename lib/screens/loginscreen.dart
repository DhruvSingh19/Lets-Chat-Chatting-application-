import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lets_chat/helper/constants.dart';
import 'package:lets_chat/helper/helperutils.dart';
import 'package:lets_chat/screens/homescreen.dart';

class loginscreen extends StatefulWidget {
  const loginscreen({super.key});

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  bool isInternetOn = false;
  _ongooglebuttonclicked() {
    //show circular progress indicator
    helperutils.showCircularIndicator(context);

    signInWithGoogle().then((user) async {
      //hide circular progress indicator
      Navigator.pop(context);

      if (user != null) {
        print(user.user);
        print(user.additionalUserInfo);
        if (await constant.userExists()) {
        } else {
          constant.createUser();
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      isInternetOn = true;
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await constant.auth.signInWithCredential(credential);
    } catch (e) {
      if (!isInternetOn)
        helperutils.showSnackBar(context, "Check your internet connection!!");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/icon.png'),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.center,
            child: RichText(
              text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 25),
                  children: [
                    TextSpan(
                        text: "Welcome to ",
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: "Lets Chat",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ]),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          GestureDetector(
            onTap: () {
              _ongooglebuttonclicked();
            },
            child: Container(
              height: 70,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/google.png'),
                          fit: BoxFit.cover,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: RichText(
                      text: const TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 25),
                          children: [
                            TextSpan(
                                text: "Login with ",
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                            TextSpan(
                                text: "Google",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
