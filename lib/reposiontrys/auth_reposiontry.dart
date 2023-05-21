
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
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