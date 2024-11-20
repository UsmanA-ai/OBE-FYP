import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components.dart';
import 'cs_mark_attendance.dart';
import 'cs_plos_page.dart';

class FacultyCSAttendanceFolder extends StatelessWidget {
  final String program;
  const FacultyCSAttendanceFolder({Key? key, required this.program})
      : super(key: key);

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
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 1386,
                height: 70,
                color: Colors.lightBlueAccent.shade100,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 1387,
                height: 150,
                color: Colors.blueAccent.shade700,
              ),
            ),
            Positioned(
              right: 0,
              top: 69,
              bottom: 150,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.lightBlueAccent.shade100,
              ),
            ),
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
                      child: FacultyDrawer(),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade50,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                        child: Stack(
                          children: [
                            const Positioned(
                              top: 0,
                              child: FacultyHeader(
                                  name: "Attendance Course Folder"),
                            ),
                            Positioned(
                              top: 100,
                              left: 50,
                              child: Container(
                                width: 1000,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "BS Computer Science",
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 23),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CSplos()));
                                          },
                                          child: const Text(
                                            "View Program Learning Outcomes >>",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 23),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                top: 180,
                                // bottom: 20,
                                left: 50,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Container(
                                    width: 1000,
                                    height: 450,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15))),
                                    child: FacultyCourseData(program: program),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacultyCourseData extends StatefulWidget {
  final String program;
  const FacultyCourseData({Key? key, required this.program}) : super(key: key);

  @override
  _FacultyCourseDataState createState() => _FacultyCourseDataState();
}

class _FacultyCourseDataState extends State<FacultyCourseData> {
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
          return _buildErrorWidget(snapshot.error.toString());
        } else {
          List<Map<String, dynamic>> courses = snapshot.data!;
          if (courses.isEmpty) {
            return _buildErrorWidget("No data found.");
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Success"),
                    content: const Text("Data fetched successfully."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  );
                },
              );
            });
            return _buildDataTable(courses);
          }
        }
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Text('Error: $message'),
    );
  }

  Widget _buildDataTable(List<Map<String, dynamic>> courses) {
    return Container(
      width: 1000,
      height: 450,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(23)),
      child: DataTable(
        columns: [
          DataColumn(
              label: Text(
            'Course Name',
            style: TextStyle(color: Colors.blueAccent[100], fontSize: 23),
          )),
          DataColumn(
              label: Text(
            'Course Code',
            style: TextStyle(color: Colors.blueAccent[100], fontSize: 23),
          )),
          DataColumn(
              label: Text(
            'Credit Hours',
            style: TextStyle(color: Colors.blueAccent[100], fontSize: 23),
          )),
          DataColumn(
              label: Text(
            'Actions',
            style: TextStyle(color: Colors.blueAccent[100], fontSize: 23),
          )),
        ],
        rows: courses.map<DataRow>((course) {
          return DataRow(cells: [
            DataCell(Text(course['Coursename'] ?? '')),
            DataCell(Text(course['Coursecode'] ?? '')),
            DataCell(Text(course['Credithours'] ?? '')),
            DataCell(
              PopupMenuButton<String>(
                itemBuilder: (BuildContext context) {
                  return {'Mark'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                onSelected: (String choice) {
                  if (choice == 'Mark') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CSMarkAttendance(
                          courseName: course['Coursename'],
                          facultyName: course['Facultyname'],
                          program: course['Program'],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchCourses() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('faculty')
          .doc(user!.uid)
          .get();

      String facultyId = snapshot.get('Id');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('course')
              .where('Facultyid', isEqualTo: facultyId)
              .where('Program', isEqualTo: widget.program)
              .get();

      List<Map<String, dynamic>> courses = querySnapshot.docs
          .map((doc) => {
                'Coursename': doc['Coursename'],
                'Coursecode': doc['Coursecode'],
                'Credithours': doc['Credithours'],
                'Facultyname': doc['Facultyname'],
                'Program': doc['Program']
              })
          .toList();

      // Remove duplicates based on 'Coursename', 'Coursecode', and 'Credithours'
      List<Map<String, dynamic>> uniqueCourses = [];
      for (var course in courses) {
        bool isDuplicate = uniqueCourses.any((uniqueCourse) =>
            uniqueCourse['Coursename'] == course['Coursename'] &&
            uniqueCourse['Coursecode'] == course['Coursecode'] &&
            uniqueCourse['Credithours'] == course['Credithours']);
        if (!isDuplicate) {
          uniqueCourses.add(course);
        }
      }

      return uniqueCourses;
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }
}
