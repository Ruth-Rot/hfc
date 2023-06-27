import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class RadialProgress extends StatefulWidget {
  final double height, width, progress;
  final double remain;

  const RadialProgress(
      {Key? key,
      required this.height,
      required this.width,
      required this.progress,
      required this.remain})
      : super(key: key);

       @override
  State<StatefulWidget> createState() {
       return _RadialProgressState();
  }
}
class _RadialProgressState extends State<RadialProgress> {
  @override
  Widget build(BuildContext context) {
      Color? color = widget.remain.isNegative? Colors.red[900]: const Color(0xFF200087);
    return CustomPaint(
      painter: _RadialPainter(
        progress: widget.progress,
      ),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.remain.abs().toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: widget.remain.isNegative?"kcal passed":"kcal left",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color:color      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
 
}

class _RadialPainter extends CustomPainter {
  final double progress;

  _RadialPainter({required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = const Color(0xFF200087)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
  
      math.radians(-relativeProgress),
      
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
