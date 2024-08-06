import 'package:flutter/material.dart';
import 'package:lets_chat/helper/constants.dart';
import 'package:lets_chat/screens/homescreen.dart';
import 'package:lets_chat/screens/loginscreen.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      if(constant.auth.currentUser!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const loginscreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/icon.png'),
                  fit: BoxFit.cover,
                )
              ),
            ),
          ),

          SizedBox(height: 50,),

          const Align(
            alignment: Alignment.center,
            child: Text("Lets Chat",style: (TextStyle(fontSize: 40,fontWeight: FontWeight.w800)),),
          )
        ],
      ),
    );
  }
}
