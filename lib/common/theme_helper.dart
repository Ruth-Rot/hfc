import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ThemeHelper {
  InputDecoration textInputDecoration(
      [String labelText = "", String hintText = "", Icon? icon]) {
    double circular = 100.0;
    double circularEdgesWidth = 10.0;
    double circularEdgeHeight = 20.0;
    double width = 2.0;
    MaterialColor error = Colors.red;
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: icon,
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(circularEdgeHeight,
          circularEdgesWidth, circularEdgeHeight, circularEdgesWidth),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(circular),
          borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(circular),
          borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(circular),
          borderSide: BorderSide(color: error, width: width)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(circular),
          borderSide: BorderSide(color: error, width: width)),
    );
  }

  InputDecoration textInputDecorationFoodForm(
      [String labelText = "", String hintText = "", Icon? icon]) {
    double circular = 10.0;
    double circularEdges = 5.0;
    double width = 2.0;
    MaterialColor error = Colors.red;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: icon,
      fillColor: Colors.white,
      filled: true,
      contentPadding:
          EdgeInsets.fromLTRB(circular, circularEdges, circular, circularEdges),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(circular),
          borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(circular),
          borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(circular),
          borderSide: BorderSide(color: error, width: width)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(circular),
          borderSide: BorderSide(color: error, width: width)),
    );
  }

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

  Widget squareTile(IconData icon, Color color, action) {
    return GestureDetector(
      onTap: action(),
      child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200],
          ),
          child: FaIcon(
            icon,
            color: color,
          )),
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
