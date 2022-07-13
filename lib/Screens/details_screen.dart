import 'package:blub/Screens/characteristics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailScreen extends StatefulWidget{
  
  final ScanResult device;
  const DetailScreen({
    Key? key,
    required this.device
    }) : super(key: key);
  // const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreen(device: device);

}

class _DetailScreen extends State<DetailScreen> {
  final ScanResult device;
  _DetailScreen({
    Key? key,
    required this.device
    });
  bool connected = false;
  bool ccon = false;
  List<BluetoothDescriptor> bd = [];
  List<BluetoothService> bs = [];
  List<BluetoothCharacteristic> bc = [];

  void connect() async {
    Fluttertoast.showToast(
          msg: "connecting...",
          toastLength: Toast.LENGTH_SHORT,
    );
    setState(() {
      ccon = true;
      connected = true;
    });

    await device.device.connect();
    List<BluetoothService> services = await device.device.discoverServices();
    services.forEach((service) async{

        setState(() {
          ccon = false;
        });

        if(service.characteristics.isNotEmpty){
          bs.add(service);
        }
        print("Service :\n $service");
        
        var characteristics = service.characteristics;
        for(BluetoothCharacteristic c in characteristics) {
            // List<int> value = await c.read();
            bc.add(c);
            print("Characteristics : \n$c");

          var descriptors = c.descriptors;
          for(BluetoothDescriptor d in descriptors) {
              // List<int> value = await d.read();
              bd.add(d);
              print("Descriptors: \n $d");
          }
          setState(() {
            
          });
        }
    });
  }
  void disconnect(){
    // MyData data = MyData();
    // data.connectedDevices.remove(device);

    Fluttertoast.showToast(
          msg: "Disconnected",
          toastLength: Toast.LENGTH_SHORT,
        );
    device.device.disconnect();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        // if(connected){ disconnect();}
        // else{ print("Not connected");}
        Fluttertoast.showToast(
          msg: "Back pressed",
          toastLength: Toast.LENGTH_SHORT,
        );

        return true;
      },
      child:  Scaffold(
        appBar: AppBar(
          title: Text(device.device.name),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Color.fromRGBO(230, 230, 230, 1)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CustRow(keyVal: "Device Id :", valVal: device.device.id.id),
                          CustRow(keyVal: "Device rssi : ", valVal: device.rssi.toString()),
                          CustRow(keyVal: "Device Type : ", valVal: device.device.type.name),
                          CustRow(keyVal: "Connectable : ", valVal: device.advertisementData.connectable.toString()),
                          CustRow(keyVal: "Manufacturer Data : ", valVal: device.advertisementData.manufacturerData.toString(),),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),
                                  onPressed: ()=> connect(), 
                                  child: const Text("connect"),
                                ),
                                Visibility(
                                  visible: (connected)?true:false,
                                  child: ElevatedButton(
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(Colors.red),
                                    ),
                                    onPressed: ()=> disconnect(),
                                    child: const Text("disconnect"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Visibility(
                    visible: ccon,
                    child: const CircularProgressIndicator(),
                  ),
                ),
                Expanded(
                    child: _buildService(bs),
                ), 
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildService(List<BluetoothService> l) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: l.length,
      itemBuilder: (context, i) {
        return _buildServiceRow(l[i],i+1);
      },
    );
  }

   //Row....................................................................................
  Widget _buildServiceRow(BluetoothService service, int count) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(   
          title: Text("Service - $count \n",
          style: const TextStyle(
            fontWeight: FontWeight.bold),
          ),
          subtitle:Column(
            children: [
              CustRow(keyVal: "uuid : ", valVal: service.uuid.toString()),
              CustRow(keyVal: "deviceId : ", valVal: service.deviceId.toString()),
              CustRow(keyVal: "isPrimary : ", valVal: service.isPrimary.toString()),
              // CustRow(keyVal: "serviceUuid: ", valVal: device.serviceUuid.toString()),
              // CustRow(keyVal: "characteristicUuid: ", valVal: device.characteristicUuid.toString()),
              // CustRow(keyVal: "value : " , valVal: device.value.toString()),
            ],
          ),
          onTap:(){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CharacteristicsScreen(service: service,)));
          },
        ),
      ),
    );
  }
}

class ServiceWidget extends StatelessWidget {
  const ServiceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text("Characteristics",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),

      ],
    );
  }
}

class CustRow extends StatelessWidget {
  final String keyVal;
  final String valVal;
  
  const CustRow(
    {
      Key? key,
      required this.keyVal,
      required this.valVal,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(keyVal,style:const TextStyle(fontWeight: FontWeight.bold),),
        Flexible(
          child: Text(valVal.toString(),),
        ),
      ],
    );
  }

   //Listview builder......................................................................
}