extension ArabicNumbers on String {
  String toArabicNumbers() {
    const englishNumbers = '0123456789';
    const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';

    return replaceAllMapped(
      RegExp(r'[0-9]'),
      (match) => arabicNumbers[
        englishNumbers.indexOf(match.group(0)!)
      ],
    );
  }
}