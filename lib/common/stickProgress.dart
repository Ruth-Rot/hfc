import 'package:flutter/material.dart';

class StickProgress extends StatefulWidget {
  final String ingredient;
  final double progress, height;
  final Color progressColor;

  const StickProgress({super.key, required this.ingredient, required this.progress, required this.height, required this.progressColor});

  @override
  State<StatefulWidget> createState() {
        return __StickProgressState();

  }
}

   class __StickProgressState extends State<StickProgress>{
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 40,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: widget.height,
                    width: 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.transparent,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: widget.height * widget.progress,
                      width: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: widget.progressColor,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        Text(
          widget.ingredient.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
  
  
}

