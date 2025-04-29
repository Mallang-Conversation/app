import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '/constants/common.dart';

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
