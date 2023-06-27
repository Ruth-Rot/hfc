
import 'package:flutter/material.dart';

class ActivityController {
  final String? id;
  late bool isEdit = false;
    late GlobalKey<FormState> formKey = GlobalKey<FormState>();
    late TextEditingController ckalController =
      TextEditingController();
      

  ActivityController({
    this.id,
  });  

clear(){
   ckalController.clear();
}
  }

