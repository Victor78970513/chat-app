import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const BlueButton({super.key, required this.onPressed, required this.text});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        backgroundColor: Colors.blue,
        shape: const StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Container(
        height: 55,
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
