/*
*  klein_dark.dart
*  KleinKlein Wireframes
*
*  Created by marc.
*  Copyright © 2018 Uni-Marburg. All rights reserved.
    */

import 'package:flutter/material.dart';


// Style Foreground Color
const Color _foregroundColor = Color.fromARGB(255, 50, 67, 118);

// Style Font
const double _fontSize = 93;
const FontWeight _fontWeight = FontWeight.w400;
const String _fontFamily = "Acumin Pro";
const FontStyle _fontStyle = null;


class KleinDarkDecoration extends BoxDecoration {
  const KleinDarkDecoration({
    Color color,
    Gradient gradient,
    Border border,
    BorderRadiusGeometry borderRadius,
    List<BoxShadow> boxShadow,
  }) : super(
         color: color,
         border: border,
         borderRadius: borderRadius,
         boxShadow: boxShadow,
         gradient: gradient,
       );
  
  KleinDarkDecoration.withOverrides({
    Color color,
    Gradient gradient,
    double borderWidth,
    Color borderColor,
    BorderRadiusGeometry borderRadius,
    Color shadowColor,
    Offset shadowOffset,
    double shadowRadius,
  }) : super(
         color: color,
         borderRadius: borderRadius,
         gradient: gradient,
         border: Border.all(width: borderWidth ?? 0.0, color: borderColor ?? const Color(0xFF000000)),
         boxShadow: [ BoxShadow(color: shadowColor ?? const Color(0x00000000), offset: shadowOffset ?? Offset.zero, blurRadius: shadowRadius ?? 0.0) ]
       );
}


class KleinDarkTextStyle extends TextStyle {
  const KleinDarkTextStyle({
    Color color = _foregroundColor,
    double fontSize = _fontSize,
    FontWeight fontWeight = _fontWeight,
    String fontFamily = _fontFamily,
    FontStyle fontStyle = _fontStyle,
    double height,
    double letterSpacing,
  }) : super(
         color: color,
         fontSize: fontSize,
         fontWeight: fontWeight,
         fontFamily: fontFamily,
       );
}


class KleinDark extends StatelessWidget {
  const KleinDark({
    Key key,
    this.decoration = const KleinDarkDecoration(),
    this.child,
  }) : super(key: key);
  final KleinDarkDecoration decoration;
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
  
    return DefaultTextStyle(
      style: const KleinDarkTextStyle(),
      child: DecoratedBox(
        decoration: this.decoration,
        child: this.child,
      ),
    );
  }
}


class KleinDarkButton extends StatelessWidget {
  
  const KleinDarkButton({
    Key key,
    this.color,
    this.border = const BorderSide(),
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.padding,
    @required this.onPressed,
    @required this.child,
  }): super(key: key);
  
  final Color color;
  final BorderSide border;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsets padding;
  final VoidCallback onPressed;
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
  
    return FlatButton(
      color: this.color,
      shape: RoundedRectangleBorder(
        side: this.border,
        borderRadius: this.borderRadius,
      ),
      onPressed: this.onPressed,
      child: DefaultTextStyle(
        style: const KleinDarkTextStyle(),
        child: this.child,
      ),
    );
  }
}


class KleinDarkSwitch extends StatelessWidget {
  const KleinDarkSwitch({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.activeColor = _foregroundColor,
  }): super(key: key);
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  
  @override
  Widget build(BuildContext context) {
  
    return Switch.adaptive(
      value: this.value,
      onChanged: this.onChanged,
      activeColor: this.activeColor,
    );
  }
}


class KleinDarkSlider extends StatelessWidget {
  const KleinDarkSlider({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.inactiveColor,
    this.activeColor = _foregroundColor,
    this.min,
    this.max,
  }): super(key: key);
  final double value;
  final ValueChanged<double> onChanged;
  final Color inactiveColor;
  final Color activeColor;
  final double min;
  final double max;
  
  @override
  Widget build(BuildContext context) {
  
    return Slider(
      value: this.value,
      onChanged: this.onChanged,
      activeColor: this.activeColor,
    );
  }
}


class KleinDarkCircularProgressIndicator extends StatelessWidget {
  const KleinDarkCircularProgressIndicator({
    Key key,
    this.color = _foregroundColor,
  }): super(key: key);
  final Color color;
  
  @override
  Widget build(BuildContext context) {
  
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(this.color),
    );
  }
}


class KleinDarkLinearProgressIndicator extends StatelessWidget {
  const KleinDarkLinearProgressIndicator({
    Key key,
    this.color = _foregroundColor,
  }): super(key: key);
  final Color color;
  
  @override
  Widget build(BuildContext context) {
  
    return LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(this.color),
    );
  }
}