import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/Screen/HomeScreen.dart';

class AddData extends StatefulWidget {
  const AddData({Key? key}) : super(key: key);

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  List priority = ["Low", "Mediuam", "High", "Urgent"];
  String seleted = "Low";
  final firestore = FirebaseFirestore.instance;
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "To-Do",
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Add To-Do",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  Spacer(),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            onPressed: () async {
                              final doc = firestore.collection("User").doc();
                              await doc.set({
                                "title": title.text,
                                "desc": desc.text,
                                "priority": seleted,
                                "date": dateInput.text,
                                "did": doc.id
                              });
                              title.clear();
                              desc.clear();
                              dateInput.clear();
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ));
                            },
                            icon: Icon(Icons.save)),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.apps_outlined)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Priority",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
              Container(
                clipBehavior: Clip.antiAlias,
                height: 45,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Row(
                  children: priority
                      .map((e) => Expanded(
                          child: InkWell(
                              onTap: () {
                                seleted = e;
                                print(seleted);
                                setState(() {});
                              },
                              child: Container(
                                  color: seleted == e
                                      ? Colors.deepOrangeAccent
                                      : null,
                                  child: Center(
                                      child: Text(
                                    e,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ))))))
                      .toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: title,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Title")),
                maxLength: 150,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: desc,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Description")),
                maxLength: 255,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Pick Date",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  TextButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));
                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            dateInput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {}
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Date",
                            style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                        ],
                      )),
                  Spacer(),
                  Expanded(
                      child: TextField(
                    controller: dateInput,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Date"),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
