import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'course_folder.dart';
class StudentMobileCoursePage extends StatelessWidget {
  const StudentMobileCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text("Courses", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue.shade900,
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.lightBlue.shade50,
          child: const StudentCourseData(),
        ),
      ),
    );
  }
}

class StudentCourseData extends StatefulWidget {
  const StudentCourseData({super.key});

  @override
  _StudentCourseDataState createState() => _StudentCourseDataState();
}

class _StudentCourseDataState extends State<StudentCourseData> {
  late Future<List<Map<String, dynamic>>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _coursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> courses = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Course Name', style: TextStyle(color: Colors.blueAccent[100], fontSize: 23))),
                  DataColumn(label: Text('Course Code', style: TextStyle(color: Colors.blueAccent[100], fontSize: 23))),
                  DataColumn(label: Text('Credit Hours', style: TextStyle(color: Colors.blueAccent[100], fontSize: 23))),
                  DataColumn(label: Text('Faculty Name', style: TextStyle(color: Colors.blueAccent[100], fontSize: 23))),
                  DataColumn(label: Text('Actions', style: TextStyle(color: Colors.blueAccent[100], fontSize: 23))),
                ],
                rows: courses.map<DataRow>((course) {
                  return DataRow(cells: [
                    DataCell(Text(course['Coursename'] ?? '')),
                    DataCell(Text(course['Coursecode'] ?? '')),
                    DataCell(Text(course['Credithours'] ?? '')),
                    DataCell(Text(course['Facultyname'] ?? '')),
                    DataCell(
                      PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) {
                          return {'Show'}.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                        onSelected: (String choice) {
                          if (choice == 'Show') {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentMobileCourseFolder(courseName: course['Coursename'],)));
                          }
                        },
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchCourses() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(user!.uid)
          .get();

      String studentId = snapshot.get('Id');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('course')
          .where('Studentid', isEqualTo: studentId)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList().cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }
}


