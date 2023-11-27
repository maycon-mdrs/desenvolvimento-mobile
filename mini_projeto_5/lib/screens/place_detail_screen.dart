// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mini_projeto_5/components/image_input.dart';
import 'package:mini_projeto_5/utils/app_routes.dart';
import 'package:mini_projeto_5/utils/location_util.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/great_places.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key});

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
              Navigator.of(ctx).pop(); // Fecha o diálogo
            },
          ),
          TextButton(
            child: Text('Sim'),
            onPressed: () {
              Provider.of<GreatPlaces>(context, listen: false)
                  .deletePlace(placeId);
              Navigator.of(ctx).pop(); // Fecha o diálogo
              Navigator.of(context).pop(); // Retorna para a tela anterior
              SnackBar(
                content: Text(
                  'Lugar excluído com sucesso!',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obter o ID do lugar passado como argumento
    final placeId = ModalRoute.of(context)?.settings.arguments as String;
    // Acessar os dados do lugar usando o Provider
    final place =
        Provider.of<GreatPlaces>(context, listen: false).findById(placeId);

    final imageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: place.location!.latitude,
      longitude: place.location!.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PLACE_EDIT,
                arguments: place,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, placeId),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: FileImage(place.image),
                    radius: 55, // ajuste o tamanho conforme a necessidade
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: place.location?.address ?? '',
                          decoration: InputDecoration(
                            labelText: 'Endereço',
                          ),
                          readOnly: true,
                          maxLines: 2,
                        ),
                        TextFormField(
                          initialValue:
                              '${place.location!.latitude}, ${place.location!.longitude}',
                          decoration: InputDecoration(
                            labelText: 'Coordenadas - Latitude, Longitude',
                          ),
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.phone),
                    label: Text(place.phoneNumber.toString()),
                    onPressed: () async {
                      final Uri url = Uri.parse('tel:${place.phoneNumber}');
                      if (!await launchUrl(url)) {
                        // Se a URL não puder ser lançada, você pode mostrar um erro ou um aviso
                        print(
                            'Não foi possível realizar a chamada para ${place.phoneNumber}');
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
