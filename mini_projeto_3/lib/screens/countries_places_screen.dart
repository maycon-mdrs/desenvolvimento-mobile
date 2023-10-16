  import 'package:f03_lugares/components/place_item.dart';
  import 'package:f03_lugares/models/country.dart';
  import 'package:f03_lugares/models/places_provider.dart';
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';

  class CountryPlacesScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      final country = ModalRoute.of(context)!.settings.arguments as Country;

      return Scaffold(
        appBar: AppBar(
          title: Text(country.title),
        ),
        body: Consumer<PlacesProvider>(
          builder: (ctx, placesProvider, child) {
            final countryPlaces = placesProvider.places.where((place) {
              return place.paises.contains(country.id);
            }).toList();

            return ListView.builder(
              itemCount: countryPlaces.length,
              itemBuilder: (ctx, index) {
                return PlaceItem(countryPlaces[index]);
              },
            );
          },
        ),
      );
    }
  }
