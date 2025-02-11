import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components.dart';

class StudentAssignmentPage extends StatefulWidget {
  // final String courseName; // Receive course name to filter assignments
  const StudentAssignmentPage({super.key});
  // const StudentAssignmentPage({super.key});
  @override
  State<StudentAssignmentPage> createState() => _StudentAssignmentPageState();
}
class _StudentAssignmentPageState extends State<StudentAssignmentPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> assignments = [];
  @override
  void initState() {
    super.initState();
    fetchAssignmentData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(user!.uid)
        .get();
    return snapshot.data() as Map<String, dynamic>;
  }

  Future<void> fetchAssignmentData() async {
    try{
      List<Map<String, dynamic>> loadedAssignments = [];

    final List<QuerySnapshot> snapshots = await Future.wait([
      FirebaseFirestore.instance.collection('se_assignment').get(),
      FirebaseFirestore.instance.collection('cs_assignment').get(),
    ]);

    for (var snapshot in snapshots) {
      for (var doc in snapshot.docs) {
        loadedAssignments.add(doc.data() as Map<String, dynamic>);
      }
    }

    setState(() {
      assignments = loadedAssignments;
      isLoading = false;
    });
    } catch (error) {
      print("Error fetching assignments: $error");
      setState(() {
      isLoading = false;
    });
    }
  }

  Future<void> uploadFile(String assignmentId) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'txt'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Upload to Firebase Storage
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('assignments/$userId/$fileName');
        UploadTask uploadTask = storageRef.putFile(file);

        TaskSnapshot snapshot = await uploadTask;
        String downloadURL = await snapshot.ref.getDownloadURL();

        // Save file URL to Firestore
        await FirebaseFirestore.instance.collection('uploads').add({
          'userId': userId,
          'assignmentId': assignmentId,
          'fileName': fileName,
          'fileURL': downloadURL,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File uploaded successfully!")),
        );
      }
    } catch (e) {
      print("Error uploading file: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 150,
                height: double.infinity,
                color: Colors.blueAccent.shade700,
              )),
          Positioned(
              right: 0,
              top: 0,
              //bottom: 0,
              child: Container(
                width: 1386,
                height: 70,
                color: Colors.lightBlueAccent.shade100,
              )),
          Positioned(
              right: 0,
              bottom: 0,
              //bottom: 0,
              child: Container(
                width: 1387,
                height: 150,
                color: Colors.blueAccent.shade700,
              )),
          Positioned(
              right: 0,
              top: 69,
              bottom: 150,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.lightBlueAccent.shade100,
              )),
          Positioned(
              top: 50,
              left: 50,
              right: 50,
              bottom: 50,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white60,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: StudentDrawer(),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.lightBlue.shade50,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(24),
                                bottomRight: Radius.circular(24))),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              child: StudentHeader(
                                name: "Assignment",
                              ),
                            ),
                            Positioned(
                              top: 130,
                              left: 50,
                              child: Container(
                                width: 1000,
                                height: 460,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(23)),
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    dataRowMinHeight: 2,
                                    dataRowMaxHeight: 70,
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                          'Course Name',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Assignment no.',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Question',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Submission',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Status',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Total Marks',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Obtained Marks',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                    rows: assignments.map((assignment) {
                                      return DataRow(cells: [
                                        DataCell(
                                          Center(
                                            child: Text(assignment['courseName'] ?? '--',
                                                style: const TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                        DataCell(
                                          Center(child: Text
                                            (assignment['assignment']?.toString() ?? '--',)
                                          ),
                                        ),
                                        DataCell(
                                          Text(assignment['question'] ?? '--',
                                              style: const TextStyle(color: Colors.red)),
                                        ),
                                        DataCell(
                                            Center(
                                              child: InkWell(onTap: () {
                                              // Handle file upload here
                                              uploadFile(assignment['id']);
                                              },
                                                child: const Text(
                                              'Upload',
                                              style: TextStyle(color: Colors.blueAccent),
                                                ),
                                              ),
                                            )),
                                        DataCell(
                                            Center(
                                              child: Text(assignment['status'] ?? 'Pending', style: TextStyle(
                                                color: assignment[
                                                'status'] == 'Missed'
                                                    ? Colors.red
                                                    : assignment[
                                                'status'] == 'Submitted'
                                                    ? Colors.green
                                                    : Colors.black),
                                                                                      ),
                                            )),
                                        DataCell(
                                          Center(child: Text(assignment['totalMarks']?.toString() ?? '--')),
                                        ),
                                        DataCell(
                                            Center(
                                              child: Text(
                                              assignment['obtainedMarks']?.toString() ?? '--'),
                                            )),
                                      ]);
                                    }).toList(),
                                    // rows: [
                                    //   DataRow(
                                    //     cells: [
                                    //       DataCell(InkWell(
                                    //           onTap: () {
                                    //             // Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCourseFolder()));
                                    //           },
                                    //           child: const Text(
                                    //             'Visual Programming',
                                    //             style: TextStyle(
                                    //                 color: Colors.blueAccent,
                                    //                 fontWeight:
                                    //                     FontWeight.bold),
                                    //           ))),
                                    //       const DataCell(Text('01-Jan-2024')),
                                    //       const DataCell(Text('10-Jan-2024',
                                    //           style: TextStyle(
                                    //               color: Colors.red))),
                                    //       DataCell(InkWell(
                                    //           onTap: () {
                                    //             "Uploaded";
                                    //           },
                                    //           child: const Text('Upload',
                                    //               style: TextStyle(
                                    //                   color:
                                    //                       Colors.blueAccent)))),
                                    //       const DataCell(Text('Pending')),
                                    //       const DataCell(Text('--')),
                                    //     ],
                                    //   ),
                                    //   DataRow(
                                    //     cells: [
                                    //       DataCell(InkWell(
                                    //           onTap: () {
                                    //             // Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCourseFolder()));
                                    //           },
                                    //           child: const Text(
                                    //             'PF',
                                    //             style: TextStyle(
                                    //                 color: Colors.blueAccent,
                                    //                 fontWeight:
                                    //                     FontWeight.bold),
                                    //           ))),
                                    //       const DataCell(Text('08-Jan-2024')),
                                    //       const DataCell(Text('10-Jan-2024',
                                    //           style: TextStyle(
                                    //               color: Colors.red))),
                                    //       DataCell(InkWell(
                                    //           onTap: () {
                                    //             "Uploaded";
                                    //           },
                                    //           child: const Text('Upload',
                                    //               style: TextStyle(
                                    //                   color:
                                    //                       Colors.blueAccent)))),
                                    //       const DataCell(Text('Pending')),
                                    //       const DataCell(Text('--')),
                                    //     ],
                                    //   ),
                                    //   DataRow(
                                    //     cells: [
                                    //       DataCell(InkWell(
                                    //           onTap: () {
                                    //             // Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCourseFolder()));
                                    //           },
                                    //           child: const Text(
                                    //             'Software Construction',
                                    //             style: TextStyle(
                                    //                 color: Colors.blueAccent,
                                    //                 fontWeight:
                                    //                     FontWeight.bold),
                                    //           ))),
                                    //       const DataCell(Text('25-Dec-2023')),
                                    //       const DataCell(Text('01-Jan-2024')),
                                    //       const DataCell(Text('Not Upload')),
                                    //       const DataCell(Text(
                                    //         'Missed',
                                    //         style: TextStyle(color: Colors.red),
                                    //       )),
                                    //       const DataCell(Text('00')),
                                    //     ],
                                    //   ),
                                    //   DataRow(
                                    //     cells: [
                                    //       DataCell(InkWell(
                                    //           onTap: () {
                                    //             // Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCourseFolder()));
                                    //           },
                                    //           child: const Text(
                                    //             'Introduction to Simulation and Modeling',
                                    //             style: TextStyle(
                                    //                 color: Colors.blueAccent,
                                    //                 fontWeight:
                                    //                     FontWeight.bold),
                                    //           ))),
                                    //       const DataCell(Text('20-Dec-2023')),
                                    //       const DataCell(Text('29-Dec-2023')),
                                    //       const DataCell(Text('Uploaded')),
                                    //       const DataCell(Text(
                                    //         'Submited',
                                    //         style:
                                    //             TextStyle(color: Colors.green),
                                    //       )),
                                    //       const DataCell(Text('07')),
                                    //     ],
                                    //   ),
                                    //   DataRow(
                                    //     cells: [
                                    //       DataCell(InkWell(
                                    //           onTap: () {
                                    //             // Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCourseFolder()));
                                    //           },
                                    //           child: const Text(
                                    //             'Modern Programming Languages',
                                    //             style: TextStyle(
                                    //                 color: Colors.blueAccent,
                                    //                 fontWeight:
                                    //                     FontWeight.bold),
                                    //           ))),
                                    //       const DataCell(Text('01-Jan-2024')),
                                    //       const DataCell(Text('05-Jan-2024',
                                    //           style: TextStyle(
                                    //               color: Colors.red))),
                                    //       DataCell(InkWell(
                                    //           onTap: () {
                                    //             "Uploaded";
                                    //           },
                                    //           child: const Text('Upload',
                                    //               style: TextStyle(
                                    //                   color:
                                    //                       Colors.blueAccent)))),
                                    //       const DataCell(Text('Pending')),
                                    //       const DataCell(Text('--')),
                                    //     ],
                                    //   ),
                                    //   DataRow(
                                    //     cells: [
                                    //       DataCell(InkWell(
                                    //           onTap: () {
                                    //             // Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCourseFolder()));
                                    //           },
                                    //           child: const Text(
                                    //             'Requirement Engineering',
                                    //             style: TextStyle(
                                    //                 color: Colors.blueAccent,
                                    //                 fontWeight:
                                    //                     FontWeight.bold),
                                    //           ))),
                                    //       const DataCell(Text('05-Jan-2024')),
                                    //       const DataCell(Text('10-Jan-2024',
                                    //           style: TextStyle(
                                    //               color: Colors.red))),
                                    //       DataCell(InkWell(
                                    //           onTap: () {
                                    //             "Uploaded";
                                    //           },
                                    //           child: const Text('Upload',
                                    //               style: TextStyle(
                                    //                   color:
                                    //                       Colors.blueAccent)))),
                                    //       const DataCell(Text('Pending')),
                                    //       const DataCell(Text('--')),
                                    //     ],
                                    //   ),
                                    // ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
              ),
        ],
      ),
    ));
  }
}
