import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/place.dart';
import '../utils/db_util.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  /* Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: PlaceLocation(
              latitude: item['latitude'],
              longitude: item['longitude'],
              address: item['address'],
            ),
            phoneNumber: item['phoneNumber'],
          ),
        )
        .toList();
    notifyListeners();
  } */
  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');
    _items = dataList.map((item) {
      final latitude = double.tryParse(item['latitude'].toString()) ?? 0.0;
      final longitude = double.tryParse(item['longitude'].toString()) ?? 0.0;

      return Place(
        id: item['id'],
        title: item['title'],
        image: File(item['image']),
        location: PlaceLocation(
          latitude: latitude,
          longitude: longitude,
          address: item['address'],
        ),
        phoneNumber: item['phoneNumber'],
      );
    }).toList();
    notifyListeners();
  }

  List<Place> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int index) {
    return _items[index];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  void addPlace(
    String title,
    File image,
    PlaceLocation location,
    String phoneNumber,
  ) {
    final newPlace = Place(
        id: Random().nextDouble().toString(),
        title: title,
        location: location,
        image: image,
        phoneNumber: phoneNumber);

    _items.add(newPlace);
    DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'latitude': newPlace.location!.latitude.toString(),
      'longitude': newPlace.location!.longitude.toString(),
      'address': newPlace.location!.address,
      'phoneNumber': newPlace.phoneNumber.toString(),
    });
    notifyListeners();
  }

  Future<void> deletePlace(String id) async {
    await DbUtil.delete('places', id);
    _items.removeWhere((place) => place.id == id);
    notifyListeners();
  }

  Future<void> updatePlace(String id, Place updatedPlace) async {
    final placeIndex = _items.indexWhere((place) => place.id == id);
    if (placeIndex >= 0) {
      _items[placeIndex] = updatedPlace;
      await DbUtil.update('places', {
        'id': updatedPlace.id,
        'title': updatedPlace.title,
        'image': updatedPlace.image.path,
        'latitude': updatedPlace.location!.latitude.toString(),
        'longitude': updatedPlace.location!.longitude.toString(),
        'address': updatedPlace.location!.address,
        'phoneNumber': updatedPlace.phoneNumber.toString(),
      });
      notifyListeners();
    }
  }
}
