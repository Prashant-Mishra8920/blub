import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DescriptorScreen extends StatefulWidget {
  final BluetoothCharacteristic caracter;

  const DescriptorScreen({
    Key? key,
    required this.caracter,
    }) : super(key: key);

  @override
  State<DescriptorScreen> createState() => _DescriptorScreenState(character: caracter);
}

class _DescriptorScreenState extends State<DescriptorScreen> {
  final BluetoothCharacteristic character;
  _DescriptorScreenState({
    Key? key,
    required this.character
    });

    List<BluetoothDescriptor> bd = [];

    void getDescriptors(){
      for(BluetoothDescriptor i in character.descriptors){
        bd.add(i);
      }
      setState(() {
        
      });
    }

    @override
  void initState() {
    getDescriptors();
    super.initState();
  }

    // if(i.descriptors.isNotEmpty){
    //       for(BluetoothDescriptor j in i.descriptors){
    //         bd.add(j);
    //         print("Characteristics: $i");
    //       }
    //     }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Descriptors"),
      ),
      body: _buildDescriptor(bd),
    );
  }
}

Widget _buildDescriptor(List<BluetoothDescriptor> bd) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: bd.length,
      itemBuilder: (context, i) {
        return _buildDescriptorRow(bd[i],i+1);
      },
    );
  }

   //Row....................................................................................
  Widget _buildDescriptorRow(BluetoothDescriptor descriptor,int count) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10,left: 5,right: 5),
        child: ListTile(   
          title: Text("Descriptor - $count \n",
          style: const TextStyle(
            fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            children: [
              CustRow(keyVal: "uuid : ", valVal: descriptor.uuid.toString()),
              // CustRow(keyVal: "deviceId : ", valVal: descriptor.deviceId.toString()),
              CustRow(keyVal: "serviceUuid: ", valVal: descriptor.serviceUuid.toString()),
              CustRow(keyVal: "characteristicUuid: ", valVal: descriptor.characteristicUuid.toString()),
              CustRow(keyVal: "value : " , valVal: descriptor.value.toString()),
            ],
          ),
        ),
      ),
    );
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