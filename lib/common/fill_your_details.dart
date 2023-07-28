import 'package:flutter/material.dart';

fillYourDetails(){
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
            //  SizedBox(height: 50,),
              // SizedBox(
              //   width: 340,
              //   child: Text(
              //     "👋 Incomplete Personal Details!",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              //   ),
              // ),
              //  SizedBox(
              //   width: 340,
              //   child: Text(
              //     "Fill in your personal details now for a better app experience. 📝👤",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              //   ),
              // ),
              SizedBox(
                  height: 540,
                  child:
                      Image(image: AssetImage('./assets/images/fill details.png'))),
            //   SizedBox(
            //     height: 30,
            //   ),
            //   Text("Fill your details in the chat bot",
            //       textAlign: TextAlign.center,
            //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
            //  ,             SizedBox(height: 50,),

            ],
          ),
        ),
  );
}