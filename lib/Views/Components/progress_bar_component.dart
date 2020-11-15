import 'package:flutter/material.dart';
import 'dart:math' as Math;

class ProgressBar extends StatefulWidget {
  final Key key;
  final int duration;
  final Color backgroundColor;
  final Color foregroundColor;

  const ProgressBar({this.key, this.duration, this.backgroundColor, this.foregroundColor});

  @override
  ProgressBarState createState() => ProgressBarState();
}

class ProgressBarState extends State<ProgressBar> with SingleTickerProviderStateMixin {
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

  void pauseAnimation() {
    _animationController.stop();
    print('Paused!'); //TODO: Send pause signal to ESP!
  }

  void resumeAnimation() {
    _animationController.forward();
    print('Resumed!'); //TODO: Send resume signal to ESP!
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
                  foregroundPainter: ProgressBarPainter(
                    backgroundColor: widget.backgroundColor,
                    foregroundColor: widget.foregroundColor,
                    percentage: _animationController.value,
                  ),
                );
              },
            ),
          ),
          FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                _isPaused ? resumeAnimation() : pauseAnimation();
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

  ProgressBarPainter({this.backgroundColor, @required this.foregroundColor, @required this.percentage, double strokeWidth}) {
    this.strokeWidth = strokeWidth ?? 6;
  }

  @override
  void paint(Canvas canvas, Size size) {
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
