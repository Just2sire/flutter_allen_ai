import 'dart:convert';

import 'package:allen_ai/repositories/api_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService implements ApiRepository {
  String apiKey = dotenv.env['OPENAPIKEY'] ?? "";
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse(
          "https://api.openai.com/v1/chat/completions",
        ),
        headers: {
          'Content-Type': "application/json",
          'Authorization': "Bearer $apiKey",
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "user",
                "content":
                    "Does this message want to generate an AI picture, image, art or anything similar ? $prompt . Simply answer with a yes or no",
              },
            ]
          },
        ),
      );
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)["choices"][0]["message"]["content"];
        content = content.trim();
        if (content.toLowerCase().contains("yes")) {
          final res = await imageWork(prompt);
          return res;
        } else {
          final res = await generateText(prompt);
          return res;
        }
      }
      return "Une erreure s'est produite...";
    } catch (e) {
      return e.toString();
    }
    // return "AI";
  }

  @override
  Future<String> generateText(String prompt) async {
    messages.add({
      'role': "user",
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse(
          "https://api.openai.com/v1/chat/completions",
        ),
        headers: {
          'Content-Type': "application/json",
          'Authorization': "Bearer $apiKey",
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": messages,
          },
        ),
      );
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)["choices"][0]["message"]["content"];
        content = content.trim();
        messages.add({
          'role': "assistant",
          'content': content,
        });
        return content;
      }
      return "An internal error occured";
    } catch (e) {
      return e.toString();
    }
    // return "Chat GPT";
  }

  Future<String> imageWork(String prompt) async {
    messages.add({
      'role': "user",
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse(
          "https://api.openai.com/v1/images/generations",
        ),
        headers: {
          'Content-Type': "application/json",
          'Authorization': "Bearer $apiKey",
        },
        body: jsonEncode(
          {
            "prompt": prompt,
            "n": 1,
            // "model": "gpt-3.5-turbo",
            // "messages": messages,
          },
        ),
      );
      if (res.statusCode == 200) {
        String imagrUrl = jsonDecode(res.body)["data"][0]["uri"];
        // imagrUrl = content.trim();
        messages.add({
          'role': "assistant",
          'content': imagrUrl,
        });
        return imagrUrl;
      }
      return "Une erreure s'est produite; Une erreur de l'intelligence artificielle de OpenAI";
    } catch (e) {
      return e.toString();
    }
  }
}
