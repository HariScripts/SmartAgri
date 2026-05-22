import 'package:flutter/material.dart';

class CropImageHelper {
  static String getCropEmoji(String cropName) {
    final lower = cropName.toLowerCase();
    if (lower.contains('cotton')) return '☁️';
    if (lower.contains('rice')) return '🌾';
    if (lower.contains('maize') || lower.contains('corn')) return '🌽';
    if (lower.contains('wheat')) return '🌾';
    if (lower.contains('apple')) return '🍎';
    if (lower.contains('banana')) return '🍌';
    if (lower.contains('orange') || lower.contains('citrus')) return '🍊';
    if (lower.contains('grape')) return '🍇';
    if (lower.contains('mango')) return '🥭';
    if (lower.contains('tomato')) return '🍅';
    if (lower.contains('potato')) return '🥔';
    if (lower.contains('onion')) return '🧅';
    if (lower.contains('carrot')) return '🥕';
    if (lower.contains('sugarcane')) return '🎋';
    if (lower.contains('coffee')) return '☕';
    if (lower.contains('tea')) return '🍵';
    if (lower.contains('peanut') || lower.contains('groundnut') || lower.contains('mungbean') || lower.contains('mothbeans')) return '🥜';
    if (lower.contains('coconut')) return '🥥';
    if (lower.contains('watermelon')) return '🍉';
    if (lower.contains('papaya')) return '🍈';
    if (lower.contains('pomegranate')) return '🍎';
    if (lower.contains('lentil') || lower.contains('chickpea') || lower.contains('bean') || lower.contains('gram')) return '🫘';
    return '🌱';
  }

  static Widget getCropIcon(String cropName, {double size = 32}) {
    return Text(
      getCropEmoji(cropName),
      style: TextStyle(fontSize: size),
    );
  }
}
