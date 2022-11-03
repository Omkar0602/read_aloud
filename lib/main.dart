import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:read_aloud/pick_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textController =TextEditingController();
  FlutterTts tts  =FlutterTts();
  void speak({String? text})async{
   await tts.speak(text!);
  }
  void stop()async{
    await tts.stop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Text to Audio"),
        actions: [
          IconButton(onPressed: stop, icon: Icon(Icons.stop,color: Colors.white,)),
          IconButton(onPressed: (){
            if(_textController.text.isNotEmpty){
              speak(text: _textController.text.trim());
            }
          }, icon: Icon(Icons.speaker)),

        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: TextFormField(
          controller: _textController,
          maxLines: MediaQuery.of(context).size.height.toInt(),
          decoration: InputDecoration(
            border: InputBorder.none,
            label: Text("Enter Text"),
            
          ),
        ),

        
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
         pickDocument().then((value) async{
      if(value != ''){
        PDFDoc doc =await PDFDoc.fromPath(value);
        final text =await doc.text;
        _textController.text =text;
      }
         });
      },label: Text("Pick PDF File"),),
    );
  }
}
