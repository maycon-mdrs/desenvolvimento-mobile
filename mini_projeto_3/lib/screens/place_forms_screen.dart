import 'package:f03_lugares/components/main_drawer.dart';
import 'package:flutter/material.dart';

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

  // TODO: Você pode querer criar um estado para gerenciar as recomendações e países

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Aqui você pode adicionar lógica para salvar os dados
      print('Formulário válido');
    } else {
      print('Formulário inválido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Novo Lugar'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagemUrlController,
                decoration: InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma URL de imagem';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _avaliacaoController,
                decoration: InputDecoration(labelText: 'Avaliação'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma avaliação';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _custoMedioController,
                decoration: InputDecoration(labelText: 'Custo Médio'),
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
              // TODO: Adicione campos para países e recomendações
            ],
          ),
        ),
      ),
      drawer: MainDrawer(),
    );
  }
}
