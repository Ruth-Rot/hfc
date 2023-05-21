import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String password;
  final String urlImage;
  final String gender;
  const UserModel(
      {this.id,
      required this.fullName,
      required this.email,
      required this.password,
      required this.urlImage,
      required this.gender});
    toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
      "gender": gender,
      "urlImage": urlImage,
    };
   
  }

 getId(){
      return id;
    }
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        fullName: data["fullName"],
        email: data["email"],
        password: data["password"],
        urlImage: data["urlImage"],
        gender: data["gender"]);
  }
}
