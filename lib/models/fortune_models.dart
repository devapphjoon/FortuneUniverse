import 'package:get/get.dart';

String getLocalized(dynamic field) {
  if (field is Map) {
    String lang = Get.locale?.languageCode ?? 'en';
    return field[lang] ?? field['en'] ?? field['ko'] ?? '';
  }
  return field?.toString() ?? '';
}

class TarotCard {
  final int id;
  final String name;
  final String basicMeaning;
  final String premiumLove;
  final String premiumWealth;
  final String imageUrl;

  TarotCard({
    required this.id,
    required this.name,
    required this.basicMeaning,
    required this.premiumLove,
    required this.premiumWealth,
    required this.imageUrl,
  });

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    return TarotCard(
      id: json['id'],
      name: getLocalized(json['name']),
      basicMeaning: getLocalized(json['basicMeaning']),
      premiumLove: getLocalized(json['premiumLove']),
      premiumWealth: getLocalized(json['premiumWealth']),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class FortuneCookie {
  final int id;
  final String quote;
  final String premiumDetail;

  FortuneCookie({
    required this.id,
    required this.quote,
    required this.premiumDetail,
  });

  factory FortuneCookie.fromJson(Map<String, dynamic> json) {
    return FortuneCookie(
      id: json['id'],
      quote: getLocalized(json['quote']),
      premiumDetail: getLocalized(json['premiumDetail']),
    );
  }
}

class TestQuestion {
  final int id;
  final String question;
  final List<TestOption> options;

  TestQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  factory TestQuestion.fromJson(Map<String, dynamic> json) {
    return TestQuestion(
      id: json['id'],
      question: getLocalized(json['question']),
      options: (json['options'] as List).map((e) => TestOption.fromJson(e)).toList(),
    );
  }
}

class TestOption {
  final String text;
  final String scoreType; // e.g., 'E', 'I', 'F', 'T'

  TestOption({
    required this.text,
    required this.scoreType,
  });

  factory TestOption.fromJson(Map<String, dynamic> json) {
    return TestOption(
      text: getLocalized(json['text']),
      scoreType: json['scoreType'],
    );
  }
}

class TestResult {
  final String id; // e.g., 'INTJ'
  final String title;
  final String basicDescription;
  final String premiumMatch; // 최고/최악의 궁합

  TestResult({
    required this.id,
    required this.title,
    required this.basicDescription,
    required this.premiumMatch,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json['id'],
      title: getLocalized(json['title']),
      basicDescription: getLocalized(json['basicDescription']),
      premiumMatch: getLocalized(json['premiumMatch']),
    );
  }
}
