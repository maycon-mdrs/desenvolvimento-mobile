import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mini_projeto_5/models/place.dart';

import '../screens/map_screen.dart';
import '../utils/location_util.dart';

class LocationInput extends StatefulWidget {
  final Function(double, double, String) onSelectLocation;
  final PlaceLocation? initialLocation;

  LocationInput(this.onSelectLocation, {this.initialLocation});
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: widget.initialLocation!.latitude,
        longitude: widget.initialLocation!.longitude,
      );
      setState(() {
        _previewImageUrl = staticMapImageUrl;
      });
    }
  }
  
  Future<void> _getCurrentUserLocation() async {
    final locData =
        await Location().getLocation(); //pega localização do usuário
    print(locData.latitude);
    print(locData.longitude);

    //CARREGANDO NO MAPA

    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: locData.latitude, longitude: locData.longitude);

    final address = await LocationUtil.getAddressFrom(locData.latitude!, locData.longitude!);


    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
    widget.onSelectLocation(locData.latitude!, locData.longitude!, address);
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
          fullscreenDialog: true, builder: ((context) => MapScreen())),
    );

    if (selectedPosition == null) return;

    print(selectedPosition.latitude);
    print(selectedPosition.longitude);

    final address = await LocationUtil.getAddressFrom(selectedPosition.latitude, selectedPosition.longitude);

    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: selectedPosition.latitude,
        longitude: selectedPosition.longitude);

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
    widget.onSelectLocation(selectedPosition.latitude, selectedPosition.longitude, address);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? Text('Localização não informada!')
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Localização atual'),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text('Selecione no Mapa'),
              onPressed: _selectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
