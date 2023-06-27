import 'dart:math';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:get/get.dart';


class DialogReposiontry extends GetxController {
  static DialogReposiontry get instance => Get.find();

  late DialogFlowtter dialogFlowtter;
  late DialogAuthCredentials credentials;
  late String sessionId;
  final String credentialsPath = "assets/dialog_flow_auth.json";

  createDialogRep() async {
    credentials = await DialogAuthCredentials.fromFile(credentialsPath);
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
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
  }
}
