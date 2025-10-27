import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class DeliveryNavigationWidget extends StatelessWidget {
  const DeliveryNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFF6B35), // Saffron
            Color(0xFFFF8C42), // Lighter saffron
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: _buildDeliveryOption(
        context,
        '30 min delivery',
        Icons.local_shipping,
      ),
    );
  }

  Widget _buildDeliveryOption(BuildContext context, String title, IconData icon) {
    return InkWell(
      onTap: () {
        // Handle delivery option selection
        _handleDeliveryOptionSelection(title);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: robotoMedium.copyWith(
                color: Colors.white,
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _handleDeliveryOptionSelection(String option) {
    // Handle the delivery option selection logic
    switch (option) {
      case '30 min delivery':
      // Navigate to quick delivery stores
        break;
      case '1 day delivery':
      // Navigate to regular delivery stores
        break;
      case 'Services':
      // Navigate to services
        break;
    }
  }
}
