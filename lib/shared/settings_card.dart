import 'package:flutter/material.dart';
import 'package:flutter_ar/shared/theme.dart';

class SettingsCard extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onPressed;

  const SettingsCard({
    super.key,
    required this.imagePath,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 50,
            height: 50,
          ),
          const SizedBox(width: 15),
          Text(
            text,
            style: mediumTextStyle.copyWith(fontSize: 16),
          ),
          const Spacer(),
          const Icon(
            Icons.chevron_right_rounded,
            size: 25,
          ),
        ],
      ),
    );
  }
}
