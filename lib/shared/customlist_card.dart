import 'package:flutter/material.dart';
import 'package:flutter_ar/shared/theme.dart';

class CustomListCard extends StatelessWidget {
  const CustomListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 170,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/kursi1.png',
                width: 180,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kursi Ukir Jogja',
                  style: boldTextStyle.copyWith(fontSize: 16),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Rp 1.000.000',
                  style: boldTextStyle,
                ),
                const SizedBox(
                  height: 4,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxHeight: 50), // Adjust the maxHeight as needed
                  child: Text(
                    'Nikmati kenyamanan dan gaya tak tertandingi...',
                    style: regularTextStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      fixedSize: const Size(100, 32),
                    ),
                    child: Text(
                      'Custom',
                      style: boldTextStyle.copyWith(
                          color: Colors.white, fontSize: 16),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
