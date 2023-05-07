import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

// Constants
enum MediaTypes { camera, gallery }

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _uploadToStorage(MediaTypes.gallery),
        tooltip: 'Gallery',
        child: const Icon(Icons.picture_in_picture_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _uploadToStorage(MediaTypes medie) async {
    final imagePicker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await imagePicker.pickImage(
          source: medie == MediaTypes.gallery
              ? ImageSource.gallery
              : ImageSource.camera,
          maxWidth: 1920);

      String fileName = path.basename(pickedImage!.path);
      File imgFile = File(fileName);

      try {
        await storage.ref(fileName).putFile(
            imgFile,
            SettableMetadata(customMetadata: {
              'uploaded_by': 'Ada',
              'description': 'For SSRU Development'
            }));

        setState(() {});
      } catch (err) {
        print(err);
      }
    } catch (err) {
      print('Error at Picker Image: $err');
    }
  }
}
