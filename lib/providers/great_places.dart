import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:udemy_native_device_feature/helpers/db_helper.dart';

import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace( String pickedTitle, File pickedImage) {
    final newPlace = Place (
      id: DateTime.now().toString(),
      image: pickedImage,
      title: pickedTitle,
      location: null,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
  }

  //강의와는 다르게, Map -> Place 변환을 db_helper에서 했음.
  Future<void> fetchAndSetPlaces() async {
    _items = await DBHelper.getData('user_places');
    notifyListeners();
  }
}