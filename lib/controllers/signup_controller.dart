

import 'package:flutter/material.dart';

class SignUpController{

  final email= TextEditingController();
  final password = TextEditingController();
  final fullname= TextEditingController();

  void clear(){
    email.clear();
    fullname.clear();
    password.clear();
  }


}