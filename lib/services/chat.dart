import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<void> fetchAlbum() async {
  final result =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/pikachu'));
  final pikachu = jsonDecode(result.body);
  final id = pikachu['id'];
  debugPrint(id.toString());
}
