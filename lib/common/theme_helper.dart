import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';

// green: Color.fromARGB(156, 156, 204, 101);
// pink: Color.fromARGB(255, 225, 171, 145);
//Color pink =const Color.fromARGB(255, 225, 171, 145);

class ThemeHelper {
  InputDecoration textInputDecoration(
      [String labelText = "", String hintText = "", Icon? icon]) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: icon,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  // InputDecoration passwordInputDecoration(
  //     [String labelText = "",
  //     String hintText = "",
  //     Icon? icon,
  //     ]) {
  //   return InputDecoration(
  //       labelText: labelText,
  //       hintText: hintText,
  //       prefixIcon: icon,
  //       fillColor: Colors.white,
  //       filled: true,
  //       contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
  //       focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(100.0),
  //           borderSide: const BorderSide(color: Colors.grey)),
  //       enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(100.0),
  //           borderSide: BorderSide(color: Colors.grey.shade400)),
  //       errorBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(100.0),
  //           borderSide: const BorderSide(color: Colors.red, width: 2.0)),
  //       focusedErrorBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(100.0),
  //           borderSide: const BorderSide(color: Colors.red, width: 2.0)),
  //       suffix: toggle
  //       ));
  

  BoxDecoration inputBoxDecorationShaddow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 5),
      )
    ]);
  }

  BoxDecoration buttonBoxDecoration(BuildContext context,
      [String color1 = "", String color2 = ""]) {
    // Color c1 = Theme.of(context).colorScheme.primary;
    // Color c2 = Theme.of(context).colorScheme.secondary;
    // if (color1.isEmpty == false) {
    //   c1 = HexColor(color1);
    // }
    // if (color2.isEmpty == false) {
    //   c2 = HexColor(color2);
    // }

    return BoxDecoration(
      boxShadow: const [
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
      ],
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(30),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      minimumSize: MaterialStateProperty.all(const Size(50, 50)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shadowColor: MaterialStateProperty.all(Colors.transparent),
    );
  }

  AlertDialog alartDialog(String title, String content, BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black38)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
  
}


