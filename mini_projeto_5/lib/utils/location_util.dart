import 'dart:convert';
import 'package:http/http.dart' as http;
const GOOGLE_API_KEY = 'AIzaSyAkPmCW5nqO3H_bWJN4XWe90UQSxnR5zjI';

class LocationUtil {
  static Future<String> getAddressFrom(double latitude, double longitude) async {
    final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Falha ao obter endereço');
    }

    return json.decode(response.body)['results'][0]['formatted_address'];
  }
  
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    //https://developers.google.com/maps/documentation/maps-static/overview
    //https://pub.dev/packages/google_maps_flutter
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }
}
