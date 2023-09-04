// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

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
  late DateTime _birthday;

  final List<String> states = [
    'RN',
    'RJ',
    'RS'
  ]; // Adicione os estados desejados
  final List<String> countries = ['BRASIL']; // Adicione os países desejados

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
              decoration: InputDecoration(hintText: 'Name'),
              onSaved: (value) {
                _firstName = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Last Name'),
              onSaved: (value) {
                _lastName = value!;
              },
            ),
            Row(
              children: [
                Expanded(
                    child: Column(children: [
                  TextField(
                      decoration: InputDecoration(labelText: "Birthday"),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                      })
                ])),
                
                SizedBox(width: 16.0), 
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'CPF'),
                    onSaved: (value) {
                      _cpf = value!;
                    },
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
            TextFormField(
              decoration: InputDecoration(labelText: 'Cidade'),
              onSaved: (value) {
                _city = value!;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (Form.of(context).validate()) {
                  Form.of(context).save();
                  // Faça algo com os dados
                  print('Nome: $_firstName $_lastName');
                  print('CPF: $_cpf');
                  print('Endereço: $_address');
                  print('Cidade: $_city');
                }
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
