import 'dart:async';

import 'package:blub/Screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> 
with SingleTickerProviderStateMixin{
  late TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {
        showConnected();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    for(ScanResult i in connectedList){
      i.device.disconnect();
    }
    super.dispose();
  }
  
  bool searching = false;
  IconData icon = Icons.search;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> list = [];
  List<ScanResult> connectedList = [];
  List<BluetoothDevice> de = [];
  int connectedCount = 0;
  int count = 4;

  // final pt = Timer.periodic(Duration(seconds: 1),((timer) => {
  //       print(timer)
  // }));


  void showConnected() async{
    de = await flutterBlue.connectedDevices;
    for(BluetoothDevice i in de){
      print("Bluetooth Devices: $i");
    }
  }

  void bleDevice() {
    list.clear();

    var search = flutterBlue.startScan(timeout: const Duration(seconds: 4));
    search.whenComplete(() => {
      setState(() {
      searching = false;
      })
    });
    flutterBlue.scanResults.listen((results) {
      // print(results);
      print("results length: ${results.length}");
      for (ScanResult r in results) {
        if (r.device.name.isNotEmpty) {
            list.add(r);
          // print(r);
        }
      }

      // print(list);
      // setState(() {
      //   Timer(const Duration(seconds: 1),() =>{
      //     count--
      //   });
      // });
      // print(pt.tick);

      results.clear();
    });
  }
  void stopSearch(){
    // pt.cancel();
    flutterBlue.stopScan();
    setState(() {
      searching = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Blub app'),
        actions: [
          Row(
            children: [
              Visibility(
                visible: searching,
                child: Builder(
                  builder: ((context) => Text(count.toString())
                  ))
              ),
              Visibility(
                visible: searching,
                child: Builder(
                  builder: ((context) => IconButton(onPressed: (){
                    stopSearch();
                    Fluttertoast.showToast(
                      msg: "searching stopped",
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }, icon: const Icon(Icons.cancel))))
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: controller,
          tabs: const [
            Tab(text: 'Devices'),
            Tab(text: 'Connected'),
          ]
        ),
        
      ),
      body: TabBarView(
        controller: controller,
        children: [
          Container(
            decoration: const BoxDecoration(color: Color.fromRGBO(230, 230, 230, 1)),
            child: Stack(
              children: [
                _buildDevice(list,de),
                Visibility(
                  visible: list.isEmpty ? true : false,
                  child: Align(
                    alignment: Alignment.center,
                    child: Lottie.network('https://assets6.lottiefiles.com/datafiles/vhvOcuUkH41HdrL/data.json',
                      width: 250,
                      height: 250),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Color.fromRGBO(230, 230, 230, 1)),
            child: Stack(
              children: [
                _buildDevice(list,de),
                Visibility(
                  visible: list.isEmpty ? true : false,
                  child: Align(
                    alignment: Alignment.center,
                    child: Lottie.network('https://assets6.lottiefiles.com/datafiles/vhvOcuUkH41HdrL/data.json',
                      width: 250,
                      height: 250),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(controller.index == 0) {bleDevice();}
          else {
            // showConnectedDevices(); 
            showConnected();}
          setState(() {
            searching = true;
          });
          Fluttertoast.showToast(
          msg: "Searching",
          toastLength: Toast.LENGTH_SHORT,
          );
        },
        child: Icon(icon),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }


  //Listview builder........................................................................
  Widget _buildDevice(List<ScanResult> l,List<BluetoothDevice> lc) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: (controller.index == 0)?l.length:lc.length,
      itemBuilder: (context, i) {
        if(controller.index == 0){return _buildRow(l[i]);}
        else {return _buildConnectedRow(lc[i]);}
      },
    );
  }


  //Row....................................................................................
  Widget _buildRow(ScanResult device) {
    return Card(
      child: ListTile(   
          title: Text(device.device.name,
          style:const TextStyle(
            fontWeight: FontWeight.bold),
          ),
          subtitle: Text("rssi: ${device.rssi}",
            style: TextStyle(
            color: device.rssi > -80 ? Colors.green: Colors.red,),
          ),
          trailing: const Icon(Icons.navigate_next,),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailScreen(device: device,)));
          },
      ),
    );
  }

  //Row....................................................................................
  Widget _buildConnectedRow(BluetoothDevice device) {
    return Card(
      child: ListTile(   
          title: Text(device.name,
          style:const TextStyle(
            fontWeight: FontWeight.bold),
          ),
          subtitle: Text("rssi: ${device.id}",
          ),
          trailing: const Icon(Icons.cancel,),
          // onTap: (){
          //   Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => DetailScreen(,)));
          // },
          onLongPress: (){
            device.disconnect();
            showConnected();
            setState(() {
            });
          },
      ),
    );
  }
}