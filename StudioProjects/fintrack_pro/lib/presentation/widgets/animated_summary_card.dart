import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedSummaryCard
    extends StatefulWidget {
  final String title;

  final double amount;

  const AnimatedSummaryCard({
    super.key,
    required this.title,
    required this.amount,
  });

  @override
  State<AnimatedSummaryCard>
  createState() =>
      _AnimatedSummaryCardState();
}

class _AnimatedSummaryCardState
    extends State<AnimatedSummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> animation;

  bool flipped = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration:
      const Duration(seconds: 2),
    );

    animation = Tween<double>(
      begin: 0,
      end: widget.amount,
    ).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();

        setState(() {
          flipped = !flipped;
        });
      },
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(flipped ? 0.1 : 0),
        child: Container(
          padding:
          const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(
              24,
            ),
            gradient:
            const LinearGradient(
              colors: [
                Colors.deepPurple,
                Colors.blue,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                '₹${animation.value.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}