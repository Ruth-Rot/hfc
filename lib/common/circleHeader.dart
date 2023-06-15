import 'package:flutter/material.dart';

Container circleHeader(BuildContext context, Widget widget ) {
    return Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.indigo,
                boxShadow: const [BoxShadow(blurRadius: 40.0)],
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                        MediaQuery.of(context).size.width, 100.0)),
              ),
              child: Column(
                children: [
                  widget,
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            );
  }