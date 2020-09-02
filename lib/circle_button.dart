import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final double diameter;
  final List<Color> color;
  final VoidCallback onTap;

  const CircleButton(
      {Key key, this.diameter = 20, this.color, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: color,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
