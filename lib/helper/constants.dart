import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lets_chat/models/chatmodels.dart';
import 'package:lets_chat/models/messagemodels.dart';

class constant {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //to access photos from firebase storage
  static FirebaseStorage firestorage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;

  static late ChatModels myinfo;

  //for accessing push notification
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async{
    await messaging.requestPermission();

    messaging.getToken().then((t) {
      if(t!=null){
        myinfo.pushToken = t;
        log('push token: $t');
      }
    });
  }


  static Future<void> getmyinfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        myinfo = ChatModels.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        updateActiveStatus(true);
      } else {
        constant.createUser().then((value) {
          getmyinfo();
        });
      }
    });
  }

  //returns list of users except us using the where clause
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsersExceptUs() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
    //where the firestore id is not equal to our user.uid
  }

  //for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatModels userhere) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: userhere.id)
        .snapshots();
    //where the firestore id is not equal to our user.uid
  }

  //update online and last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': myinfo.pushToken
    });
  }

  //check if user exists or not
  static Future<bool> userExists() async {
    return ((await firestore.collection('users').doc(user.uid).get()).exists);
  }

  //create a nwe user
  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final ChatModels newUser = ChatModels(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Hey there, I am using Lets Chat",
        createdAt: time,
        lastActive: time,
        id: user.uid,
        isOnline: false,
        pushToken: "",
        email: user.email.toString());
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(newUser.toJson());
  }

  //to update profile
  static Future<void> updateuser() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': myinfo.name, 'about': myinfo.about});
  }

  //to update photo
  static Future<void> updateprofilepicture(File file) async {
    //get image file extension using split
    final ext = file.path.split('.').last; //png,jpg

    //storage file ref with path
    final ref = firestorage.ref().child(
        'profilepictures/${user.uid}.$ext'); //creates folder name profilepictures

    //uploading image in firebase storgae
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log("Data transferred");
    });

    //upadte image in firestore myinfo
    myinfo.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': myinfo.image});
  }

  ///for getting all messages of a conversation
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatModels userhere) {
    return firestore
        .collection('chats/${getConversationid(userhere.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //for getting unique conversation id
  static String getConversationid(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
  //this function return uniques id for every conversation

  //for sending messages
  static Future<void> sendMessage(
      ChatModels userhere, String msg, Type type) async {
    final time = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); //message time also used as id

    final Message message = Message(
        msg: msg,
        toid: userhere.id,
        read: '',
        type: type,
        sent: time,
        fromid: user.uid);

    final ref = firestore
        .collection('chats/${getConversationid(userhere.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updatemessagereadstatus(Message message) async {
    firestore
        .collection('chats/${getConversationid(message.fromid)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatModels userhere) {
    return firestore
        .collection('chats/${getConversationid(userhere.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatModels userhere, File file) async {
    final ext = file.path.split('.').last; //png,jpg

    //storage file ref with path
    final ref = firestorage.ref().child(
        'images/${getConversationid(userhere.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext'); //creates folder name profilepictures

    //uploading image in firebase storgae
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log("Data transferred");
    });

    //upadte image in firestore myinfo
    final imageurl = await ref.getDownloadURL();
    await sendMessage(userhere, imageurl, Type.image);
  }
}
