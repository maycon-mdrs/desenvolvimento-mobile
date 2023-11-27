import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mini_projeto_5/provider/auth.dart';
import 'package:provider/provider.dart';
import '../provider/great_places.dart';
import '../utils/app_routes.dart';

class PlacesListScreen extends StatefulWidget {
  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  bool isLoading = false;

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
              Provider.of<GreatPlaces>(context, listen: false)
                  .deletePlace(placeId);
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

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logout'),
        content: Text('Você tem certeza que deseja sair?'),
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
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.PLACE_LOGIN, (route) => false);
            },
          ),
        ],
      ),
    );
  }

  void _reloadPlaces(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    Provider.of<GreatPlaces>(context, listen: false).loadPlaces();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Lugares'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _showLogoutConfirmation(context),
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: Text('Recarregar'),
            onPressed: () => _reloadPlaces(context),
          ),
          Expanded(
            child: FutureBuilder(
              future:
                  Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
              builder: (ctx, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : Consumer<GreatPlaces>(
                      child: Center(
                        child: Text('Nenhum local'),
                      ),
                      builder: (context, greatPlaces, child) => greatPlaces
                                  .itemsCount ==
                              0
                          ? child!
                          : isLoading
                              ? Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  itemCount: greatPlaces.itemsCount,
                                  itemBuilder: (context, index) => ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: FileImage(
                                          greatPlaces.itemByIndex(index).image),
                                    ),
                                    title: Text(
                                        greatPlaces.itemByIndex(index).title),
                                    trailing: PopupMenuButton(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          Navigator.of(context).pushNamed(
                                            AppRoutes.PLACE_EDIT,
                                            arguments:
                                                greatPlaces.itemByIndex(index),
                                          );
                                        } else if (value == 'delete') {
                                          _showDeleteDialog(context,
                                              greatPlaces.items[index].id);
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
                                        arguments:
                                            greatPlaces.itemByIndex(index).id,
                                      );
                                    },
                                  ),
                                ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.PLACE_FORM);
        },
      ),
    );
  }
}
