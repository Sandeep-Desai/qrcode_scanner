// import 'dart:js';

import 'package:flutter/material.dart';

import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:qrcode_scanner/api/sheets/googlesheetAPI.dart';
import 'package:qrcode_scanner/api/sheets/googlesheetAPI.dart';
import 'package:qrcode_scanner/models/qr.dart';
import 'package:qrcode_scanner/models/trafficGS.dart';
int counter =1;
bool isvalid=true;
int row_no=0;
int col_no=2;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // counter=1;
  await googleSheetsAPI.init();
  runApp(const MyApp());
}

createAlertDialogue(BuildContext context)
{
  return showDialog(context: context, builder: (context)
  {
    return AlertDialog(
      title: Text("Invalid User"),
      content: Text("This QR Code is already scanned, avoid scanning same QR multiple times."),
    );
  });
}
Future _scanQR(BuildContext context) async
  {
    
    try
    {
      var qrResult=await BarcodeScanner.scan();
     
      final qrCode={
        sheetfeilds.srNo:counter,
        sheetfeilds.qrResult:qrResult.rawContent.toString()
      };
      final trafficMess=
      {
        trafficfiedls.jaiswalOld:counter.toString()
      };
      // print(qrResult.rawContent.toString());
      
      for(int i=2;i<=counter+1;i++)
      {
        bool temp=await googleSheetsAPI.isEqual(qrResult.rawContent.toString(),i,2);
        if(temp)
        {
          isvalid=false;
          break;
        }
      }

      if(isvalid)
      {
        await googleSheetsAPI.insert([qrCode]);
        await googleSheetsAPI.updateCell([trafficMess]);
        counter++;
        
      }
      else
      {
        // print("This QR Code is already scanned");
        createAlertDialogue(context);
      }
      
      
      
    
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
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton.extended(icon:Icon(Icons.qr_code),label: Text("Scan"),onPressed:()=> _scanQR(context),);
            }
          ),floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

