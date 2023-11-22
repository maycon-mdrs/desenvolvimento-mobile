import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;
  
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address = '',
  });
}

class Place {
  final String id;
  final String title;
  final PlaceLocation? location;
  final File image;
  final String? phoneNumber; // Adicionado campo para número de telefone

  Place({
    required this.id,
    required this.title,
    this.location,
    required this.image,
    this.phoneNumber = '', 
  });
}
