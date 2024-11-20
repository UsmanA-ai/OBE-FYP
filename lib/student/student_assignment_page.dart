import 'package:flutter/material.dart';
import 'package:myapp/components.dart';

class StudentAssignmentPage extends StatefulWidget {
  const StudentAssignmentPage({Key? key}) : super(key: key);
  @override
  State<StudentAssignmentPage> createState() => _StudentAssignmentPageState();
}

class _StudentAssignmentPageState extends State<StudentAssignmentPage> {
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
                                          'Start-Date',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Due-Date',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Submit',
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
                                          'Marks',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                    rows: [
                                      DataRow(
                                        cells: [
                                          DataCell(InkWell(
                                              onTap: () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCourseFolder()));
                                              },
                                              child: const Text(
                                                'Visual Programming',
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                          const DataCell(Text('01-Jan-2024')),
                                          const DataCell(Text('10-Jan-2024',
                                              style: TextStyle(
                                                  color: Colors.red))),
                                          DataCell(InkWell(
                                              onTap: () {
                                                "Uploaded";
                                              },
                                              child: const Text('Upload',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blueAccent)))),
                                          const DataCell(Text('Pending')),
                                          const DataCell(Text('--')),
                                        ],
                                      ),
                                      DataRow(
                                        cells: [
                                          DataCell(InkWell(
                                              onTap: () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCourseFolder()));
                                              },
                                              child: const Text(
                                                'PF',
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                          const DataCell(Text('08-Jan-2024')),
                                          const DataCell(Text('10-Jan-2024',
                                              style: TextStyle(
                                                  color: Colors.red))),
                                          DataCell(InkWell(
                                              onTap: () {
                                                "Uploaded";
                                              },
                                              child: const Text('Upload',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blueAccent)))),
                                          const DataCell(Text('Pending')),
                                          const DataCell(Text('--')),
                                        ],
                                      ),
                                      DataRow(
                                        cells: [
                                          DataCell(InkWell(
                                              onTap: () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCourseFolder()));
                                              },
                                              child: const Text(
                                                'Software Construction',
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                          const DataCell(Text('25-Dec-2023')),
                                          const DataCell(Text('01-Jan-2024')),
                                          const DataCell(Text('Not Upload')),
                                          const DataCell(Text(
                                            'Missed',
                                            style: TextStyle(color: Colors.red),
                                          )),
                                          const DataCell(Text('00')),
                                        ],
                                      ),
                                      DataRow(
                                        cells: [
                                          DataCell(InkWell(
                                              onTap: () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCourseFolder()));
                                              },
                                              child: const Text(
                                                'Introduction to Simulation and Modeling',
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                          const DataCell(Text('20-Dec-2023')),
                                          const DataCell(Text('29-Dec-2023')),
                                          const DataCell(Text('Uploaded')),
                                          const DataCell(Text(
                                            'Submited',
                                            style:
                                                TextStyle(color: Colors.green),
                                          )),
                                          const DataCell(Text('07')),
                                        ],
                                      ),
                                      DataRow(
                                        cells: [
                                          DataCell(InkWell(
                                              onTap: () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCourseFolder()));
                                              },
                                              child: const Text(
                                                'Modern Programming Languages',
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                          const DataCell(Text('01-Jan-2024')),
                                          const DataCell(Text('05-Jan-2024',
                                              style: TextStyle(
                                                  color: Colors.red))),
                                          DataCell(InkWell(
                                              onTap: () {
                                                "Uploaded";
                                              },
                                              child: const Text('Upload',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blueAccent)))),
                                          const DataCell(Text('Pending')),
                                          const DataCell(Text('--')),
                                        ],
                                      ),
                                      DataRow(
                                        cells: [
                                          DataCell(InkWell(
                                              onTap: () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCourseFolder()));
                                              },
                                              child: const Text(
                                                'Requirement Engineering',
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                          const DataCell(Text('05-Jan-2024')),
                                          const DataCell(Text('10-Jan-2024',
                                              style: TextStyle(
                                                  color: Colors.red))),
                                          DataCell(InkWell(
                                              onTap: () {
                                                "Uploaded";
                                              },
                                              child: const Text('Upload',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blueAccent)))),
                                          const DataCell(Text('Pending')),
                                          const DataCell(Text('--')),
                                        ],
                                      ),
                                    ],
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
              )),
        ],
      ),
    ));
  }
}
