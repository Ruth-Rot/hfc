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
              SizedBox(height: 50,),
              SizedBox(
                width: 340,
                child: Text(
                  "You haven't fill your personal details yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                  height: 250,
                  child:
                      Image(image: AssetImage('./assets/images/splash_bot.png'))),
              SizedBox(
                height: 30,
              ),
              Text("Fill your details in the chat bot",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
             ,             SizedBox(height: 50,),

            ],
          ),
        ),
  );
}