import 'dart:math';

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DialogReposiontry extends GetxController {
  static DialogReposiontry get instance => Get.find();

  late DialogFlowtter dialogFlowtter;
  late DialogAuthCredentials credentials;
  late String sessionId;
  final credentials_path = "assets/dialog_flow_auth.json";

  createDialogRep() async {
    credentials = await DialogAuthCredentials.fromFile(credentials_path);
    sessionId = generateSessionId();
    dialogFlowtter = DialogFlowtter(
      credentials: credentials,
      sessionId: sessionId,
    );
    
    return dialogFlowtter;
  }
  getSessionId(  )
  {
        return sessionId;

  }

  generateSessionId() {
    return getRandomString(12);
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))));
  }
}
