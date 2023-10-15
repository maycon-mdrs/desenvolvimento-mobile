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
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _imagemUrlController = TextEditingController();
  final _avaliacaoController = TextEditingController();
  final _custoMedioController = TextEditingController();
  final _recomendacoesController = TextEditingController();
  final List<String> _selectedCountries = [];
  final List<String> _recomendacoes = [];

  double _rating = 0;

  void _addRecomendacao() {
    final value = _recomendacoesController.text;
    if (value.isNotEmpty) {
      setState(() {
        _recomendacoes.add(value);
        _recomendacoesController.clear();
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate() && _selectedCountries.isNotEmpty) {
      // Create a new place
      final newPlace = Place(
        id: DateTime.now().toString(),
        titulo: _tituloController.text,
        paises: _selectedCountries,
        avaliacao: _rating,
        custoMedio: double.parse(_custoMedioController.text),
        recomendacoes: _recomendacoes,
        imagemUrl: _imagemUrlController.text,
      );

      print(newPlace);

      // Use provider to add new place
      Provider.of<PlacesProvider>(context, listen: false).addPlace(newPlace);

      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Novo Lugar'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _imagemUrlController,
                decoration: InputDecoration(
                  labelText: 'URL da Imagem',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma URL de imagem';
                  }
                  if (!value.startsWith('http') && !value.startsWith('https')) {
                    return 'Por favor, insira uma URL válida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _custoMedioController,
                decoration: InputDecoration(
                  labelText: 'Custo Médio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um custo médio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: Wrap(
                  children: DUMMY_COUNTRIES.map((country) {
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                      child: FilterChip(
                        label: Text(country.title),
                        selected: _selectedCountries.contains(country.id),
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              _selectedCountries.add(country.id);
                            } else {
                              _selectedCountries.remove(country.id);
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (_selectedCountries.isEmpty)
                Center(
                  child: Text(
                    'Por favor, selecione ao menos um país',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              Center(
                child: RatingBar.builder(
                  initialRating: _rating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 35,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating; // Atualize o valor da avaliação aqui
                    });
                    print(rating);
                  },
                ),
              ),
              Center(
                child: Text(
                  'Avaliação: ${_rating.toStringAsFixed(1)} / 5', // Mostra a avaliação numérica
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _recomendacoesController,
                      decoration: InputDecoration(
                        labelText: 'Adicionar Recomendação',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onFieldSubmitted: (value) => _addRecomendacao(),
                    )
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addRecomendacao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _recomendacoes.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_recomendacoes[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _recomendacoes.removeAt(index);
                      });
                    },
                  ),
                ),
              ),
              if (_recomendacoes.isEmpty)
                SizedBox(height: 10),
                Text(
                  'Por favor, insira ao menos uma recomendação',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
      drawer: MainDrawer(),
    );
  }
}
