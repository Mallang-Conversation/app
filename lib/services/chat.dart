import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

final sttUrl = 'http://10.0.2.2:8081/api/v1/audio';

Future<void> fetchSpeechToText(File audioFile) async {
  var request = http.MultipartRequest('POST', Uri.parse(sttUrl));
  request.files.add(await http.MultipartFile.fromPath(
    'file',
    filename: 'audio.wav',
    audioFile.path,
  ));

  var response = await request.send();

  if (response.statusCode == 200) {
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    final decodedString = jsonDecode(responseString);

    debugPrint('Success to upload audio: $decodedString');
  } else {
    debugPrint('Failed to upload audio: ${response.statusCode}');

    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    final decodedString = jsonDecode(responseString);

    debugPrint('Failed to upload audio: $decodedString');
  }
}
