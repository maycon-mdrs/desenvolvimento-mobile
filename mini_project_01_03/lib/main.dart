// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TextEditingController _peso = TextEditingController();
  TextEditingController _altura = TextEditingController();
  String _info = '';
  String _imc = '';
  String _imagemPath = '';

  imcCalculator() {
    // Fechar o teclado
    FocusManager.instance.primaryFocus?.unfocus(); // Fecha o teclado numérico
    
    setState(() {
      double peso = double.parse(_peso.text);
      double altura = double.parse(_altura.text);
      double imcCal = peso / ((altura / 100) * (altura / 100));
      String imc = imcCal.toStringAsFixed(1);
      _imc = 'IMC = $imc';

      if (imcCal < 18.5) {
        _info = 'Abaixo do Peso';
        _imagemPath = './assets/img/1.png';
      } else if (imcCal >= 18.5 && imcCal < 25) {
        _info = 'Peso Normal';
        _imagemPath = './assets/img/2.png';
      } else if (imcCal >= 25 && imcCal < 30) {
        _info = 'Sobrepeso';
        _imagemPath = './assets/img/3.png';
      } else if (imcCal >= 30 && imcCal < 35) {
        _info = 'Obesidade Grau I';
        _imagemPath = './assets/img/4.png';
      } else if (imcCal >= 35 && imcCal < 40) {
        _info = 'Obesidade Grau II';
        _imagemPath = './assets/img/5.png';
      } else if (imcCal >= 40) {
        _info = 'Obesidade Mórbida';
        _imagemPath = './assets/img/6.png';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: const Color.fromARGB(255, 39, 176, 121),
          secondary: Colors.blue,
      )),
      home: Scaffold(
        appBar: AppBar(
          title: Text('IMC Calculadora'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _peso,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            labelText: 'Peso (kg)',
                            hintText: 'Digite seu peso',
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: _altura,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          decoration: InputDecoration(
                            labelText: 'Altura (cm)',
                            hintText: 'Digite sua altura',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: imcCalculator,
                    child: Text('CALCULAR'),
                  ),
                  SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_imagemPath.isNotEmpty) // Verifique se _imagemPath não está vazio
                      Image.asset(
                        _imagemPath,
                        height: 250,
                      ),
                      if (_imagemPath.isNotEmpty) // Verifique se _imagemPath não está vazio
                      Divider(
                        color: Color(0xFF70c5d0), 
                        thickness: 4,       
                        height: 0,          
                      ),
                      SizedBox(height: 25),
                      if (_imc.isNotEmpty && _info.isNotEmpty)
                      Card(
                        color: Color(0xFF70c5d0),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                _info,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                _imc,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus(); // Fecha o teclado numérico
              setState(() {
                _peso.clear();
                _altura.clear();
                _imc = '';
                _info = '';
                _imagemPath = '';
              });
            },
            child: Icon(Icons.delete),
        ),
      ),
    );
  }
}
