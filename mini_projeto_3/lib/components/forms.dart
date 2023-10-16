import 'package:f03_lugares/components/main_drawer.dart';
import 'package:f03_lugares/data/my_data.dart';
import 'package:f03_lugares/models/places_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/place.dart';
import '../models/favorite_places_provider.dart';

class Forms extends StatefulWidget {
  final Place? place;  // Adiciona um parâmetro para um lugar existente

  Forms({this.place});

  @override
  _FormsState createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _imagemUrlController = TextEditingController();
  final _avaliacaoController = TextEditingController();
  final _custoMedioController = TextEditingController();
  final _recomendacoesController = TextEditingController();
  final List<String> _selectedCountries = [];
  final List<String> _recomendacoes = [];

  double _rating = 0;
  bool _formSubmitted = false; // Adicione esta linha

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
    setState(() {
      _formSubmitted = true;
    });

    if (_formKey.currentState!.validate() && _selectedCountries.isNotEmpty) {
      // Create a new or updated place
      final place = Place(
        id: widget.place?.id ?? DateTime.now().toString(),
        titulo: _tituloController.text,
        paises: _selectedCountries,
        avaliacao: _rating,
        custoMedio: double.parse(_custoMedioController.text),
        recomendacoes: _recomendacoes,
        imagemUrl: _imagemUrlController.text,
      );

      if (widget.place == null) {
        // Add new place
        Provider.of<PlacesProvider>(context, listen: false).addPlace(place);
        
        // Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Novo lugar adicionado!',
              textAlign: TextAlign.center,  
            ),
            backgroundColor: Colors.green,  
            behavior: SnackBarBehavior.floating,  
          ),
        );

        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      } else {
        // Update existing place
        Provider.of<PlacesProvider>(context, listen: false).updatePlace(place);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.place != null) {
      // Preenche os campos do formulário com os dados existentes se estiver editando um lugar
      _tituloController.text = widget.place!.titulo;
      _imagemUrlController.text = widget.place!.imagemUrl;
      _custoMedioController.text = widget.place!.custoMedio.toString();
      _rating = widget.place!.avaliacao;
      _recomendacoes.addAll(widget.place!.recomendacoes);
      _selectedCountries.addAll(widget.place!.paises);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 0),
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
              if (_selectedCountries.isEmpty && _formSubmitted)
                Center(
                  child: Text(
                    'Por favor, selecione ao menos um país',
                    style: TextStyle(color: Colors.red, fontSize: 12),
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
                  'Avaliação: ${_rating.toStringAsFixed(1)} / 5.0', // Mostra a avaliação numérica
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
                  )),
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
              if (_recomendacoes.isEmpty && _formSubmitted)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Por favor, insira ao menos uma recomendação',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _recomendacoes.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_recomendacoes[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete,  color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _recomendacoes.removeAt(index);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 50)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveForm,
        icon: Icon(Icons.done),
        label: Text('Salvar'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
