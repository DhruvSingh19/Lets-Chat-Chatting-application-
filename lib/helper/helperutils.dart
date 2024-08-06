import 'package:flutter/material.dart';
class helperutils{
   static void showSnackBar(BuildContext context,String msg){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg),
     backgroundColor: Colors.black,
     behavior: SnackBarBehavior.floating,));
   }

   static void showCircularIndicator(BuildContext context){
     showDialog(context: (context),
         builder:(_)=>
          const Center(child: CircularProgressIndicator(
          ),)
         );
    }

    static String getformatteddate({required BuildContext context, required String time}){
     final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
     return TimeOfDay.fromDateTime(date).format(context);
    }

    static String getLastMessageTime({required BuildContext context, required String time ,bool showYear = false}){
      final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
      final now = DateTime.now();
      if(date.day == now.day && date.month == now.month && date.year == now.year){
        return TimeOfDay.fromDateTime(date).format(context);
      }

      return showYear ? '${date.day} ${getMonth(date)} ${date.year}' : '${date.day} ${getMonth(date)}';
    }

   static String getLastActiveTime(
       {required BuildContext context, required String lastActive}) {
     final int i = int.tryParse(lastActive) ?? -1;

     //if time is not available then return below statement
     if (i == -1) return 'Last seen not available';

     DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
     DateTime now = DateTime.now();

     String formattedTime = TimeOfDay.fromDateTime(time).format(context);
     if (time.day == now.day &&
         time.month == now.month &&
         time.year == time.year) {
       return 'Last seen today at $formattedTime';
     }

     if ((now.difference(time).inHours / 24).round() == 1) {
       return 'Last seen yesterday at $formattedTime';
     }

     String month = getMonth(time);

     return 'Last seen on ${time.day} $month on $formattedTime';
   }

   static String getMonth(DateTime date){
     switch(date.month){
       case 1: return 'Jan';
       case 2: return 'Feb';
       case 3: return 'Mar';
       case 4: return 'Apr';
       case 5: return 'May';
       case 6: return 'Jun';
       case 7: return 'Jul';
       case 8: return 'Aug';
       case 9: return 'Sep';
       case 10: return 'Oct';
       case 11: return 'Nov';
       case 12: return 'Dec';
     }
     return 'NA';
    }
}