import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cote_pat/Page/profile_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'Modifier.dart';
import '../../common/them_helper.dart';
import '../SplashScreen.dart';
import 'image.dart';

class Modifier_Profile extends StatefulWidget {
  const Modifier_Profile({Key? key}) : super(key: key);

  @override
  State<Modifier_Profile> createState() => _Modifier_ProfileState();
}

class _Modifier_ProfileState extends State<Modifier_Profile> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  Future uploadFile() async {
    final path = 'files/images/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    //FirebaseStorage
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    // The link to the profil image ///////////////////////////////////////////////
    final urldownload = await snapshot.ref.getDownloadURL();
    Urldownload = urldownload;
    //////////////////////////////////////---------------------URL --------------------------////////////////////////////////////
    print('Download Link of the profil image: $urldownload');
  }

  Future selectfile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future getaPic() async {
    await FirebaseFirestore.instance
        .collection("Docuser")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        Urldownload = element.data()["picture"];
      });
    });
  }

  Future getDataPhone() async {
    await FirebaseFirestore.instance
        .collection("Docuser")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        phone = element.data()["phone"];
      });
    });
  }

  Future getData() async {
    await FirebaseFirestore.instance
        .collection("Docuser")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        firstname = element.data()["firstname"];
      });
    });
    return firstname;
  }

  Future getDataLast() async {
    await FirebaseFirestore.instance
        .collection("Docuser")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        lastname = element.data()["lastname"];
      });
    });
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("Patuser")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        event.docs.forEach((element) {
          Urldownload = element.data()["picture"];
          print("picture :${element.data()["picture"]}");
        });
      });
    });

    // getData();
    // getDataLast();
    // getabout();
    // getDataPhone();
    // getDataStreet();
//     getDataEmail();
//     getDataHousenum();

    super.initState();
  }

  @override
  String? firstnamme;
  String? lastnamme;
  var phonne;
  final _formKey = GlobalKey<FormState>();
  final CollectionReference userref =
      FirebaseFirestore.instance.collection("Patuser");
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        backgroundColor: Colors.blue,
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text("Retour"),
        titleSpacing: -15,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(56, 124, 240, 100),
                                    width: 5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: ClipOval(
                                child: pickedFile != null
                                    ? Image.file(
                                        File(pickedFile!.path!),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        Urldownload!,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: ElevatedButton.icon(
                            onPressed: selectfile,
                            icon: Icon(
                              Icons.add_a_photo_sharp,
                              size: 18,
                            ),
                            label: Text('Pic IMAGE'.toUpperCase())),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      //Modifier(),
                      ////////////////////////
                      Form(
                        child: Column(
                          key: _formKey,
                          children: [
                            Container(
                               padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: TextFormField(
                                onSaved: (val) {
                                  if (val == null) {
                                    firstnamme = firstname;
                                  } else {
                                    firstnamme = val;
                                  }
                                },
                                //controller: _fname,
                                decoration: ThemHelper().textInputDecoration(
                                    'First Name', 'Enter your first name'),
                              ),
                              decoration:
                                  ThemHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            Container(
                               padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: TextFormField(
                                onSaved: (val) {
                                  if (val == null) {
                                    lastnamme = lastname;
                                  } else {
                                    lastnamme = val;
                                  }
                                },
                                //  controller: _lname,
                                decoration: ThemHelper().textInputDecoration(
                                    'Last Name', 'Enter your last name'),
                              ),
                              decoration:
                                  ThemHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            Container(
                               padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: TextFormField(
                                onSaved: (val) {
                                  if (val == null) {
                                    phonne = phone;
                                  }
                                  else{
                                    phonne = val;
                                  }
                                  
                                },
                                keyboardType: TextInputType.phone,
                                decoration: ThemHelper().textInputDecoration(
                                    'phone', 'Enter your phone'),
                              ),
                              decoration:
                                  ThemHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            Container(
                              decoration:
                                  ThemHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                  style: ThemHelper().buttonStyle(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Text(
                                      "confirmer".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await uploadFile();
                                    //   _formKey.currentState?.save();
                                    var formdata = _formKey.currentState;
                                    formdata?.save();
                                    // final String? fname = _fname.text;
                                    // final String? lname = _lname.text;
                                    await userref
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update(
                                      {
                                        "firstname": firstnamme,
                                        "lastname": lastnamme,
                                        "phone": phonne,
                                        "picture": Urldownload,
                                      },
                                    );
                                    FirebaseFirestore.instance
                                        .collection("Patuser")
                                        .where("owner",
                                            isEqualTo: FirebaseAuth
                                                .instance.currentUser!.uid)
                                        .snapshots()
                                        .listen((event) {
                                      setState(() {
                                        event.docs.forEach((element) {
                                          firstnamme =
                                              element.data()["firstname"];
                                          print(
                                              "firstname :${element.data()["firstname"]}");
                                          lastnamme = element.data()["lastname"];
                                          print(
                                              "lastname :${element.data()["lastname"]}");
                                          phonne = element.data()["phone"];
                                          print(
                                              "phone :${element.data()["phone"]}");
                                        });
                                      });
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()));
                                    // await userref
                                    //     .doc(FirebaseAuth.instance.currentUser!.uid)
                                    //     .update({
                                    //   "lastname": lname.text,
                                    //   "firstname": fname.text,
                                    //   "phone": phne,
                                    // });
                                  }),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //  Container(
                  //     decoration: ThemHelper().buttonBoxDecoration(context),
                  //   child: ElevatedButton(
                  //          style: ThemHelper().buttonStyle(),
                  //          child: Padding(
                  //           padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                  //            child: Text(
                  //              "confirmer".toUpperCase(),
                  //             style: TextStyle(
                  //                fontSize: 20,
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.white,
                  //             ),
                  //            ),
                  //         ),
                  //          onPressed: () async {
                  //            uploadFile();},),)
                  //         // await userref
                  //         //     .doc(FirebaseAuth.instance.currentUser!.uid)
                  //         //     .update({
                  //         //   "firstname": firstname,
                  //         //   "lastname": lastname,
                  //         //   // "phone":phone,
                  //         //   "picture": Urldownload,
                  //         // });
                  //         // //    var patusr = FirebaseFirestore.instance
                  //         //    .collection("Patuser")
                  //         //  .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  //         //     .snapshots()
                  //         //     patusr.update({
                  //         //     '':,
                  //         //     })
                  //       }),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
