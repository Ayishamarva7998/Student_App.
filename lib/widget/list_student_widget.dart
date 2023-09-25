import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hivep/db/functions/db_functions.dart';
import 'package:hivep/db/model/data_model.dart';
import 'package:hivep/widget/add_student_widget.dart';
import 'package:hivep/widget/edit.dart';

class ListStudent extends StatefulWidget {
  const ListStudent({Key? key}) : super(key: key);

  @override
  _ListStudentState createState() => _ListStudentState();
}

class _ListStudentState extends State<ListStudent> {
  TextEditingController searchController = TextEditingController();
  List<StudentModel> studentList = [];
  List<StudentModel> filteredStudentList = [];

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialize your studentList here, e.g., calling getAllStud()
    getAllStudents();
  }

  void filterStudents(String search) {
    if (search.isEmpty) {
      // If the search query is empty, show all students.
      setState(() {
        filteredStudentList = List.from(studentList);
      });
    } else {
      setState(() {
        filteredStudentList = studentList
            .where((student) =>
                student.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
      });
    }
  }

  // Function to sort the studentList
  void sortStudents() {
    setState(() {
      studentList.sort((a, b) => a.name.compareTo(b.name));
      // After sorting, set filteredStudentList to the sorted list.
      filteredStudentList = List.from(studentList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: isSearching ? buildSearchField() : Text("Student List"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    // Clear the search query and show all students.
                    searchController.clear();
                    filteredStudentList = List.from(studentList);
                  }
                });
              },
              icon: Icon(isSearching ? Icons.cancel : Icons.search),
            ),
            IconButton(
              onPressed: () {
                // Sort students when the sort icon is clicked
                sortStudents();
              },
              icon: Icon(Icons.sort),
            ),
          ],
        ),
        body: Center(
          child: isSearching
              ? filteredStudentList.isNotEmpty
                  ? ListView.separated(
                      itemBuilder: (ctx, index) {
                        final data = filteredStudentList[index];
                        return buildStudentCard(data, index);
                      },
                      separatorBuilder: (ctx, index) {
                        return const Divider();
                      },
                      itemCount: filteredStudentList.length,
                    )
                  : Center(
                      child: Text("No results found."),
                    )
              : buildStudentList(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddStudentWidget(),
              ),
            );
          },
          icon: Icon(Icons.add),
          label: Text("Add Student"),
        ),
        backgroundColor: const Color.fromARGB(255, 148, 148, 148),
      ),
    );
  }

  Widget buildSearchField() {
    return TextField(
      controller: searchController,
      onChanged: (query) {
        filterStudents(query);
      },
      autofocus: true,
      style: TextStyle(
        color: Colors.white, // Set the text color to white
      ),
      decoration: InputDecoration(
        hintText: "Search students...",
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.7), // Set the hint text color
        ),
        border: InputBorder.none,
      ),
    );
  }

  Widget buildStudentCard(StudentModel data, int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          backgroundImage: FileImage(File(data.image)),
        ),
        title: Text(
          data.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          data.age,
        ),
        trailing: SingleChildScrollView(
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditScreen(
                        index: index,
                        name: data.name,
                        age: data.age,
                        clas: data.clas,
                        
                        number: data.number,
                        image: data.image,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.edit),
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              IconButton(
                onPressed: () {
                  deleteStudent(index);
                },
                icon: Icon(Icons.delete_rounded),
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStudentList() {
    return ValueListenableBuilder(
      valueListenable: studentListNotifier,
      builder: (BuildContext ctx, List<StudentModel> studentlist, Widget? child) {
        // Update the studentList and filteredStudentList when data changes.
        studentList = studentlist;
        filteredStudentList = List.from(studentList);

        return ListView.separated(
          itemBuilder: (ctx, index) {
            final data = studentList[index];
            return buildStudentCard(data, index);
          },
          separatorBuilder: (ctx, index) {
            return const Divider();
          },
          itemCount: studentList.length,
        );
      },
    );
  }
}