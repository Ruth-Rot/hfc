
import 'package:flutter/material.dart';

class DishController {
  final String? id;
  late bool isEdit = false;
    late GlobalKey<FormState> formKey = GlobalKey<FormState>();
    late TextEditingController ckalController =
      TextEditingController();
       late TextEditingController proteinController =
      TextEditingController();
       late TextEditingController crabsController =
      TextEditingController();
       late TextEditingController fatsController =
      TextEditingController();

  DishController({
    this.id,
  });  

clear(){
   ckalController.clear();
   proteinController.clear();
   crabsController.clear();
   fatsController.clear();
}
  }

