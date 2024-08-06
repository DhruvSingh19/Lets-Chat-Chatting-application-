import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_chat/helper/constants.dart';
import 'package:lets_chat/models/chatmodels.dart';
import 'package:lets_chat/screens/profilescreen.dart';
import '../widgets/card_userchat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Saves list of aall users except us
  List<ChatModels> list = [];

  // Saves list of all searched-Match users
  final List<ChatModels> search_list = [];

  //Sees whether searching is on or not to change ui
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    constant.getmyinfo();
    SystemChannels.lifecycle.setMessageHandler((message){
      //active,paused,resume
      if(constant.auth.currentUser != null){
        if(message.toString().contains('resume')) {
          constant.updateActiveStatus(true);
        }
        if(message.toString().contains('pause')) {
          constant.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),

      child: PopScope(
        canPop: !isSearching,
        onPopInvoked: (didPop){
          if(isSearching){
            setState(() {
              isSearching=!isSearching;
            });
          }else{
          }
        },

        child: Scaffold(
          backgroundColor: Colors.grey.shade400,
          //appbar
          appBar: AppBar(
            leading: const Icon(
              CupertinoIcons.home,
              color: Colors.white,
            ),
            title: isSearching
                ? TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Name, email",
                    ),
                    autofocus: true,
                    style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                    onChanged: (val) {
                      search_list.clear();
                      for (var i in list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          search_list.add(i);
                        }
                      }
                      setState(() {
                        search_list;
                      });
                    },
                  )
                : const Text("Lets Chat"),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                icon: Icon(isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              profilescreen(user: constant.myinfo)));
                },
                icon: const Icon(Icons.more_vert),
                color: Colors.white,
              )
            ],
          ),

          //floating action button
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30.0, right: 20.0),
            child: FloatingActionButton(
              backgroundColor: Colors.grey.shade900,
              onPressed: () async {
              },
              child: const Icon(
                Icons.add_comment_rounded,
                color: Colors.white,
              ),
            ),
          ),

          body: StreamBuilder(
            stream: constant.getAllUsersExceptUs(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  //converting firestore data in list format
                  list = data?.map((e) => ChatModels.fromJson(e.data())).toList() ??
                      [];
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Card_userchat(
                          user: isSearching ? search_list[index] : list[index],
                        );
                      },
                      physics: const BouncingScrollPhysics(),
                      itemCount: isSearching ? search_list.length : list.length,
                    );
                  } else {
                    return const Center(
                        child: Text(
                      "No data found!!",
                      style: TextStyle(fontSize: 20),
                    ));
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
