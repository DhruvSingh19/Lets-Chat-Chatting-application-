import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/helper/constants.dart';
import 'package:lets_chat/helper/helperutils.dart';
import 'package:lets_chat/models/messagemodels.dart';

class messagecard extends StatefulWidget {
  final Message message;
  const messagecard({super.key, required this.message});

  @override
  State<messagecard> createState() => _messagecardState();
}

class _messagecardState extends State<messagecard> {
  @override
  Widget build(BuildContext context) {
    return constant.user.uid == widget.message.fromid
        ? _greenmessage()
        : _bluemessage();
  }

  Widget _bluemessage() {
    if (widget.message.read.isEmpty) {
      constant.updatemessagereadstatus(widget.message);
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
        padding: EdgeInsets.only(top: 15, left: 15),
        child: Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade400,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                border: Border.all(color: Colors.grey.shade900)),
            padding: EdgeInsets.fromLTRB(
                widget.message.type == Type.text ? 12.0 : 2.0,
                widget.message.type == Type.text ? 12.0 : 8.0,
                widget.message.type == Type.text ? 12.0 : 2.0,
                widget.message.type == Type.text ? 12.0 : 8.0
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 19, color: Colors.white),
                  )
                : ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                width: 220,
                height: 220,
                imageUrl: widget.message.msg,
                placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2,),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image,
                  size: 70,
                ),
              ),
            ),
          ),
        ),
      ),
      Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            helperutils.getformatteddate(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ))
    ]);
  }

  Widget _greenmessage() {
    //message sent by us
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        const SizedBox(
          width: 20,
        ),
        if (widget.message.read.isNotEmpty)
          const Icon(
            Icons.done_all_rounded,
            size: 22,
            color: Colors.blue,
          ),
        const SizedBox(width: 2),
        Text(
          helperutils.getformatteddate(
              context: context, time: widget.message.sent),
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ]),
      Padding(
        padding: EdgeInsets.only(top: 15, right: 15),
        child: Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.green.shade400,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                border: Border.all(color: Colors.grey.shade900)),
            padding: EdgeInsets.fromLTRB(
                widget.message.type == Type.text ? 12.0 : 2.0,
                widget.message.type == Type.text ? 12.0 : 8.0,
                widget.message.type == Type.text ? 12.0 : 2.0,
                widget.message.type == Type.text ? 12.0 : 8.0
            ),

            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 19, color: Colors.white),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      width: 220,
                      height: 220,
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2,),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    ]);
  }
}
