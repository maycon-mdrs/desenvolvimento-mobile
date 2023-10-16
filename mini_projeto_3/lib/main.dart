// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:f03_lugares/models/place.dart';
import 'package:f03_lugares/models/places_provider.dart';
import 'package:f03_lugares/screens/countries_places_screen.dart';
import 'package:f03_lugares/screens/place_detail_screen.dart';
import 'package:f03_lugares/screens/place_forms_screen.dart';
import 'package:f03_lugares/screens/places_manage.dart';
import 'package:f03_lugares/screens/settings_screen.dart';
import 'package:f03_lugares/screens/tabs_screen.dart';
import 'package:f03_lugares/utils/app_routes.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'models/favorite_places_provider.dart';

import 'screens/countries_screen.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => FavoritePlacesProvider()),
        ChangeNotifierProvider(create: (ctx) => PlacesProvider()),
      ],
      child: MyApp()
    ));

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlacesToGo',
      theme: ThemeData(
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(primary: Colors.purple, secondary: Colors.amber),
        fontFamily: 'Raleway',
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
              ),
            ),
      ),
      //home: CountriesScreen(),
      initialRoute: '/',
      routes: {
        AppRoutes.HOME: (ctx) => TabsScreen(),
        AppRoutes.COUNTRY_PLACES: (ctx) => CountryPlacesScreen(),
        AppRoutes.PLACES_DETAIL: (ctx) => PlaceDetailScreen(),
        AppRoutes.POST_PLACE: (ctx) => PlaceForms(),
        AppRoutes.PLACES_MANAGE: (ctx) => PlacesManage(),
        AppRoutes.SETTINGS: (ctx) => SettingsScreen(),
      },
    );
  }
}
