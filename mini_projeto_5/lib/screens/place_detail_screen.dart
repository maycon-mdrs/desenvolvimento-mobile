import 'package:flutter/material.dart';
import 'package:mini_projeto_5/components/image_input.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/place-form',
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
      body: Column(
        children: <Widget>[
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Localização:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(place.location!.address),
          SizedBox(height: 10),
          //ImageInput(initialImage: place.image),
          Text(
              'Coordenadas: ${place.location!.latitude}, ${place.location!.longitude}'),
          SizedBox(height: 10),
          Text('Telefone: ${place.phoneNumber}'),
        ],
      ),
    );
  }
}
