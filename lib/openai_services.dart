import 'dart:convert';

import 'package:ai1/secrets.dart';
import 'package:http/http.dart' as http;

class OpnenAIService {
  final List<Map<String, String>> messages = [];
  Future<String> isArtPromntAPI(String promt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $opneAIAPIKey'
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              'role': 'user ',
              'content':
                  'Does you want to generate an AI Picture , Image , Art or Anythings Similar ? $promt . Simply answer with goes yes Or no  ',
            }
          ],
        }),
      );
      print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final res = await dallEAPI(promt);
            return res;
          default:
            final res = await chatGPTAPI(promt);
            return res;
        }
      }
      return 'An Internal Error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $opneAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    return 'Dall -E';
  }
}
