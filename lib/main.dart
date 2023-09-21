import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jokes_app/jokes_model.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(const JokesApp());
}

class JokesApp extends StatelessWidget {
  const JokesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String joke = '';
  List<String> likedJokes = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Генератор шуток Чак норриса'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Column(
            children: [
              Text(
                joke,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              ElevatedButton(
                onPressed: () {
                  getJokes();
                },
                child: Text('Получить шутку'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      translateToEn(joke);
                    },
                    child: const Text('Перевести на\nАнглийский'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      translateToRU(joke);
                      setState(() {});
                    },
                    child: const Text('Перевести на\nрусский'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void translateToEn(String value) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(value, from: 'ru', to: 'en');
    joke = translation.toString();
    setState(() {});
  }

  Future<void>   translateToRU(String value) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(value, from: 'en', to: 'ru');
    joke = translation.toString();
    setState(() {});
  }

  Future<void> getJokes() async {
    final Dio dio = Dio();
    try {
      final response = await dio.get('https://api.chucknorris.io/jokes/random');
      final model = JokesModel.fromJson(response.data);
      joke = model.value ?? '';
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
}
