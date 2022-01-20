// import 'dart:js';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cron/cron.dart';
// import 'package:audioplayers/audio_cache.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:qrcode_scanner/api/sheets/googlesheetAPI.dart';
import 'package:qrcode_scanner/api/sheets/googlesheetAPI.dart';
import 'package:qrcode_scanner/models/qr.dart';
import 'package:qrcode_scanner/models/trafficGS.dart';

int counter =0;
int people_no=0;
bool isvalid=true;
int row_no=0;
int col_no=2;
List <Map> database=[];
List <Map> qrBase=[]; 

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // counter=1;
  await googleSheetsAPI.init();
  var cron= new Cron();
  cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
   print("Cron func is running succesfully "+people_no.toString()); 
  //  print(people_no);
    for(int i=0;i<counter;i++)
    {
      // dynamic currentTime = DateFormat.jm().format(DateTime.now());
      // DateTime now = DateTime.now();
      // bool t=await googleSheetsAPI.isNotValid(now,i,3);
      if(database[i]["Valid"]==1)
      {
        if(DateTime.now().isAfter(database[i]["ExitTime"]))
      {
        people_no--;
        database[i]["Valid"]=0;
        
      }

      }
      googleSheetsAPI.updateCell(id: 1, key: "Count", value: people_no);
      
      
      // googleSheetsAPI.updateCell(id: 2, key: "Count", value: people_no);
    }
    print(database);
    
  });
  runApp(const MyApp());

}

createAlertDialogue(BuildContext context)
{
  return showDialog(context: context, builder: (context)
  {
    return AlertDialog(
      title: Text("Invalid User",style: TextStyle(color:Colors.red),),
      content: Text("This QR Code is already scanned, avoid scanning same QR multiple times."),
    );
  });
}
Future _scanQR(BuildContext context) async
  {
    
    try
    {
      var qrResult=await BarcodeScanner.scan();
     
      
      
      // print(qrResult.rawContent.toString());
      int ct=0;
      for(int i=0;i<counter;i++)
      {
        // bool temp=await googleSheetsAPI.isEqual(qrResult.rawContent.toString(),i,2);
        if(qrResult.rawContent==qrBase[i]["QrCode"])
        {
           isvalid=false;
          // print(i);
          ct++;
          break;
        }
       
        
      }
      if(ct==0)
      {
        isvalid=true;
      }
      if(isvalid)
      {
        dynamic currentTime = DateFormat.jm().format(DateTime.now());
        DateTime now = DateTime.now();

        var exittime=now.add(const Duration(days:0,hours: 0,minutes: 3,seconds: 0));
        
       
        
        counter++;
        people_no++;
        final mapForDB=
        {
          "No":counter,
          "EntryTime":now,
          "ExitTime":exittime,
          "Valid":1
        };
        database.add(mapForDB);
        final mapforQR=
        {
          "No":counter,
          "QrCode":qrResult.rawContent,
        };
        qrBase.add(mapforQR);
        // AudioCache player = new AudioCache();
        // const alarmAudioPath = "mixkit-quick-win-video-game-notification-269.wav";
        // player.play(alarmAudioPath);
       
        // await googleSheetsAPI.insert([qrCode]);
        print(database);
        // await googleSheetsAPI.insertTraffic([trafficMess]);
        
        
        
      }
      else
      {
        // print("This QR Code is already scanned");
        // SystemSound.play(SystemSoundType.click);
        // AudioCache player = new AudioCache();
        // const alarmAudioPath = "fail-buzzer-04.wav";
        // player.play(alarmAudioPath);
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
          
          child: Text("Hey There!",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
          
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

