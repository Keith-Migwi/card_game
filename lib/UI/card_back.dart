import 'package:flutter/material.dart';

class CardBack extends StatelessWidget {
  final double height;
  const CardBack({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AspectRatio(
        aspectRatio: 2.5 / 3.5, // Standard poker card ratio
        child: Card(
          shape: height < 80 ?  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ): RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          color: Colors.black,
          shadowColor: Colors.white,
          elevation: 1,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Center(
              child: CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter: _CirclePatternPainter(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CirclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw concentric circles
    double step = size.width * 0.12;
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, step * i, paint);
    }

    // Add a bold inner circle to emphasize the center
    final boldPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, step * 0.7, boldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
