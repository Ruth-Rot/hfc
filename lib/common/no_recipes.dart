import 'package:flutter/material.dart';

noRecipes(){
  return Container(
    width: 370,
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
    child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 540,
                  child:
                      Image(image: AssetImage('./assets/images/no recipes.png'))),
                     ],
          ),
        ),
  );
}