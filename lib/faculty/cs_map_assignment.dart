import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../components.dart';

class CSMapObeAssignment extends StatefulWidget {
  final String courseName;
  const CSMapObeAssignment({super.key, required this.courseName});

  @override
  _CSMapObeAssignmentState createState() => _CSMapObeAssignmentState();
}

class _CSMapObeAssignmentState extends State<CSMapObeAssignment> {
  final TextEditingController assignmenttextcontroller =
      TextEditingController();
  final TextEditingController questionTextController = TextEditingController();
  final TextEditingController marksTextController = TextEditingController();
  // String? selectedCLO = "Select";
  String? selectedComplexity = "Select";
  // List<String> cloList = ["Select"];
  List<Map<String, dynamic>> assignmentList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCLOsAndAssignments();
  }

  Future<void> fetchCLOsAndAssignments() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch CLOs from Firestore
      final cloSnapshot = await FirebaseFirestore.instance
          .collection('cs_course_objectives')
          .where('courseName', isEqualTo: widget.courseName)
          .get();

      // final cloDocs = cloSnapshot.docs;
      // if (cloDocs.isNotEmpty) {
      //   cloList.addAll(cloDocs.map((doc) => doc['CLO'].toString()).toList());
      // }

      // Fetch existing assignments
      final assignmentSnapshot = await FirebaseFirestore.instance
          .collection('cs_assignment')
          .where('courseName', isEqualTo: widget.courseName)
          .get();

      setState(() {
        assignmentList =
            assignmentSnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      showAlert('Error', 'Failed to load data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addAssignment() async {
    if (assignmenttextcontroller.text.isEmpty ||
        questionTextController.text.isEmpty ||
        marksTextController.text.isEmpty ||
        // selectedCLO == null ||
        selectedComplexity == null ||
        // selectedCLO == "Select" ||
        selectedComplexity == "Select"
    ) {
      showAlert(
          'Error', 'All fields must be filled and dropdowns must be selected');
      return;
    }

    final assignmentData = {
      'courseName': widget.courseName,
      'assignment': assignmenttextcontroller.text,
      'question': questionTextController.text,
      // 'CLO': selectedCLO,
      'complexity': selectedComplexity,
      'totalMarks': marksTextController.text,
    };

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('cs_assignment')
          .add(assignmentData);
      showAlert('Success', 'Assignment added successfully');

      // Reset fields
      assignmenttextcontroller.clear();
      questionTextController.clear();
      marksTextController.clear();
      setState(() {
        // selectedCLO = "Select";
        selectedComplexity = "Select";
        assignmentList.add(assignmentData);
      });
    } catch (e) {
      showAlert('Error', 'Failed to add assignment: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteAssignment(String docId) async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('cs_assignment')
          .doc(docId)
          .delete();
      showAlert('Success', 'Assignment deleted successfully');
      setState(() {
        assignmentList.removeWhere((assignment) => assignment['id'] == docId);
      });
    } catch (e) {
      showAlert('Error', 'Failed to delete assignment: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void quickViewAssignment(Map<String, dynamic> assignment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick View'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('Course Name: ${assignment['courseName']}'),
              Text('Assignment: ${assignment['assignment']}'),
              Text('Question: ${assignment['question']}'),
              // Text('CLO: ${assignment['CLO']}'),
              Text('Complexity: ${assignment['complexity']}'),
              Text('Total Marks: ${assignment['totalMarks']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
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
                  //use expanded widget to divide the menus drawer and body content............
                  child: Row(
                    children: [
                      //this for drawer..........................
                      const Expanded(
                        child: FacultyDrawer(),
                      ),
                      //this for body...............................
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.lightBlue.shade50,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(24),
                                  bottomRight: Radius.circular(24))),
                          child: const Stack(
                            children: [
                              Positioned(
                                  top: 0,
                                  child: FacultyHeader(
                                      name: "CS Assignment")),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.235,
              top: 120,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.72,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.shade100,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Course Name',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              width: 250,
                              child: DropdownButton<String>(
                                value: widget.courseName,
                                icon: const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.arrow_drop_down),
                                ),
                                items: [
                                  DropdownMenuItem(
                                      value: widget.courseName,
                                      child: Text(widget.courseName)),
                                ],
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Assignment',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              width: 170,
                              child: TextFormField(
                                controller: assignmenttextcontroller,
                                keyboardType: TextInputType.number, // Restricts keyboard to numbers
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(
                                  hintText: 'Enter Assignment no',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Question',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  cursorColor: Colors.blue,
                                  maxLines: 1,
                                  controller: questionTextController,
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration(
                                    hintText: "Question",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.lightBlueAccent,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     const Text(
                        //       'Clo`s',
                        //       style: TextStyle(fontSize: 18),
                        //     ),
                        //     SizedBox(
                        //         width: 100,
                        //         child: DropdownButton<String>(
                        //           value: selectedCLO,
                        //           items: cloList.map((String value) {
                        //             return DropdownMenuItem<String>(
                        //               value: value,
                        //               child: Text(value),
                        //             );
                        //           }).toList(),
                        //           onChanged: (String? newValue) {
                        //             setState(() {
                        //               selectedCLO = newValue;
                        //             });
                        //           },
                        //         )),
                        //   ],
                        // ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Complexity',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              width: 260,
                              child: DropdownButton<String>(
                                value: selectedComplexity,
                                items: ['Select', 'Low', 'Medium', 'High']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedComplexity = newValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Marks',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              width: 170,
                              child: TextFormField(
                                controller: marksTextController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Marks',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 20,
                          ),
                          child: ElevatedButton.icon(
                            onPressed: addAssignment,
                            icon: const Icon(Icons.add),
                            // Icon you want to display
                            label: const Text('Add'),
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      0), // Custom border radius
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.235,
              top: 300,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.72,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.shade100,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent.shade100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: DataTable(
                        columnSpacing: 80,
                        dataRowMinHeight: 2,
                        dataRowMaxHeight: 50,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Course Name',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 23,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Assignment',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 23,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Question',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 23,
                              ),
                            ),
                          ),
                          // DataColumn(
                          //   label: Text(
                          //     'Clo`s',
                          //     style: TextStyle(
                          //       color: Colors.blue,
                          //       fontSize: 23,
                          //     ),
                          //   ),
                          // ),
                          DataColumn(
                            label: Text(
                              'Complexity',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 23,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Total Marks',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 23,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Actions',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 23,
                              ),
                            ),
                          ),
                        ],
                        rows: assignmentList.map((assignment) {
                          return DataRow(cells: [
                            DataCell(Text(assignment['courseName'] ?? '')),
                            DataCell(Text(assignment['assignment'] ?? '')),
                            DataCell(Text(assignment['question'] ?? '')),
                            // DataCell(Text(assignment['CLO'] ?? '')),
                            DataCell(Text(assignment['complexity'] ?? '')),
                            DataCell(Text(assignment['totalMarks'] ?? '')),
                            DataCell(
                              PopupMenuButton<String>(
                                itemBuilder: (BuildContext context) {
                                  return {'Delete', 'QuickView', 'View Assignment'}.map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                                onSelected: (String choice) {
                                  if (choice == 'Delete') {
                                    deleteAssignment(assignment['id']);
                                    // icon: const Icon(Icons.delete);
                                  } else if (choice == 'QuickView') {
                                    quickViewAssignment(assignment);
                                    // icon: const Icon(Icons.remove_red_eye);
                                  } else if (choice == 'View Assignment') {}
                                },
                              ),
                              // Row(
                              //   children: [
                              //     IconButton(
                              //       onPressed: () =>
                              //           deleteAssignment(assignment['id']),
                              //       icon: const Icon(Icons.delete),
                              //     ),
                              //     IconButton(
                              //       onPressed: () =>
                              //           quickViewAssignment(assignment),
                              //       icon: const Icon(Icons.remove_red_eye),
                              //     ),
                              //   ],
                              // ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
