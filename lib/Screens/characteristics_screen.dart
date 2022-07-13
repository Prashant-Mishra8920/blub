import 'package:blub/Screens/descriptors_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CharacteristicsScreen extends StatefulWidget {
  final BluetoothService service;

  const CharacteristicsScreen({
    Key? key,
    required this.service,
    }) : super(key: key);

  @override
  State<CharacteristicsScreen> createState() => _CharacteristicsScreenState(service: service);
}

class _CharacteristicsScreenState extends State<CharacteristicsScreen> 
  with SingleTickerProviderStateMixin{

    final BluetoothService service;

    _CharacteristicsScreenState({
    Key? key,
    required this.service,
    });

    late TabController controller;

    List<BluetoothCharacteristic> bc = [];


    void fetchServices(){
      for(BluetoothCharacteristic i in service.characteristics){
        bc.add(i);
      }
      setState(() {
        
      });
    }

    @override
    void initState() {
      super.initState();

      fetchServices();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Characteristics"),
        ),
        body: 
            _buildCharateristic(bc),
    );
  }


  Widget _buildCharateristic(List<BluetoothCharacteristic> bc) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: bc.length,
      itemBuilder: (context, i) {
        return _buildCharacteristicRow(bc[i],i+1);
      },
    );
  }

   //Row....................................................................................
  Widget _buildCharacteristicRow(BluetoothCharacteristic characteristic,int count) {
    return Card(
      color: (characteristic.descriptors.isNotEmpty) ? Colors.green.shade100: Colors.red.shade100,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10,left: 5,right: 5),
        child: ListTile(   
          title: Text("Characteristic - $count \n",
          style: const TextStyle(
            fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            children: [
              CustRow(keyVal: "uuid : ", valVal: characteristic.uuid.toString()),
              CustRow(keyVal: "deviceId : ", valVal: characteristic.deviceId.toString()),
              CustRow(keyVal: "serviceUuid: ", valVal: characteristic.serviceUuid.toString()),
              CustRow(keyVal: "broadcast : ", valVal: characteristic.properties.broadcast.toString()),
              CustRow(keyVal: "read : ", valVal: characteristic.properties.read.toString()),
              CustRow(keyVal: "writeWithoutResponse : ", valVal: characteristic.properties.writeWithoutResponse.toString()),
              CustRow(keyVal: "write : ", valVal: characteristic.properties.write.toString()),
              CustRow(keyVal: "notify : ", valVal: characteristic.properties.notify.toString()),
              CustRow(keyVal: "indicate : ", valVal: characteristic.properties.indicate.toString()),
              CustRow(keyVal: "authenticatedSignedWrites : ", valVal: characteristic.properties.authenticatedSignedWrites.toString()),
              CustRow(keyVal: "extendedProperties : ", valVal: characteristic.properties.extendedProperties.toString()),
              CustRow(keyVal: "notifyEncryptionRequired : ", valVal: characteristic.properties.notifyEncryptionRequired.toString()),
              CustRow(keyVal: "indicateEncryptionRequired : ", valVal: characteristic.properties.indicateEncryptionRequired.toString()),
            ],
          ),
          onTap:(){
            (characteristic.descriptors.isNotEmpty) ? Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DescriptorScreen(caracter: characteristic)))
              : Null;
          },
        ),
      ),
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
}