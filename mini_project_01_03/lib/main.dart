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
  @override
  Widget build(BuildContext context) {

    TextEditingController _peso = TextEditingController();
    TextEditingController _altura =TextEditingController();
    String imc = '';

    imcCalculator() {
      double peso = double.parse(_peso.text);
      double altura = double.parse(_altura.text);
      double imcCal = peso / ((altura/100 ) * (altura/100));

      setState(() {
        imc = imcCal.toStringAsFixed(1);
      });
      print(imc);
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('IMC'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _peso,
                      keyboardType: TextInputType.number,
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
                child: Text('Calcular'),        
              ),
              SizedBox(height: 25),
              Text(
                "IMC: $imc",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}