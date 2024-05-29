import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remindme/Pages/home.dart';
import 'package:remindme/utility/appColor.dart';
import 'package:remindme/widgets/customButton.dart';
import 'package:remindme/widgets/customfield.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _users= FirebaseFirestore.instance.collection("users");
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appColors.whiteColor,
      body: SafeArea(
          child:SingleChildScrollView(
            child:  Container(
                child: Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: media.height * 0.15,
                        ),
                        Container(
                          width: media.width,
                          alignment: Alignment.center,
                          child: Text(
                            "Create an Account",
                            style: TextStyle(color: appColors.blackColor, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: media.height * 0.1,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Name",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        customField(
                          textEditingController: _namecontroller,
                          textInputType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: media.height * 0.02,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Email",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        customField(
                          textEditingController: _emailcontroller,
                          textInputType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: media.height * 0.02,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Password",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        customField(
                          textEditingController: _passController,
                          textInputType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Password";
                            } else if (value.length < 6) {
                              return "Password must be of atleast 6";
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => signUp()));
                                  },
                                  child: Text(
                                    "New User?",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Forgot your Password?",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: media.height*0.03,
                        ),
                        customButton(title: "Create Account", onPressed: () async {
                          if(_formKey.currentState!.validate()){
                           try{
                             UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: _emailcontroller.text, password:_passController.text);
                             String uid= userCredential.user!.uid;
                             await _users.doc(uid).set({
                               'email':_emailcontroller.text,
                               'name':_namecontroller.text,
                             });
                             Navigator.pushReplacement(
                                 context, MaterialPageRoute(builder: (context) => Home()));
                           }catch(e){
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text(e.toString()))
                             );
                           }
                          }
                        })
                      ],
                    ),
                  ),
                )),
          )),
    );
  }
}
