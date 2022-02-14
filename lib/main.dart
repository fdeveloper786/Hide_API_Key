// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(FlutterConfig.get('FLUTTER_APP_SECRET_KEY'));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HideApiKey(),
    );
  }
}

class HideApiKey extends StatefulWidget {
  const HideApiKey({Key? key}) : super(key: key);

  @override
  _HideApiKeyState createState() => _HideApiKeyState();
}

class _HideApiKeyState extends State<HideApiKey> {
  String api_key = "";
  var data;
  bool load = false;

  getData() async {
    api_key = FlutterConfig.get('FLUTTER_APP_SECRET_KEY');
    http.Response response = await http.get(Uri.parse(api_key.toString()));
    data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        load = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hide API Key Test App"),
          centerTitle: true,
        ),
        body: load == true
            ? Container(
                child: Center(
                    child: Column(children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Text('Hide API key on server'),
                  SizedBox(
                    height: 50.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print(FlutterConfig.get('FLUTTER_APP_SECRET_KEY'));
                        getData();
                      },
                      child: Text('Get Data')),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text('Data from Http ${data}')
                ])),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
