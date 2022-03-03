import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar',
              style: TextStyle(color: Color(0xff297F87), fontSize: 25),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Gambar Anda',
              style: TextStyle(
                  color: Color(0xff297F87),
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            new Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("riwayat")
                    .snapshots(),
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }


                  if(snapshot.connectionState == ConnectionState.active){
                    if(snapshot.data?.size == 0){
                      return new Center(
                        child: new Text(
                          "Tidak Ada Data",
                          style: new TextStyle(
                            color: Colors.black,
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  }

                  if (!snapshot.hasData) {
                    return new Center(
                      child: new Text(
                        "Tidak Ada Data",
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  final data = snapshot.requireData;
                  return GridView.builder(
                    itemCount: data.size,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                        child: new GridTile(
                          // footer: new Text("${data.docs[index].get("confidence")}"),
                          child: _buildImageWidget(
                            data.docs[index].get("urlDownloadImage"),
                          ), //just for testing, will fill with image later
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Image.network(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
