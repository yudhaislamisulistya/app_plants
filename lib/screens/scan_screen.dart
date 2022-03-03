import 'dart:async';
import 'dart:io';

import 'package:app_plants/components/button.dart';
import 'package:app_plants/database_manager.dart';
import 'package:app_plants/screens/login_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ScanScreen extends StatefulWidget {
  static const String id = 'catDogClassifier';

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('riwayat');

  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();
  late Timer _timer;
  UploadTask? task;

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }



  classifyImage(File image) async {
    dynamic output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _loading = false;
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model/model_ujian.tflite',
      labels: 'assets/model/label_ujian.txt',
    );
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {});
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Scan',
                style: TextStyle(color: Color(0xff297F87), fontSize: 25),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Deteksi Gambar',
                style: TextStyle(
                    color: Color(0xff297F87),
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: _loading
                    ? Container(
                      )
                    : Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 250,
                              child: new ClipRRect(
                                borderRadius: new BorderRadius.circular(20.0),
                                child: Image.file(_image),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            new ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff297F87), // background
                              ),
                              onPressed: () async{
                                showDialog(
                                    context: context,
                                    builder: (BuildContext builderContext) {
                                      _timer = Timer(Duration(seconds: 1), () {
                                        Navigator.of(builderContext).pop();
                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.LEFTSLIDE,
                                          headerAnimationLoop: false,
                                          dialogType: DialogType.SUCCES,
                                          title: 'Success',
                                          desc:
                                          'Data Berhasil Tersimpan',
                                          btnOkIcon: Icons.check_circle,)
                                          ..show();
                                      });

                                      return new Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: new Row(
                                            children: [
                                              new CircularProgressIndicator(),
                                              new SizedBox(
                                                width: 8.0,
                                              ),
                                              new Text("Loading...")
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                ).then((val){
                                  if (_timer.isActive) {
                                    _timer.cancel();
                                  }
                                });

                                if (_image == null) return;

                                final destination = 'files/${_image.path}';

                                task = DatabaseManager.uploadFile(destination, _image);
                                setState(() {});

                                if (task == null) return;

                                final snapshot = await task!.whenComplete(() {});
                                final urlDownload = await snapshot.ref.getDownloadURL();

                                print('Download-Link: $urlDownload');



                                await collectionReference.add({
                                  'label': _output[0]['label'],
                                  'confidence': _output[0]['confidence'],
                                  'urlDownloadImage': urlDownload
                                });
                              },
                              child: new Text("Simpan Hasil"),
                            ),
                            _output != null
                                ? Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                        '${_output[0]['label']} - ${_output[0]['confidence']}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0)),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    AppButton(
                      icon: Icons.camera_alt,
                      onClick: pickImage,
                      btnText: 'Camera',
                    ),
                    SizedBox(height: 15),
                    AppButton(
                      icon: Icons.image,
                      onClick: pickGalleryImage,
                      btnText: 'Gallery',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
