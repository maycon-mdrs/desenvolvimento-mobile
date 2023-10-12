import 'package:f03_lugares/components/place_item.dart';
import 'package:f03_lugares/models/favorite_places_provider.dart';
import 'package:f03_lugares/models/place.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var favoritePlaces = Provider.of<FavoritePlacesProvider>(context).favoritePlaces;
    
    if (favoritePlaces.isEmpty) {
      return const Center(
        child: Text('Nenhum Lugar Marcado como Favorito!'),
      );
    } else {
      return ListView.builder(
          itemCount: favoritePlaces.length,
          itemBuilder: (ctx, index) {
            return PlaceItem(favoritePlaces[index]);
          });
    }
  }
}
