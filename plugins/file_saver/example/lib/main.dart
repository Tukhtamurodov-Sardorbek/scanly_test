import 'dart:convert';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await FileSaver.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('tenge24_file_saver Plugin'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Platform version: $_platformVersion'),
              const Text(
                'Please check file in Download folder (or Files App in iOS)',
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveFiles,
          tooltip: 'Save Multiple File',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _saveFiles() {
    List<int> htmlBytes =
        utf8.encode("<h1>Header 1</h1><p>This is sample text</p>");
    List<int> textBytes = utf8.encode("Some data");
    Uint8List htmlBytes1 = Uint8List.fromList(htmlBytes);
    Uint8List textBytes1 = Uint8List.fromList(textBytes);

    FileSaver.saveFilesToDownloadFolder(
      dataList: [htmlBytes1, textBytes1],
      fileNameList: ["htmlfile.html", "textfile.txt"],
      mimeTypeList: ["text/html", "text/plain"],
    );
  }
}
