import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final double diameter;
  final List<Color> color;
  final String nameLetter;
  final VoidCallback onTap;

  const CircleButton({
    Key key,
    this.diameter = 40,
    this.color,
    this.onTap,
    this.nameLetter,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: color ?? [Colors.purple, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            nameLetter ?? '',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
