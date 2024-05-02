import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final FirebaseFirestore db = FirebaseFirestore.instance; //instancia de BD

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  print(document.id);
                  return ListTile(
                    title: Text(document['name']),
                    subtitle: Text(document['last_name']),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
