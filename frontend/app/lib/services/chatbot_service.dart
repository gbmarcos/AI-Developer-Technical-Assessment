import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<String> askBot([String? query, Uint8List? fileBytes]) async {
  const url = String.fromEnvironment(
    'WEBHOOK_URL',
    defaultValue: 'http://localhost:5678/webhook/ask',
  );

  late final http.Response response;

  if (fileBytes != null) {
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..files.add(
        http.MultipartFile.fromBytes(
          'audio',
          fileBytes,
          contentType: MediaType.parse('audio/webm'),
        ),
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
