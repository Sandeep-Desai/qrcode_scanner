import 'package:flutter/material.dart';

import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:qrcode_scanner/api/sheets/googlesheetAPI.dart';
import 'package:qrcode_scanner/api/sheets/googlesheetAPI.dart';
import 'package:qrcode_scanner/models/qr.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await googleSheetsAPI.init();
  runApp(const MyApp());
}


Future _scanQR() async
  {
    
    try
    {
      var qrResult=await BarcodeScanner.scan();
      final qrCode={
        sheetfeilds.srNo:1,
        sheetfeilds.qrResult:qrResult
      };
    
    }
    catch(e)
    {
      print(e);
    }
     
    
    
  }
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: Scaffold(
        backgroundColor:Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("QR Code Scanner"),
        ),
        body: Center(
          child: Text("Hey There!",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold))
          ),
          floatingActionButton: FloatingActionButton.extended(icon:Icon(Icons.qr_code),label: Text("Scan"),onPressed: _scanQR,),floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

