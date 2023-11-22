import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/great_places.dart';
import '../utils/app_routes.dart';

class PlacesListScreen extends StatelessWidget {
  void _showDeleteDialog(BuildContext context, String placeId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Tem certeza?'),
        content: Text('Quer mesmo excluir este lugar?'),
        actions: <Widget>[
          TextButton(
            child: Text('Não'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Sim'),
            onPressed: () {
              Provider.of<GreatPlaces>(context, listen: false).deletePlace(placeId);
              Navigator.of(ctx).pop();

              ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lugar excluído com sucesso!',
              textAlign: TextAlign.center,  
            ),
            backgroundColor: Colors.red,  
            behavior: SnackBarBehavior.floating,  
          ),
        );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Lugares'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PLACE_FORM);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<GreatPlaces>(
                child: Center(
                  child: Text('Nenhum local'),
                ),
                builder: (context, greatPlaces, child) =>
                    greatPlaces.itemsCount == 0
                        ? child!
                        : ListView.builder(
                            itemCount: greatPlaces.itemsCount,
                            itemBuilder: (context, index) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                    greatPlaces.itemByIndex(index).image),
                              ),
                              title: Text(greatPlaces.itemByIndex(index).title),
                              trailing: PopupMenuButton(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.PLACE_EDIT,
                                    arguments: greatPlaces.itemByIndex(index),
                                  );
                                } else if (value == 'delete') {
                                  _showDeleteDialog(context, greatPlaces.items[index].id);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Text('Editar'),
                                  value: 'edit',
                                ),
                                PopupMenuItem(
                                  child: Text('Excluir'),
                                  value: 'delete',
                                ),
                              ],
                            ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.PLACE_DETAIL,
                                  arguments: greatPlaces.itemByIndex(index).id,
                                );
                              },
                            ),
                          ),
              ),
      ),
    );
  }
}
