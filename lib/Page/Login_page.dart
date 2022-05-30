import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cote_pat/Page/Registration_page.dart';
import 'package:cote_pat/Page/Registration_pageForPat.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../common/them_helper.dart';
import 'Widgets/Header_widget.dart';
import 'forgot_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
//   IconData set =ImageIcon(
//      AssetImage("images/LogoWhite.png"),
// ) as IconData;
  late UserCredential userCredential;
  var emaill, passwordd;
  bool? isAccepted;
  String? num;

  showLoading(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("please wait"),
            content: Container(
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                      height: h * 0.32,
                      child: HeaderWidget(
                        h * 0.33,
                        false,
                        Icons.person,
                      )),
                  Center(
                    child: Container(
                        height: h * 0.25,
                        width: w * 0.2,
                        child: Center(
                          child: Image(
                            image: AssetImage("img/LogoWhite.png"),
                          ),
                        )),
                  ),
                ],
              ),
              SafeArea(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //The login form
                    child: Column(
                      children: [
                        Container(
                            height: h * 0.12,
                            child:
                                Image(image: AssetImage("img/blueLogo.png"))),
                        Text(
                          "Sign into your account",
                          style: TextStyle(color: Colors.grey),
                        ),
                        // Text(
                        //   "DocTell",
                        //   style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                        // ),
                        SizedBox(
                          height: h * 0.015,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  child: TextFormField(
                                    onSaved: (val) {
                                      emaill = val;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: ThemHelper()
                                        .textInputDecoration(
                                            'Email', 'Enter your email'),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Please enter your email";
                                      }
                                      if (!(val!.isEmpty) &&
                                          !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                              .hasMatch(val)) {
                                        return "Enter a valid email address";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(
                                  height: h * 0.03,
                                ),
                                Container(
                                  child: TextFormField(
                                    onSaved: (val) {
                                      passwordd = val;
                                    },
                                    obscureText: true,
                                    decoration: ThemHelper()
                                        .textInputDecoration(
                                            'Password', 'Enter your password'),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Please enter your password";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(
                                  height: h * 0.018,
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPasswordPage()),
                                      );
                                    },
                                    child: Text(
                                      "Forgot your password?",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration:
                                      ThemHelper().buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                      style: ThemHelper().buttonStyle(),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 10, 40, 10),
                                        child: Text(
                                          'sign in'.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () async {
                                        _formKey.currentState?.save();
                                        print("====================");
                                        print(emaill);
                                        /////////// use sign in
                                        if (_formKey.currentState!.validate()) {
                                          try {
                                            showLoading(context);
                                            userCredential = await FirebaseAuth
                                                .instance
                                                .signInWithEmailAndPassword(
                                                    email: emaill,
                                                    password: passwordd);

                                            await FirebaseFirestore.instance
                                                .collection("Docuser")
                                                .where("email",
                                                    isEqualTo: emaill)
                                                .get()
                                                .then((value) {
                                              value.docs.forEach((element) {
                                                isAccepted = element
                                                    .data()["isAccepted"];
                                              });
                                            });
                                            print(isAccepted);
                                            if (isAccepted == null) {
                                              print(
                                                  "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");

                                              //  await  FirebaseFirestore.instance
                                              //       .collection("Docuser").doc("0hjS2QFEgTMDOfCc6GdU").get().then((value) =>
                                              //       print(value.data()?["isAccepted"]));

                                              bool? exist;
                                              await FirebaseFirestore.instance
                                                  .collection("Adresses")
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .get()
                                                  .then((docs) {
                                                exist = docs.exists;
                                                print(exist);
                                              });
                                              print(exist);

                                              print(
                                                  "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");

                                              if (!FirebaseAuth.instance
                                                  .currentUser!.emailVerified) {
                                                Navigator.of(context).pop();
                                                Navigator.pushReplacementNamed(
                                                    context, "verify");
                                              } else if (exist == false) {
                                                Navigator.of(context).pop();
                                                Navigator.pushReplacementNamed(
                                                    context, "adress");
                                              } else if (FirebaseAuth.instance
                                                  .currentUser!.emailVerified) {
                                                Navigator.of(context).pop();

                                                Navigator.pushReplacementNamed(
                                                    context, "splash");
                                              }
                                            } else {
                                              Navigator.of(context).pop();

                                              await FirebaseAuth.instance
                                                  .signOut();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ThemHelper().alartDialog(
                                                      "Erreur:",
                                                      "It is a doctor account !!.",
                                                      context);
                                                },
                                              );
                                            }
                                          } on FirebaseAuthException catch (e) {
                                            if (e.code == 'user-not-found') {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ThemHelper().alartDialog(
                                                      "Erreur:",
                                                      "No user found for that email.",
                                                      context);
                                                },
                                              );
                                              print(
                                                  'No user found for that email.');
                                            } else if (e.code ==
                                                'wrong-password') {
                                              Navigator.of(context).pop();

                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ThemHelper().alartDialog(
                                                      "Erreur:",
                                                      "Wrong password provided for that user.",
                                                      context);
                                                },
                                              );
                                              print(
                                                  'Wrong password provided for that user.');
                                            } else {
                                              Navigator.of(context).pop();

                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ThemHelper()
                                                      .alartDialog(
                                                          "erreur",
                                                          e.message.toString(),
                                                          context);
                                                },
                                              );
                                              FirebaseAuth.instance.signOut();
                                            }
                                          }

                                          ////////////////////////////

                                          //// creating users
                                          /////////////////
                                          //     try {
                                          //       userCredential = await FirebaseAuth
                                          //           .instance
                                          //           .createUserWithEmailAndPassword(
                                          //         email: email,
                                          //         password: password,
                                          //       );
                                          //       print(userCredential);
                                          //     } on FirebaseAuthException catch (e) {
                                          //       if (e.code == 'weak-password') {
                                          //         print(
                                          //             'The password provided is too weak.');
                                          //       } else if (e.code ==
                                          //           'email-already-in-use') {
                                          //              showDialog(
                                          //   context: context,
                                          //   builder: (BuildContext context) {
                                          //     return ThemHelper().alartDialog(
                                          //         "Email",
                                          //         "The account already exists for that email.",
                                          //         context);
                                          //   },
                                          // );
                                          //         print(
                                          //             'The account already exists for that email.');
                                          //       }
                                          //     } catch (e) {
                                          //       print(e);
                                        }
                                      }
                                      // },
                                      ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  //  child:Text("Don't have an account? Create!"),
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(text: "Don't have an account?"),
                                    TextSpan(
                                      text: "Create!",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegistrationPageForDoc()));
                                        },
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                  ])),
                                )
                              ],
                            ))
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buttonBoxDecoration(BuildContext context) {}

  forgotPasswordPage() {}
}
