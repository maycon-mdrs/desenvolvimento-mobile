// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 183, 58, 116),
            inversePrimary: Color(0xFF607d8b)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _firstName = '';
  String _lastName = '';
  String _cpf = '';
  String _address = '';
  String _city = '';
  DateTime _dataSelecionada = DateTime.now();

  final _dataSelcionadaController = TextEditingController();

  List<DropdownMenuItem> states = [
    DropdownMenuItem(value: 'RN', child: Text('RN')),	
    DropdownMenuItem(value: 'RJ', child: Text('RJ')),	
    DropdownMenuItem(value: 'RS', child: Text('RS')),	
  ]; 

  List<DropdownMenuItem> countries = [
    DropdownMenuItem(value: 'BRASIL', child: Text('BRASIL')),	
    DropdownMenuItem(value: 'USA', child: Text('USA')),
  ]; 

  _showDatePicker() {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2024))
          .then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _dataSelcionadaController.text = DateFormat('dd/MM/y').format(pickedDate);
        });
      });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Application',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Settings'),
                ),
                PopupMenuItem(
                  child: Text('About'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Text(
              'Personal info',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onSaved: (value) {
                _firstName = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Last Name'),
              onSaved: (value) {
                _lastName = value!;
              },
            ),
            Row(
              children: [
                Expanded(
                    child: Column(children: [
                  TextFormField(
                      decoration: InputDecoration(labelText: "Birthday", helperText: "DD/MM/YYYY"),
                      readOnly: true,
                      onTap: _showDatePicker,
                      controller: _dataSelcionadaController,
                  ) 
                ])),
                
                SizedBox(width: 16.0), 
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'CPF', helperText: '000.000.000-00'),
                    onSaved: (value) {
                      _cpf = value!;
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                  ),
                ),
              ],
            ),
            SizedBox(height: 36.0),
            Text(
              'Endereço de Residência',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Endereço'),
              onSaved: (value) {
                _address = value!;
              },
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Cidade'),
                    onSaved: (value) {
                      _city = value!;
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                    child: 
                    DropdownButtonFormField(
                      items: states,
                      onChanged: (value) => {},
                      itemHeight: 70,
                      decoration: InputDecoration(hintText: 'Estado'),
                    )),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'CEP', counterText: ''),
                    onSaved: (value) {
                      _city = value!;
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 9,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                    child: 
                    DropdownButtonFormField(
                      items: countries,
                      onChanged: (value) => {},
                      itemHeight: 70,
                      decoration: InputDecoration(hintText: 'País'),
                    )),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => print('salvar'),
              child: Text('SALVAR'),
            ),
          ],
        ),
      ),
    );
  }
}
