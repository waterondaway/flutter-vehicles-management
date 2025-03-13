import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_vehicles_management/addPage.dart';
import 'package:flutter_vehicles_management/editPage.dart';
import 'firebase_options.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CollectionReference vehiclesCollection = FirebaseFirestore.instance.collection('Vehicles');
  List<String> vehiclesImage = ['motorcycle','truck','van'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Vehicles Management", style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPage(vehiclesCollection: vehiclesCollection)));
        }
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            StreamBuilder(
              stream: vehiclesCollection.snapshots(), 
              builder: (context, vehiclesCollection_snapshot) {
                if (vehiclesCollection_snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: Stack(
                      children: [
                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)),
                        Image.asset('assets/images/gas.png', width: 80, height: 80)
                      ]
                    ),
                  );
                }
                if(vehiclesCollection_snapshot.hasData && vehiclesCollection_snapshot.data!.docs.length != 0){
                  var vehiclesDocuments = vehiclesCollection_snapshot.data!.docs;
                  return SizedBox(
                    height: 700,
                    child: ListView.builder(
                    itemCount: vehiclesDocuments.length,
                    itemBuilder: (context, index){
                      var eachVehiclesDocument = vehiclesDocuments[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 0.3,
                              offset: Offset(1, 1),
                            )
                          ]
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                        height: 130,
                        child: Slidable(
                          key: ValueKey(index),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(), 
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(vehiclesCollection: vehiclesCollection, vehiclesDocumentsId: eachVehiclesDocument.id, eachVehiclesDocument: eachVehiclesDocument)));
                                },
                                backgroundColor: Colors.black,
                                icon: Icons.edit,
                                label: 'Edit',
                                padding: EdgeInsets.all(20),
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  vehiclesCollection.doc(eachVehiclesDocument.id).delete();
                                },
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                label: 'Delete',
                                padding: EdgeInsets.all(20),
                              ),
                            ]
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 30),
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/${vehiclesImage[Random().nextInt(vehiclesImage.length)]}.png')
                                    )
                                  ),
                                  
                                ),
                                SizedBox(width: 10),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.only(left: 20),
                                  width: 180,
                                  height: 120,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Order: #${index+1}', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('Brand: ${eachVehiclesDocument['brand']}', style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      Text('Model: ${eachVehiclesDocument['model']}', style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      // Text('Year: ${eachVehiclesDocument['year']}', style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ),
                      );
                    }
                  ));
                } else {
                  return Center(
                    child: Text("You don't have any vehicles data now!"),
                  );
                }
              }
            )
          ],
        )
      )
    ); 
  }
}