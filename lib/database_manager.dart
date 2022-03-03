import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseManager {
  final CollectionReference daftarRiwayat =
  FirebaseFirestore.instance.collection('riwayat');

  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await daftarRiwayat.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print(allData);
  }

}