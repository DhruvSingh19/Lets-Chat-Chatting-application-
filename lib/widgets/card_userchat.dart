import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/helper/constants.dart';
import 'package:lets_chat/helper/helperutils.dart';
import 'package:lets_chat/models/chatmodels.dart';
import 'package:lets_chat/models/messagemodels.dart';
import 'package:lets_chat/screens/chatscreen.dart';
import 'package:lets_chat/widgets/dialogs/profile_dialog.dart';

class Card_userchat extends StatefulWidget {
  final ChatModels user;
  const Card_userchat({super.key, required this.user});

  @override
  State<Card_userchat> createState() => _Card_userchatState();
}

class _Card_userchatState extends State<Card_userchat> {
  Message? message;
  final TextStyle _style = const TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Card(
        elevation: 5,
        color: Colors.grey.shade800,
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => chatscreen(user: widget.user)));
            },
            child: StreamBuilder(
              stream: constant.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) message = list[0];
                return ListTile(
                    leading: InkWell(
                      onTap: (){
                        showDialog(context: context, builder: (_)=> profileDialog(user: widget.user));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          width: 40,
                          height: 40,
                          imageUrl: widget.user.image,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.user.name,
                      style: _style,
                    ),
                    subtitle: Text(
                      message != null
                          ? message!.type == Type.image
                              ? 'image'
                              : message!.msg
                          : widget.user.about,
                      style: _style,
                      maxLines: 1,
                    ),
                    trailing: message == null
                        ? null
                        : message!.read.isEmpty &&
                                message!.fromid != constant.user.uid
                            ? Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade400,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )
                            : Text(
                                helperutils.getLastMessageTime(
                                    context: context, time: message!.sent),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ));
              },
            )),
      ),
    );
  }
}
