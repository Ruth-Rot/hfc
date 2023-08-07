
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hfc/pages/home_page.dart';
import 'package:hfc/pages/splash_screen.dart';

class AuthReposiontry extends GetxController{
static AuthReposiontry get instance => Get.find();

final auth = FirebaseAuth.instance;
late final Rx<User?> firebaseUser;

@override
void onReady(){
  firebaseUser = Rx<User?>(auth.currentUser);
  firebaseUser.bindStream(auth.userChanges());
 ever(firebaseUser, (_setInitalScreen));
}
_setInitalScreen(User? user){
  user == null ? Get.offAll(()=> const SplashScreen(title: 'HFC Login') ): Get.offAll(()=>  HomePage());
}
}