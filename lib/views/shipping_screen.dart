import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({Key? key}) : super(key: key);

  @override
  _ShippingScreenState createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  String? _selectedShippingProvider;
  String? _locationAddress;
  final TextEditingController _addressController = TextEditingController();

  Future<void> _getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission(context);
      if (hasPermission) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          setState(() {
            _locationAddress =
                '${placemark.street}, ${placemark.postalCode} ${placemark.locality}, ${placemark.country}';
            _addressController.text = _locationAddress!;
          });
        }
      } else {
        // Обработать случай, когда разрешение не предоставлено
      }
    } catch (e) {
      print(e);
    }
  }


  Future<bool> requestLocationPermission(BuildContext context) async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Показать диалоговое окно с предупреждением
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Разрешение на доступ к геолокации'),
            content: Text(
                'Для использования данного функционала требуется разрешение на доступ к геолокации.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Закрыть'),
              ),
              TextButton(
                onPressed: () {
                  // Повторно запросить разрешение
                  requestLocationPermission(context);
                  Navigator.of(context).pop();
                },
                child: Text('Повторить запрос'),
              ),
            ],
          );
        },
      );
    }
  }

  return permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Providers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedShippingProvider,
              hint: Text('Выберите службу доставки'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedShippingProvider = newValue;
                });
              },
              items: <String>['Emex', 'Yandex Delivery']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Адрес доставки',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _getCurrentLocation,
              child: Text('Использовать текущую геолокацию'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Реализуйте логику обработки доставки здесь
                // Показать сообщение с подтверждением и вернуться на главный экран
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Подтвердить заказ'),
            ),
          ],
        ),
      ),
    );
  }
}

