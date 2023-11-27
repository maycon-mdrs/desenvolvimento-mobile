import 'package:flutter/material.dart';
import 'package:mini_projeto_5/provider/auth.dart';
import 'package:mini_projeto_5/screens/login_page.dart';
import 'package:mini_projeto_5/screens/place_detail_screen.dart';
import 'package:mini_projeto_5/screens/place_edit_screen.dart';
import 'package:provider/provider.dart';

import 'provider/great_places.dart';
import 'screens/place_form_screen.dart';
import 'screens/places_list_screen.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GreatPlaces()),
        ChangeNotifierProvider(create: (context) => Auth()), // Adiciona o Auth provider
      ],
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData().copyWith(
            colorScheme: ThemeData().colorScheme.copyWith(
                  primary: Colors.indigo,
                  secondary: Colors.amber,
                )),
        home: LoginPage(),
        routes: {
          AppRoutes.PLACE_LOGIN:(context) => LoginPage(),
          AppRoutes.PLACE_LIST: (ctx) => PlacesListScreen(),
          AppRoutes.PLACE_FORM: (ctx) => PlaceFormScreen(),
          AppRoutes.PLACE_DETAIL: (ctx) => PlaceDetailScreen(),
          AppRoutes.PLACE_EDIT: (ctx) => PlaceEditScreen(),
        },
      ),
    );
  }
}
