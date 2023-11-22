import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mini_projeto_5/models/place.dart';
import 'package:provider/provider.dart';

import '../components/image_input.dart';
import '../components/location_input.dart';
import '../provider/great_places.dart';

class PlaceFormScreen extends StatefulWidget {
  @override
  _PlaceFormScreenState createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  final _phoneController = TextEditingController(); 
  //deve receber a imagem
  File? _pickedImage;
  PlaceLocation?
      _pickedLocation; // Variável para armazenar a localização escolhida

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
    Provider.of<GreatPlaces>(context, listen: false).addPlace(
        _titleController.text,
        _pickedImage!,
        _pickedLocation!,
        _phoneController.text);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lugar adicionado com sucesso!',
              textAlign: TextAlign.center,  
            ),
            backgroundColor: Colors.green,  
            behavior: SnackBarBehavior.floating,  
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Lugar'),
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
                    ImageInput(this._selectImage),
                    SizedBox(height: 10),
                    LocationInput(_selectLocation),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Adicionar'),
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
