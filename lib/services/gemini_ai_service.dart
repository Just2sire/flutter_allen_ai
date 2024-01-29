import 'dart:convert';

import 'package:allen_ai/repositories/api_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;

class GeminiAIService implements ApiRepository {
  String apiKey = dotenv.env['GEMINIAPIKEY'] ?? "";
  final gemini = Gemini.instance;
  @override
  Future<String> generateText(String prompt) async {
    try {
      final resp = await gemini.text(prompt);
      var candidates = resp?.output;
      print(candidates);
      final res = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "contents": [
              {
                "parts": [
                  {
                    "text": prompt,
                  }
                ]
              }
            ]
          },
        ),
      );
      print(res);
      return candidates ?? "";
      // return "";
    } catch (e) {
      return e.toString();
    }
  }
}
