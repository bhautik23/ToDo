import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/Screen/AddData.dart';
import 'package:todo/Screen/HomeScreen.dart';

class DataScreen extends StatelessWidget {
  List colors = [
    Colors.yellowAccent,
    Colors.blueAccent,
    Colors.orange,
    Colors.red
  ];
  DataScreen({super.key});

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        systemOverlayStyle: Get.isDarkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          "To-D0",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
        ),
        actions: [
          Row(
            children: [
              Icon(
                CupertinoIcons.text_alignleft,
                size: 18,
                color: Colors.black,
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    color: Colors.black,
                    onPressed: () {
                      Get.changeTheme(
                        Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
                      );
                    },
                    icon: Icon(CupertinoIcons.brightness),
                  )),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: firestore.collection("User").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final docs = snapshot.data!.docs;
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final _daTa = docs[index].data();
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: colors[index],
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _daTa["title"].toString(),
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey,
                                        ),
                                        child: Center(
                                          child: Text(
                                            _daTa["priority"].toString(),
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 10),
                                  child: Text(
                                    _daTa["desc"].toString(),
                                    style: GoogleFonts.poppins(
                                        letterSpacing: 1,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Text(
                                      _daTa["date"].toString(),
                                      style: GoogleFonts.poppins(
                                          letterSpacing: 1,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  }
                  return CircularProgressIndicator();
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddData(),
              ));
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black, width: 2)),
      ),
    );
  }
}
