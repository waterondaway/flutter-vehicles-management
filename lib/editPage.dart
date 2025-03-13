import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPage extends StatefulWidget {
  final CollectionReference vehiclesCollection;
  final String vehiclesDocumentsId;
  final eachVehiclesDocument;
  const EditPage({super.key, required this.vehiclesCollection, required this.vehiclesDocumentsId, required this.eachVehiclesDocument});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  void editVehicles() async {
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
      await widget.vehiclesCollection.doc(widget.vehiclesDocumentsId).update({
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
  final _editFormKey = GlobalKey<FormState>();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit Vehicles", style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Form(
              key: _editFormKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty){
                          return 'Please enter new brand.';
                        }
                      },
                      controller: brandController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Current brand is `${widget.eachVehiclesDocument['brand']}`",
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
                          return 'Please enter new model.';
                        }
                      },
                      controller: modelController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Current model is `${widget.eachVehiclesDocument['model']}`",
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
                          return 'Please enter new year.';
                        }
                      },
                      controller: yearController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:"Current year is `${widget.eachVehiclesDocument['year']}`",
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
                      _editFormKey.currentState!.validate() ? editVehicles() : null; 
                      
                    }, 
                    child: Container(
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.app_registration_rounded, color: Colors.white),
                          SizedBox(width: 20),
                          Text('Confirm Edited', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
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