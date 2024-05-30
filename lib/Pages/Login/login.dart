import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remindme/Pages/home.dart';
import 'package:remindme/utility/appColor.dart';
import 'package:remindme/widgets/customButton.dart';
import 'package:remindme/widgets/customfield.dart';
import 'signUp.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<User?> _signIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed")),
      );
      return null;
    }
  }

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
                            "Login",
                            style: TextStyle(color: appColors.blackColor, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: media.height * 0.1,
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
                          ],
                        ),
                        SizedBox(
                          height: media.height*0.03,
                        ),
                        customButton(title: "Login", onPressed: (){
                          if(_formKey.currentState!.validate()){
                            _signIn(context, _emailcontroller.text, _passController.text);
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
