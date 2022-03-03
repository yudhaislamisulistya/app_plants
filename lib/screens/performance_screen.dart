import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({Key? key}) : super(key: key);

  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Riwayat Anda',
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
                stream: FirebaseFirestore.instance.collection("riwayat").snapshots(),
                builder: (context, snapshot) {
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

                  return new ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (BuildContext context, int index) {
                      String kelas_train = "";
                      // if(index >= 0 && index <= 4){
                      //   kelas_train = "C1";
                      // }else if(index >= 0 && index <= 4){
                      //   kelas_train = "C1";
                      // }
                      return new Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                              colors: [Color(0xff6DC8F3), Color(0xff297F87)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff73A1F9),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: new Row(
                          children: [
                            new Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    data.docs[index].get('urlDownloadImage'),
                                  ),
                                ),
                              ),
                            ),
                            new SizedBox(
                              width: 10.0,
                            ),
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Text(
                                  "Prediksi : " + data.docs[index].get("label"),
                                  style: new TextStyle(color: Colors.white),
                                ),
                                // new Text("Kelas Train : " + kelas_train,style: new TextStyle(
                                //   color: Colors.white,
                                // ),),
                                new Text(
                                  "Confidence : " +
                                      data.docs[index].get("confidence").toString(),
                                  style: new TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
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
}
