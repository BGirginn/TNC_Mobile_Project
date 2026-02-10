// Uygulama genelinde kullanilan yardimci fonksiyonlar.
// Tekrarlanan islemleri merkezilestirerek DRY prensibine uyum saglar.
import 'package:flutter/material.dart';

/// Kategori adina gore uygun Material ikonu dondurur.
/// Tum ekranlarda tutarli ikon kullanimi icin tek kaynak.
IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Elektronik':
      return Icons.devices;
    case 'Giyim':
      return Icons.checkroom;
    case 'Aksesuar':
    case 'Aksesuarlar':
      return Icons.watch;
    case 'Ev & Yaşam':
      return Icons.home_outlined;
    case 'iPhone & iPad':
      return Icons.phone_iphone;
    case 'Mac':
      return Icons.laptop_mac;
    case 'Apple Watch':
      return Icons.watch;
    case 'Ses & Aksesuarlar':
      return Icons.headphones;
    default:
      return Icons.shopping_bag;
  }
}

bool isNetworkImagePath(String imagePath) {
  return imagePath.startsWith('http://') || imagePath.startsWith('https://');
}

Widget buildProductImage({required String imagePath, required String category, BoxFit fit = BoxFit.cover, double fallbackIconSize = 40, Color fallbackIconColor = const Color(0xFF8AA4E8)}) {
  if (isNetworkImagePath(imagePath)) {
    return Image.network(
      imagePath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(getCategoryIcon(category), size: fallbackIconSize, color: fallbackIconColor),
        );
      },
    );
  }

  return Image.asset(
    imagePath,
    fit: fit,
    errorBuilder: (context, error, stackTrace) {
      return Center(
        child: Icon(getCategoryIcon(category), size: fallbackIconSize, color: fallbackIconColor),
      );
    },
  );
}
