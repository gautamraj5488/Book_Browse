import 'package:flutter/material.dart';

class WaveDotsWidget extends StatefulWidget {
  final Color color;
  final double dotSize;
  final int dotCount;
  final Duration duration;

  const WaveDotsWidget({
    Key? key,
    this.color = Colors.blue,
    this.dotSize = 10.0,
    this.dotCount = 5,
    this.duration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  _WaveDotsWidgetState createState() => _WaveDotsWidgetState();
}

class _WaveDotsWidgetState extends State<WaveDotsWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculating width based on dot size and spacing
    double totalWidth = widget.dotCount * widget.dotSize + (widget.dotCount - 1) * 8;

    return Container(
      width: totalWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.dotCount, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              
              double offsetY = 8 * (0.5 - 0.5 * (_controller.value * 2 - 1).abs()) * (1 - index * 0.1);
              return Transform.translate(
                offset: Offset(0, -offsetY),
                child: child,
              );
            },
            child: Container(
              width: widget.dotSize,
              height: widget.dotSize,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}