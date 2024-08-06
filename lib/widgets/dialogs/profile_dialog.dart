import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/models/chatmodels.dart';
import 'package:lets_chat/screens/viewprofilescreen.dart';

class profileDialog extends StatelessWidget {
  const profileDialog({super.key, required this.user});
  final ChatModels user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        width: 300,
        height: 300,
        child: Stack(children: [
          Text(
            user.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(140),
              child: CachedNetworkImage(
                width: 280,
                fit: BoxFit.cover,
                imageUrl: user.image,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => viewprofilescreen(user: user)));
                  },
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.black,
                    size: 30,
                  )))
        ]),
      ),
    );
  }
}
