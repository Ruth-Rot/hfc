// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hfc/models/user.dart';

// import '../reposiontrys/user_reposiontry.dart';

// class myDrawerHeader extends StatefulWidget{
//   @override
//     _DrawerHeaderState createState( )=> _DrawerHeaderState();
//   }

// class _DrawerHeaderState extends State<myDrawerHeader> {
//   late UserModel user ;
  
//    bool isUser = false;
//   late ImageProvider profile;
//   late String name ="";
//   late String email="";
  
//   @override
//   void initState() {
//   Future.delayed(Duration(seconds: 1), () {
//       UserReposiontry()
//           .getUserDetails(FirebaseAuth.instance.currentUser!.email!)
//           .then((instance) {
//         user = instance;
//         if (this.mounted) {
//           setState(() {
//             isUser = true;    
//             name = user.fullName;
//             email = user.email;
//             profile = NetworkImage(user.urlImage);
//           });
//         }
//       });
//     });    super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
   
//    return Container(
//     color: Colors.indigo,
//     width: double.infinity,
//     height: 200,
//     padding: EdgeInsets.only(top: 20.0),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         profileCircle(),
//         Text(name,style: TextStyle(color:Colors.white,fontSize: 20),),
//        Text(email,style: TextStyle(color:Colors.grey[200],fontSize: 14),),

//       ]),
//    );
//   }

//   Container profileCircle() {
//     if(isUser == true){
//     return Container(
//         margin: EdgeInsets.only(bottom: 10),
//         height: 70,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           image: DecorationImage(image: profile)
//         ),
//       );
//     }
//     else{
//        return Container(
//         margin: EdgeInsets.only(bottom: 10),
//         height: 70,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//         ),
//       );
//     }
//   }
// }