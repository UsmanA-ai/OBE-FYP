import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../profile_view/profile_admin_page.dart';
class AdminEnrollMobilePage extends StatefulWidget {
  const AdminEnrollMobilePage({super.key});

  @override
  State<AdminEnrollMobilePage> createState() => _AdminEnrollMobilePageState();
}

class _AdminEnrollMobilePageState extends State<AdminEnrollMobilePage> {

  Uint8List? _image;
  final TextEditingController cnic = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController id = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController fname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();
  final TextEditingController paddress = TextEditingController();
  final TextEditingController taddress = TextEditingController();
  String? tcity = 'Rawalpindi';
  String? tdistrict = 'Rawalpindi';
  String? pcity = 'Rawalpindi';
  String? pdistrict = 'Rawalpindi';
  final TextEditingController bg = TextEditingController();
  String? gender = 'Male';
  final GlobalKey<FormState> formkey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formkey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formkey3 = GlobalKey<FormState>();
  // Function to pick an image from gallery
  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

// Function to upload image to Firebase Storage
  Future<String?> _uploadImageToFirebase() async {
    if (_image == null) return null;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('image_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putData(_image!);
      final downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }

  //Signup function start from here.............
  Future<void> signup(BuildContext context) async {
    if (!formkey1.currentState!.validate()) {
      // If any form is not valid, show an alert dialog with an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill all the fields correctly.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you want to continue?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  // Upload image to Firebase Storage
                  final imageUrl = await _uploadImageToFirebase();
                  print('Creating user...'); // Debugging statement
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email.text.trim(),
                    password: password.text,
                  );
                  print('User created successfully!'); // Debugging statement
                  await FirebaseFirestore.instance
                      .collection('admin')
                      .doc(userCredential.user!.uid)
                      .set(
                    {
                      'Bgroup': bg.text,
                      'Cnic': cnic.text,
                      'Dob': dob.text,
                      'Email': email.text,
                      'Fname': fname.text,
                      'Gender': gender,
                      'Id': id.text,
                      'Image': imageUrl,
                      'Name': name.text,
                      'Paddress': paddress.text,
                      'Password': password.text,
                      'Pcity': pcity,
                      'Pdistrict': pdistrict,
                      'Phone': phone.text,
                      'Taddress': taddress.text,
                      'Tcity': tcity,
                      'Tdistrict': tdistrict,
                    },
                  );
                  print('Sending verification email...'); // Debugging statement
                  await userCredential.user!.sendEmailVerification();
                  print('Verification email sent!'); // Debugging statement
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Success'),
                        content: const Text(
                            'Registration successful.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                              // Clear form fields
                              setState(() {
                                bg.clear();
                                cnic.clear();
                                dob.clear();
                                email.clear();
                                fname.clear();
                                id.clear();
                                name.clear();
                                paddress.clear();
                                password.clear();
                                phone.clear();
                                taddress.clear();
                              });
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } on FirebaseAuthException catch (e) {
                  Fluttertoast.showToast(msg: e.code);
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $error'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Continue'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text("Admin Registration",style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blue.shade900,
          centerTitle: true,
        ),
        body: Container(
            width:double.infinity,
            height: double.infinity,
            color: Colors.lightBlue.shade50,
            child: Form(
              key: formkey1,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(padding: EdgeInsets.only(right: 20)),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: 100,
                            height: 100,
                            child: _image !=
                                null
                                ? CircleAvatar(
                              radius: 50,
                              backgroundImage:
                              MemoryImage(
                                  _image!),
                            )
                                : const CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                AssetImage(
                                    "assets/images/avator.png")),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 40)),
                          Container(
                            width:120,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey.withOpacity(0.5), // Shadow color
                                  spreadRadius: 3, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: const Offset(0, 2), // Offset in the x, y direction
                                ),
                              ],
                            ),
                            child: ElevatedButton(onPressed:_pickProfileImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue,
                                ),
                                child: const Text("Upload",style: TextStyle(fontSize: 20,color: Colors.white),)
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          const Text("Upload Image",style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                      const Padding(
                        padding:EdgeInsets.all(5),
                        child: Divider(thickness: 3,),
                      ),
                      const Padding(
                        padding:EdgeInsets.only(top: 2,right: 120),
                        child: Text("PROFILE INFORMATION",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 20),),
                      ),
                      const Padding(
                        padding:EdgeInsets.all(5),
                        child: Divider(thickness: 3,),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:20),
                            child: Text("Admin ID:",style: TextStyle(color: Colors.blue,fontSize: 20),),
                          ),
                          Padding(
                            padding:const EdgeInsets.only(top:5,left:40),
                            child: SizedBox(
                              width: 230,
                              height: 40,
                              //color: Colors.red,
                              child: TextFormField(
                                validator: (value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter your id';
                                  }
                                  return null;
                                },
                                controller: id,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    hintText:"Enter Admin ID",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:20),
                            child: Text("Name:",style: TextStyle(color: Colors.blue,fontSize: 20),),
                          ),
                          Padding(
                            padding:const EdgeInsets.only(top:5,left:70),
                            child: SizedBox(
                              width: 230,
                              height: 40,
                              //color: Colors.red,
                              child: TextFormField(
                                validator: (value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter your name';
                                  }
                                  return null;
                                },
                                controller: name,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    hintText:"Enter Admin Name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:20),
                            child: Text("Father Name:",style: TextStyle(color: Colors.blue,fontSize: 20),),
                          ),
                          Padding(
                            padding:const EdgeInsets.only(top:5,left:7),
                            child: SizedBox(
                              width: 230,
                              height: 40,
                              //color: Colors.red,
                              child: TextFormField(
                                validator: (value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Father Name';
                                  }
                                  return null;
                                },
                                controller: fname,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    hintText:"Enter Father Name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:20),
                            child: Text("Email:",style: TextStyle(color: Colors.blue,fontSize: 20),),
                          ),
                          Padding(
                            padding:const EdgeInsets.only(top:5,left:74),
                            child: SizedBox(
                              width: 230,
                              height: 40,
                              //color: Colors.red,
                              child: TextFormField(
                                validator:(value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter email';
                                  }
                                  return null;
                                },
                                controller:email,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    hintText:"Enter Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:20),
                            child: Text("Phone No:",style: TextStyle(color: Colors.blue,fontSize: 20),),
                          ),
                          Padding(
                            padding:const EdgeInsets.only(top:5,left:36),
                            child: SizedBox(
                              width: 230,
                              height: 40,
                              //color: Colors.red,
                              child: TextFormField(
                                validator:(value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Phone Number';
                                  }
                                  return null;
                                },
                                controller:phone,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                    hintText:"Enter Phone Number",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:20),
                            child: Text("CNIC:",style: TextStyle(color: Colors.blue,fontSize: 20),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:5,left:78),
                            child: SizedBox(
                              width: 230,
                              height: 40,
                              //color: Colors.red,
                              child:  TextFormField(
                                validator:(value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your cnic no';
                                  }
                                  return null;
                                },
                                controller:cnic,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText:"Enter cnic",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:20),
                            child: Text("Gender",style: TextStyle(color: Colors.blue,fontSize: 20),),
                          ),
                          const Padding(
                            padding:EdgeInsets.only(top:5,left:33),
                          ),
                          Padding(
                              padding:const EdgeInsets.only(left:35),
                              child: DropdownButton<String>(
                                value: gender,
                                hint: const Text("Select Gender"),
                                onChanged: (value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                                items: ['Male', 'Female', 'Other']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:20),
                            child: Text("Date of Birth:",style: TextStyle(color: Colors.blue,fontSize: 20),),
                          ),
                          Padding(
                            padding:const EdgeInsets.only(top:5,left:15),
                            child: SizedBox(
                              width: 230,
                              height: 40,
                              //color: Colors.red,
                              child: TextFormField(
                                validator:(value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter date of birth';
                                  }
                                  return null;
                                },
                                controller:dob,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    hintText:"dd/mm/yyyy",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:20),
                            child: Text("Blood Group:",style: TextStyle(color: Colors.blue,fontSize: 20),),
                          ),
                          Padding(
                            padding:const EdgeInsets.only(top:5,left:18),
                            child: SizedBox(
                              width: 230,
                              height: 40,
                              //color: Colors.red,
                              child: TextFormField(
                                validator:(value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter blood group';
                                  }
                                  return null;
                                },
                                controller:bg,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    hintText:"Enter Blood Group",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:20),
                            child: Text(
                              "Password :",
                              style: TextStyle(color: Colors.blue,fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:5,left:35),
                            child: SizedBox(
                              width: 230,
                              height: 40,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                controller: password,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                obscuringCharacter: "*",
                                decoration: const InputDecoration(
                                    hintText: "Enter Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue))),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:20),
                            child: Text(
                              "C Password :",
                              style: TextStyle(color: Colors.blue,fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:5,left:17),
                            child: SizedBox(
                              width: 230,
                              height: 40,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter your confirm password';
                                  }
                                  if(password.text!=cpassword.text)
                                  {
                                    return'password and conform password is incorrect';
                                  }
                                  return null;
                                },
                                controller: cpassword,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                obscuringCharacter: "*",
                                decoration: const InputDecoration(
                                    hintText: "Enter Confirm Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue))),
                              ),
                            ),
                          )
                        ],
                      ),
                      const Padding(
                        padding:EdgeInsets.all(5),
                        child: Divider(thickness: 3,),
                      ),
                      const Padding(
                        padding:EdgeInsets.only(top: 5,right: 120),
                        child: Text("PREMANENT ADDRESS",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 20),),
                      ),
                      const Padding(
                        padding:EdgeInsets.only(top: 1,bottom: 1,right: 5,left: 5),
                        child: Divider(thickness: 3,),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:10),
                            child: Text("Address:",style: TextStyle(color: Colors.black,fontSize: 20),),
                          ),
                          Padding(
                            padding:const EdgeInsets.only(top:5,left:25),
                            child: SizedBox(
                              width: 250,
                              height: 40,
                              //color: Colors.red,
                              child: TextFormField(
                                validator:(value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Address';
                                  }
                                  return null;
                                },
                                controller: paddress,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                    hintText:"Enter Address",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:10),
                            child: Text("District:",style: TextStyle(color: Colors.black,fontSize: 20),),
                          ),
                          Padding(
                              padding:const EdgeInsets.only(left:35),
                              child: DropdownButton<String>(
                                value: pdistrict,
                                hint: const Text("Select District"),
                                onChanged: (value) {
                                  setState(() {
                                    pdistrict = value!;
                                  });
                                },
                                items: ['Rawalpindi', 'Gujarat', 'Other']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                          )
                        ],
                      ),
                      const Padding(
                        padding:EdgeInsets.all(5),
                        child: Divider(thickness: 3,),
                      ),
                      const Padding(
                        padding:EdgeInsets.only(top: 5,right: 150),
                        child: Text("PRESENT ADDRESS",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 20),),
                      ),
                      const Padding(
                        padding:EdgeInsets.only(top: 1,bottom: 1,right: 5,left: 5),
                        child: Divider(thickness: 3,),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:10),
                            child: Text("Address:",style: TextStyle(color: Colors.black,fontSize: 20),),
                          ),
                          Padding(
                            padding:const EdgeInsets.only(top:5,left:25),
                            child: SizedBox(
                              width: 250,
                              height: 40,
                              //color: Colors.red,
                              child: TextFormField(
                                validator:(value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Address';
                                  }
                                  return null;
                                },
                                controller: taddress,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                    hintText:"Enter Address",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding:EdgeInsets.only(left:10),
                            child: Text("District:",style: TextStyle(color: Colors.black,fontSize: 20),),
                          ),
                          Padding(
                              padding:const EdgeInsets.only(left:35),
                              child: DropdownButton<String>(
                                value: tdistrict,
                                hint: const Text("Select District"),
                                onChanged: (value) {
                                  setState(() {
                                    tdistrict = value!;
                                  });
                                },
                                items: ['Rawalpindi', 'Gujarat', 'Other']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width:100,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey.withOpacity(0.5), // Shadow color
                                  spreadRadius: 3, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: const Offset(0, 2), // Offset in the x, y direction
                                ),
                              ],
                            ),
                            child: ElevatedButton(onPressed:() =>
                                signup(
                                    context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text("Enroll",style: TextStyle(fontSize: 20,color: Colors.white),)
                            ),
                          ),
                          const SizedBox(width: 20,),
                          Container(
                            width:130,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Shadow color
                                  spreadRadius: 3, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: const Offset(0, 2), // Offset in the x, y direction
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                                onPressed: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminProfileMobilePage()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300,
                                ),
                                child: const Text("View",style: TextStyle(fontSize: 20,color: Colors.blue),)
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }
}
