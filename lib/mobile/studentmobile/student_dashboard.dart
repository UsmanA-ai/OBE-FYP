import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/mobile/HomePage.dart';
import 'package:myapp/mobile/studentmobile/attendance_page.dart';
import 'package:myapp/mobile/studentmobile/contact_us.dart';
import 'package:myapp/mobile/studentmobile/courses/course_page.dart';
import 'package:myapp/mobile/studentmobile/portfolio/portfolio_page.dart';
import 'package:myapp/mobile/studentmobile/profile.dart';

class MobileStudentDashboard extends StatefulWidget {
  const MobileStudentDashboard({super.key});

  @override
  State<MobileStudentDashboard> createState() => _MobileStudentDashboardState();
}

class _MobileStudentDashboardState extends State<MobileStudentDashboard> {
  late Future<Map<String, dynamic>> userDataFuture;
  late Future<List<Map<String, dynamic>>> coursesFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(user!.uid)
        .get();
    String studentId = snapshot['Id'];
    String program = snapshot['Program'];
    coursesFuture = fetchUserCourses(studentId);
    return snapshot.data() as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> fetchUserCourses(String studentId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('course')
        .where('Studentid', isEqualTo: studentId)
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DashBoard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/avator.png"),
                ),
                accountName: const Text(
                  "Name",
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: const Text(
                  "Email",
                  style: TextStyle(color: Colors.white),
                )),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.blue.shade900,
              ),
              title: Text(
                'Home',
                style: TextStyle(color: Colors.blue.shade900),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MobileStudentDashboard()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.checklist_outlined,
                color: Colors.blue.shade900,
              ),
              title: Text(
                'Attendance',
                style: TextStyle(color: Colors.blue.shade900),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const StudentMobileAttendancePage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.book,
                color: Colors.blue.shade900,
              ),
              title: Text(
                'Courses',
                style: TextStyle(color: Colors.blue.shade900),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentMobileCoursePage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.man,
                color: Colors.blue.shade900,
              ),
              title: Text(
                'Profile',
                style: TextStyle(color: Colors.blue.shade900),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const StudentMobileProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.create,
                color: Colors.blue.shade900,
              ),
              title: Text(
                'Portfolio',
                style: TextStyle(color: Colors.blue.shade900),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const StudentMobilePortfolioPage()));
              },
            ),
            ListTile(
              title: Text(
                'Help & Support',
                style: TextStyle(color: Colors.blue.shade900),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.help,
                color: Colors.blue.shade900,
              ),
              title: Text(
                'Help/Report',
                style: TextStyle(color: Colors.blue.shade900),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.contact_page_outlined,
                color: Colors.blue.shade900,
              ),
              title: Text(
                'Contact Us',
                style: TextStyle(color: Colors.blue.shade900),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MobileContact_us()),
                ); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.blue.shade900,
              ),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.blue.shade900),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MobileHomePage()));
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('loading...'));
          } else {
            var userData = snapshot.data!;
            String userName = userData['Name'];

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: coursesFuture,
              builder: (context, courseSnapshot) {
                if (courseSnapshot.hasError) {
                  return Center(child: Text('Error: ${courseSnapshot.error}'));
                } else if (!courseSnapshot.hasData ||
                    courseSnapshot.data!.isEmpty) {
                  return const Center(child: Text('loading....'));
                } else {
                  var courses = courseSnapshot.data!;
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.lightBlue.shade50,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: 1100,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.shade100,
                              borderRadius: BorderRadius.circular(23),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12, right: 180),
                                      child: Text(
                                        "Hello, $userName",
                                        style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 80),
                                      child: Text(
                                          "You have learned max your course"),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Text(
                                          "Keep it up and improve your grades to get scholarship"),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 190),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const StudentMobileCoursePage()));
                                        },
                                        child: const Text(
                                          "View Result",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 250,
                                ),
                                SizedBox(
                                  width: 400,
                                  height: 150,
                                  child:
                                      Image.asset("assets/images/student1.png"),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 500,
                          height: 380,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                width: 450,
                                height: 40,
                                child: Text(
                                  "Your Courses",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Display the list of courses
                              ...courses.take(4).map((course) {
                                String courseName = course['Coursename'];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Container(
                                    width: 450,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue.shade100,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Text(
                                              courseName[0],
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Tooltip(
                                            message: courseName,
                                            child: Text(
                                              courseName,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.blue),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        const Text("BSSE"),
                                        const SizedBox(width: 16),
                                        Container(
                                          margin: const EdgeInsets.all(4),
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              side: const BorderSide(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const StudentMobileCoursePage()));
                                            },
                                            child: const Text(
                                              "View",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const StudentMobileCoursePage()));
                                    },
                                    child: const Text(
                                      "View More",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const StudentMobileCoursePage()));
                                    },
                                    child: const Text(
                                      "Enroll Courses",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: 480,
                            height: 80,
                            decoration: BoxDecoration(
                                color: Colors.lightBlue.shade100,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Icon(
                                    Icons.text_snippet_outlined,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, right: 170),
                                      child: Text(
                                        "Complaint",
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Text("What`s to complaint against someone?")
                                  ],
                                ),
                                const SizedBox(
                                  width: 80,
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MobileContact_us()));
                                    },
                                    icon: const Icon(
                                      Icons.navigate_next,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
