

import 'package:flutter/material.dart';
//import 'package:get/get.dart';

class SignUpController{
// extends GetxController{
  //static SignUpController get instance => Get.find();

  final email= TextEditingController();
  final password = TextEditingController();
  final fullname= TextEditingController();

  void registerUser(String email, String password){

  }

  void clear(){
    this.email.clear();
    this.fullname.clear();
    this.password.clear();
  }


}