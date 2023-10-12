import 'dart:collection';
import 'package:flutter/material.dart';
import 'place.dart';

class FavoritePlacesProvider with ChangeNotifier {
  final List<Place> _favoritePlaces = [];

  List<Place> get favoritePlaces => [..._favoritePlaces];

  void addFavorite(Place place) {
    _favoritePlaces.add(place);
    notifyListeners();
  }

  void removeFavorite(String id) {
    _favoritePlaces.removeWhere((place) => place.id == id);
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favoritePlaces.any((place) => place.id == id);
  }
}
