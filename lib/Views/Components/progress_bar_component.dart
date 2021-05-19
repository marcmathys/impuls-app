import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/States/ekg_service.dart';

class ProgressRing extends StatefulWidget {
  final Key key;
  final int duration;
  final Color backgroundColor;
  final Color foregroundColor;
  final Function() onFinished;

  const ProgressRing({this.key, this.duration, this.backgroundColor, this.foregroundColor, this.onFinished});

  @override
  ProgressRingState createState() => ProgressRingState();
}

class ProgressRingState extends State<ProgressRing> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );
    this._animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void pauseAnimation(BuildContext context) {
    _animationController.stop();
    context.read(ekgServiceProvider.notifier).pauseListenToEkg(); // TODO: Send off signal or just pause?
  }

  void resumeAnimation(BuildContext context) {
    _animationController.forward();
    context.read(ekgServiceProvider.notifier).resumeListenToEkg(); // TODO: Send off signal or just pause?
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 7,
      height: MediaQuery.of(context).size.width / 7,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget child) {
                return CustomPaint(
                  child: child,
                  foregroundPainter:
                      ProgressBarPainter(backgroundColor: widget.backgroundColor, foregroundColor: widget.foregroundColor, percentage: _animationController.value, onFinished: widget.onFinished),
                );
              },
            ),
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  return Colors.black;
                }),
                overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  return Colors.transparent;
                }),
              ),
              onPressed: () {
                _isPaused ? resumeAnimation(context) : pauseAnimation(context);
                setState(() {
                  _isPaused = !_isPaused;
                });
              },
              child: _isPaused ? Center(child: Icon(Icons.play_arrow)) : Center(child: Icon(Icons.pause)))
        ],
      ),
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  final double percentage;
  final Color backgroundColor;
  final Color foregroundColor;
  double strokeWidth;
  final Function() onFinished;

  ProgressBarPainter({this.backgroundColor, @required this.foregroundColor, @required this.percentage, this.onFinished, double strokeWidth}) {
    this.strokeWidth = strokeWidth ?? 6;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (percentage == 1.0) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        onFinished();
      });
    }

    final Offset center = size.center(Offset.zero);
    final Size constrainedSize = size - Offset(this.strokeWidth, this.strokeWidth);
    final shortestSide = Math.min(constrainedSize.width, constrainedSize.height);
    final foregroundPaint = Paint()
      ..color = this.foregroundColor
      ..strokeWidth = this.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final radius = (shortestSide / 2);

    final double startAngle = -(2 * Math.pi * 0.25);
    final double sweepAngle = (2 * Math.pi * (this.percentage ?? 0));

    if (this.backgroundColor != null) {
      final backgroundPaint = Paint()
        ..color = this.backgroundColor
        ..strokeWidth = this.strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, backgroundPaint);
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final oldPainter = (oldDelegate as ProgressBarPainter);
    return oldPainter.percentage != this.percentage ||
        oldPainter.backgroundColor != this.backgroundColor ||
        oldPainter.foregroundColor != this.foregroundColor ||
        oldPainter.strokeWidth != this.strokeWidth;
  }
}
