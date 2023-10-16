import 'package:f03_lugares/components/forms.dart';
import 'package:f03_lugares/components/main_drawer.dart';
import 'package:f03_lugares/data/my_data.dart';
import 'package:f03_lugares/models/place.dart';
import 'package:f03_lugares/models/places_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class PlacesManage extends StatefulWidget {
  const PlacesManage({super.key});

  @override
  State<PlacesManage> createState() => _PlacesManageState();
}

class _PlacesManageState extends State<PlacesManage> {
  @override
  Widget build(BuildContext context) {
    final placesProvider = Provider.of<PlacesProvider>(context);
    final places = placesProvider.places;

    return Scaffold(
        appBar: AppBar(title: Text('Lista de Lugares')),
        body: ListView.builder(
          itemCount: places.length,
          itemBuilder: (ctx, index) {
            Place place = places[index];
            return ListTile(
              leading: Image.network(
                place.imagemUrl,
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Text(place.titulo),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) => (Forms(place: place)),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Código para excluir o lugar
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Excluir Lugar'),
                          content: Text('Você quer excluir este lugar?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                              child: Text('Não'),
                            ),
                            TextButton(
                              onPressed: () {
                                placesProvider.removePlace(place.id);
                                Navigator.of(ctx).pop(true);
                              },
                              child: Text('Sim'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        drawer: MainDrawer());
  }
}
