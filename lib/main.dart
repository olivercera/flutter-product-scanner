import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import './productos.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = '';
  dynamic _producto;

  @override
  void initState() {
    super.initState();
  }

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Cancel", true)
        .listen((barcode) => print(barcode));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes =
          await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    _searchProduct(barcodeScanRes);
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  _searchProduct(codigo) {
    var found = productos.firstWhere(
      (producto) => producto["codigo"] == codigo,
      orElse: () => null,
    );

    setState(() {
      _producto = found;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cavas de la reina'),
          backgroundColor: Colors.teal,
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              alignment: Alignment.center,
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _detalles(),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            initPlatformState();
          },
          child: Icon(Icons.search),
          backgroundColor: Colors.teal,
        ),
      ),
    );
  }

  List<Widget> _detalles() {
    if (_scanBarcode == '') {
      return [
        Text(
          'Busque un producto',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ];
    }

    if (_producto == null) {
      return [
        Text(
          'Producto no encontrado',
        ),
      ];
    }

    return [
      Text(
        '${_producto["nombre"]}',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Text(
        '${_producto["descripcion"]}',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      Text(
        'Precio Unitario: ${_producto["precio_unit"]}',
      ),
      Text(
        'Precio Caja: ${_producto["precio_caja"]}',
      ),
    ];
  }
}
