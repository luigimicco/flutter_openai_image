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
      debugShowCheckedModeBanner: false,
      home: const OpenAiImage(),
    );
  }
}

class OpenAiImage extends StatefulWidget {
  const OpenAiImage({super.key});

  @override
  State<OpenAiImage> createState() => _OpenAiImageState();
}

class _OpenAiImageState extends State<OpenAiImage> {
  String result = "";
  bool isLoading = false;
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
        title: const Text("Flutter OpenAi test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'put description here',
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    isLoading = true;
                    result = "";
                    setState(() {});
                    getImage(textController.value.toString()).then((value) {
                      result = json.decode(value.body)['data'][0]['url'];
                    }).whenComplete(() {
                      isLoading = false;
                      setState(() {});
                    });
                  },
                  child: const Text("Genera")),
              (isLoading)
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : ((result.isNotEmpty) ? imageCard(result) : Container()),
            ],
          ),
        ),
      ),
    );
  }

  // use OpenAi API to get image
  Future<Response> getImage(String description) async {
    var endPoint = Uri.https('api.openai.com', '/v1/images/generations');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $OPENAI_KEY'
    };

    final body = json.encode({
      'prompt': description,
      'n': 1,
      'size': '1024x1024',
    });

    return http.post(endPoint, headers: headers, body: body);
  }

  // ImageCard
  Widget imageCard(imageUrl) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              constraints: const BoxConstraints.expand(height: 300),
              alignment: Alignment.center,
              child: (Image.network(
                imageUrl,
                fit: BoxFit.cover,
              )),
            ),
          ),
        ));
  }
}
