import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  final CollectionReference vehiclesCollection;
  const AddPage({super.key, required this.vehiclesCollection});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  void addVehicles() async {
    showDialog(
      context: context, 
      builder: (context) {
        return Center(
          child: Stack(
            children: [
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)),
              Image.asset('assets/images/gas.png', width: 120, height: 120)
            ]
          ),
        );
      }
    );
    try {
      await widget.vehiclesCollection.add({
        'brand': brandController.text,
        'model': modelController.text,
        'year': yearController.text,
      });
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      print(e.message);
    }
    Navigator.pop(context);
  }

  final _addFormKey = GlobalKey<FormState>();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Vehicles", style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Form(
              key: _addFormKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: TextFormField(
                      controller: brandController,
                      validator: (value) {
                        if (value!.isEmpty){
                          return 'Please enter a brand.';
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Brand',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2))
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: TextFormField(
                      controller: modelController,
                      validator: (value) {
                        if (value!.isEmpty){
                          return 'Please enter a model.';
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Model',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2))
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty){
                          return 'Please enter a year.';
                        }
                      },
                      controller: yearController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Year',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2))
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                    ),
                    onPressed: () {
                      _addFormKey.currentState!.validate() ? addVehicles() : null; 
                      
                    }, 
                    child: Container(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.app_registration_rounded, color: Colors.white),
                          SizedBox(width: 20),
                          Text('Add Vehicles', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
                        ],
                      ),
                    )
                ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}