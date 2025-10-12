import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'photo.dart';

class DatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> addPhoto(Map<String, dynamic> photoData) async{
    await _db.child('photo').push().set(photoData);
  }

  Stream<List<Map<String, dynamic>>> getPhotos(){
    return _db.child('photos').onValue.map((event) {
      Map<dynamic, dynamic> photoData = event.snapshot.value as Map<dynamic, dynamic> ?? {};
      List<Map<String, dynamic>> photoList = [];
      photoData.forEach((key, value){
        Map<String, dynamic> photo = Map<String, dynamic>.from(value as Map);
        photo['id'] = key;
        photoList.add(photo);
      });
      return photoList;
    });
  }

  Future<void> updatePhoto(String id, Map<String, dynamic> photoData) async{
    await _db.child('photos').child(id).update(photoData);
  }

  Future<void> deletePhoto(String id) async {
    await _db.child('photos').child(id).remove();
  }

}
