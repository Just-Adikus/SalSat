import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:salsat_marketplace/screens/transaction_screen.dart';
class ShippingScreen extends StatefulWidget {
  final Map<String, dynamic> shippingData;

  ShippingScreen({required this.shippingData});

  @override
  _ShippingScreenState createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  String? _selectedShippingProvider;
  String? _locationAddress;
  final TextEditingController _addressController = TextEditingController();
  List<Marker> _markers = [];

  LatLng? _deliveryLocation;
  
Widget _generateQRCode() {
  String qrData = widget.shippingData.toString();

  return FutureBuilder<ui.Image>(
    future: QrPainter(
      data: qrData,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    ).toImage(200),
    builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return RawImage(
          image: snapshot.data,
          width: 200,
          height: 200,
        );
      }
    },
  );
}

  @override
  void initState() {
    super.initState();
    _populateShippingData();
  }

void _populateShippingData() {
  String deliveryAddress = widget.shippingData['deliveryAddress'] ?? '';
  String deliveryPersonName = (widget.shippingData['deliveryPersonName'] ?? 'SalSat Logistics') as String;
  _addressController.text = deliveryAddress;
  _selectedShippingProvider = deliveryPersonName;  // use a default value
}


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
            _deliveryLocation = LatLng(position.latitude, position.longitude);
            _markers = [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _deliveryLocation!,
                builder: (ctx) => const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ];
          });
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Разрешение на геолокацию'),
              content: Text(
                  'Для использования этой функции необходимо разрешение на доступ к геолокации.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Закрыть'),
                ),
                TextButton(
                  onPressed: () {
                    requestLocationPermission(context);
                    Navigator.of(context).pop();
                  },
                  child: Text('Повторить'),
                ),
              ],
            );
          },
        );
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Разрешение на геолокацию'),
              content: Text(
                  'Для использования этой функции необходимо разрешение на доступ к геолокации.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Закрыть'),
                ),
                TextButton(
                  onPressed: () {
                    requestLocationPermission(context);
                    Navigator.of(context).pop();
                  },
                  child: Text('Повторить'),
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

    Future<File> _generateReceipt(Map<String, dynamic> shippingData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              shippingData.toString(),
              style: pw.TextStyle(fontSize: 30),
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/receipt.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  Future<String> _uploadReceipt(File file, String transactionId) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('receipts/$transactionId.pdf');
    UploadTask uploadTask = ref.putFile(file);
    
    await uploadTask.whenComplete(() => null);
    
    String url = await ref.getDownloadURL();
    return url;
  }

  void onQrScanned() async {
    // Генерируем случайный ID транзакции
    String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Генерируем чек
    File receipt = await _generateReceipt(widget.shippingData);
    
    // Загружаем чек в Firestore и получаем URL
    String receiptUrl = await _uploadReceipt(receipt, transactionId);

    // Здесь вы можете сохранить transactionId и receiptUrl в коллекции "transactions" Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Тауарды жеткізу',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButton<String>(
                value: _selectedShippingProvider,
                hint: Text('Жеткізушіні таңдау'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedShippingProvider = newValue;
                  });
                },
                items: <String>['SalSat Logistics', 'Yandex Delivery']
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
                  labelText: 'Мекенжай',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _getCurrentLocation,
                child: Text('Ағымдағы геолокацияны көрсету'),
              ),
              SizedBox(height: 20),
              _deliveryLocation != null
                  ? SizedBox(
                      height: 300,
                      child: FlutterMap(
                        options: MapOptions(
                          center: _deliveryLocation,
                          zoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(markers: _markers),
                        ],
                      ),
                    )
                  : Text('Картаны көру үшін мекенжайыңызды жазыңыз'),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('QR-код'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _generateQRCode(),
                            SizedBox(height: 15,),
                            Text('Тапсырысты растау үшін QR кодты сканерден өткізіңіз'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => TransactionScreen()));
                            },
                            child: Text('Мақұлдау'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Растау',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}