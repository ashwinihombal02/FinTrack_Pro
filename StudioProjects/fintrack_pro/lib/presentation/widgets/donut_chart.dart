import 'dart:math';

import 'package:flutter/material.dart';

class DonutChart extends StatefulWidget {
  final List<double> values;

  const DonutChart({
    super.key,
    required this.values,
  });

  @override
  State<DonutChart> createState() =>
      _DonutChartState();
}

class _DonutChartState
    extends State<DonutChart> {
  int selected = -1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          selected =
              (selected + 1) %
                  widget.values.length;
        });
      },
      child: CustomPaint(
        painter: DonutPainter(
          widget.values,
          selected,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class DonutPainter extends CustomPainter {
  final List<double> values;

  final int selected;

  DonutPainter(
      this.values,
      this.selected,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final total =
    values.fold(0.0, (a, b) => a + b);

    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: 100,
    );

    double start = -pi / 2;

    final colors = [
      Colors.deepPurple,
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.pink,
    ];

    for (int i = 0; i < values.length; i++) {
      final sweep =
          (values[i] / total) * pi * 2;

      final mid = start + sweep / 2;

      final double dx =
      selected == i
          ? (cos(mid) * 12).toDouble()
          : 0.0;

      final double dy =
      selected == i
          ? (sin(mid) * 12).toDouble()
          : 0.0;

      canvas.save();

      canvas.translate(dx, dy);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 42
        ..color =
        colors[i % colors.length];

      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        paint,
      );

      canvas.restore();

      start += sweep;
    }
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return true;
  }
}