import 'package:f03_lugares/components/forms.dart';
import 'package:f03_lugares/components/main_drawer.dart';
import 'package:f03_lugares/data/my_data.dart';
import 'package:f03_lugares/models/places_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/place.dart';
import '../models/favorite_places_provider.dart';

class PlaceForms extends StatefulWidget {
  @override
  _PlaceFormsState createState() => _PlaceFormsState();
}

class _PlaceFormsState extends State<PlaceForms> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Novo Lugar'),
      ),
      body: Forms(),
      drawer: MainDrawer(),
    );
  }
}
