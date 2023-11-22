import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mini_projeto_5/components/image_input.dart';
import 'package:mini_projeto_5/components/location_input.dart';
import 'package:mini_projeto_5/models/place.dart';
import 'package:mini_projeto_5/provider/great_places.dart';

class PlaceEditScreen extends StatefulWidget {
  const PlaceEditScreen({super.key});

  @override
  State<PlaceEditScreen> createState() => _PlaceEditScreenState();
}

class _PlaceEditScreenState extends State<PlaceEditScreen> {
  final _titleController = TextEditingController();
  final _phoneController = TextEditingController();
  //deve receber a imagem
  File? _pickedImage;
  PlaceLocation? _pickedLocation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.settings.arguments != null) {
      final Place placeToEdit = ModalRoute.of(context)!.settings.arguments as Place;
      _titleController.text = placeToEdit.title;
      _phoneController.text = placeToEdit.phoneNumber ?? '';
      _pickedImage = placeToEdit.image;
      _pickedLocation = placeToEdit.location;
    }
  }
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
  
  void _selectImage(File? pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectLocation(double latitude, double longitude, String address) {
    print(address);
    _pickedLocation = PlaceLocation(
        latitude: latitude, longitude: longitude, address: address);
  }

  void _submitForm() {
    print(_pickedLocation);
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }
    print('tem os dados');
    final place = ModalRoute.of(context)?.settings.arguments as Place?;
    if (place != null) {
      // Atualizar o lugar existente
      Provider.of<GreatPlaces>(context, listen: false).updatePlace(
        place.id,
        Place(
          id: place.id,
          title: _titleController.text,
          image: _pickedImage!,
          location: _pickedLocation!,
          phoneNumber: _phoneController.text,
        ),
      );
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lugar atualizadao com sucesso!',
              textAlign: TextAlign.center,  
            ),
            backgroundColor: Colors.green,  
            behavior: SnackBarBehavior.floating,  
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    //final placeId = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Lugar'),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Título',
                      ),
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration:
                          InputDecoration(labelText: 'Número de Telefone'),
                    ),
                    SizedBox(height: 10),
                    ImageInput(
                      this._selectImage,
                      initialImage: _pickedImage,),
                    SizedBox(height: 10),
                    LocationInput(_selectLocation, initialLocation: _pickedLocation,),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Salvar'),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              onPrimary: Colors.black,
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _submitForm,
          ),
        ],
      ),
    );
  }
}
