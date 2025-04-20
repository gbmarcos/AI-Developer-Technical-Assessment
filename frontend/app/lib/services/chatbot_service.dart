import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> askBot([String? query, String? filePath]) async {
  
  const url = String.fromEnvironment(
    'WEBHOOK_URL',
    defaultValue: 'http://localhost:5678/webhook/ask',
  );

  late final http.Response response;

  if (filePath != null) {
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..files.add(
        await http.MultipartFile.fromPath('audio', filePath),
      );

    response = await http.Response.fromStream(
      await request.send(),
    );
    
  } else {
    response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'text': query,
      }),
    );
  }

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Error: ${response.statusCode}');
  }
}
