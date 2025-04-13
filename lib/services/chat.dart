import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const String sttUrl = 'https://158.180.73.169:8081/api/v1/audio';

Future<String> fetchSpeechToText(File audioFile) async {
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
    debugPrint('Success to upload audio: $responseString');

    return responseString.trim();
  } else {
    debugPrint('Failed to upload audio: ${response.statusCode}');
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    debugPrint('Failed to upload audio: $responseString');

    return '';
  }
}
