import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lets_chat/helper/helperutils.dart';
import 'package:lets_chat/models/messagemodels.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/models/chatmodels.dart';
import 'package:lets_chat/helper/constants.dart';
import 'package:lets_chat/screens/viewprofilescreen.dart';
import 'package:lets_chat/widgets/message_card.dart';

class chatscreen extends StatefulWidget {
  final ChatModels user;
  const chatscreen({super.key, required this.user});

  @override
  State<chatscreen> createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  List<Message> list = [];
  final textController = TextEditingController();
  bool isShowEmoji = false;
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder(
            stream: constant.getAllMessages(widget.user),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const SizedBox();

                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  //print('${jsonEncode(data![0].data())}');
                  //converting firestore data in list format
                  list =
                      data?.map((e) => Message.fromJson(e.data())).toList() ??
                          [];
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        // return Card_userchat(
                        //   user: isSearching ? search_list[index] : list[index],
                        return messagecard(
                          message: list[index],
                        );
                      },
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                    );
                  } else {
                    return const Center(
                        child: Text(
                      "Say Hello!!",
                      style: TextStyle(fontSize: 20),
                    ));
                  }
              }
            },
          ),
        ),
        if (isUploading)
          const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ))),
        _chatInput(),
      ]),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 5.0, top: 0, right: 5.0, bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(7),
                child: Card(
                  color: Colors.grey.shade700,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // setState(() {
                          //   isShowEmoji = !isShowEmoji;
                          // });
                          // if (isShowEmoji) {
                          //   Expanded(
                          //     child: SizedBox(
                          //       height: 200,
                          //       child: EmojiPicker(
                          //         textEditingController: textController, // Pass the same TextEditingController used for your input field (usually a TextFormField)
                          //         config: Config(
                          //           height: 200,
                          //        // bgColor: const Color(0xFFF2F2F2),
                          //                               checkPlatformCompatibility: true,
                          //                               emojiViewConfig: EmojiViewConfig(
                          //                               emojiSizeMax: 100
                          //                               ),
                          //       ),
                          //     )),
                          //   );
                          // }
                        },
                        icon: Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey.shade300,
                          size: 28,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: textController,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Message...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade200,
                              fontSize: 20,
                            ),
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final ImagePicker imagepicked = ImagePicker();
                          final List<XFile> images = await imagepicked
                              .pickMultiImage(imageQuality: 70);
                          if (images.isNotEmpty) {
                            for (var i in images) {
                              setState(() {
                                isUploading = true;
                              });
                              await constant.sendChatImage(
                                  widget.user, File(i.path));
                              setState(() {
                                isUploading = false;
                              });
                            }
                          }
                        },
                        icon: Icon(
                          Icons.image,
                          color: Colors.grey.shade300,
                          size: 28,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final ImagePicker imagepicked = ImagePicker();
                          final XFile? image = await imagepicked.pickImage(
                              source: ImageSource.camera, imageQuality: 70);
                          if (image != null) {
                            setState(() {
                              isUploading = true;
                            });
                            await constant.sendChatImage(
                                widget.user, File(image.path));
                            setState(() {
                              isUploading = false;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.grey.shade300,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          MaterialButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                constant.sendMessage(
                    widget.user, textController.text, Type.text);
                textController.text = '';
              }
            },
            minWidth: 0,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(13),
            color: Colors.grey.shade700,
            child: const Icon(Icons.send, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {
        print("hello");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>viewprofilescreen(user: widget.user)));
      },
      child: StreamBuilder(
          stream: constant.getUserInfo(widget.user),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatModels.fromJson(e.data())).toList() ??
                    [];
            return Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  child: Row(
                    children: [
                      Center(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          width: 45,
                          height: 45,
                          imageUrl:
                              list.isNotEmpty ? list[0].image : widget.user.image,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            list.isNotEmpty ? list[0].name : widget.user.name,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Text(
                            list.isNotEmpty
                                ? list[0].isOnline
                                    ? 'Online'
                                    : helperutils.getLastActiveTime(context: context, lastActive: list[0].lastActive)
                                : helperutils.getLastActiveTime(context: context, lastActive: widget.user.lastActive),
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
