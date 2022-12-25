import 'dart:convert';

import 'package:flutter/material.dart';
import './openai_key.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OpenAi(),
    );
  }
}

class OpenAi extends StatefulWidget {
  const OpenAi({super.key});

  @override
  State<OpenAi> createState() => _OpenAiState();
}

class _OpenAiState extends State<OpenAi> {
  String result = "";
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Openai test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "put description here",
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  getData(textController.value.toString()).then((value) {
                    result = json.decode(value.body)['data'][0]['url'];
                    print(result);
                    setState(() {});
                  });
                },
                child: const Text("Genera")),
            const Spacer(),
            SafeArea(child: Text(result))
          ],
        ),
      ),
    );
  }

  Future<Response> getData(String description) async {
    var endPoint = Uri.https('api.openai.com', '/v1/images/generations');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $OPENAI_KEY'
    };

    final body = json.encode({
      'prompt': description,
      'n': 1,
      'size': '512x512',
    });

    return http.post(endPoint, headers: headers, body: body);
  }
}
