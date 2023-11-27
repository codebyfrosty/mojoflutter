import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        shape: const StadiumBorder(),
      ),
      child: Text(text),
    );
  }
}
