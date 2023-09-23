import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hivep/db/functions/db_functions.dart';
import 'package:hivep/db/model/data_model.dart';
import 'package:hivep/widget/add_student_widget.dart';
import 'package:hivep/widget/edit.dart';

class ListStudentWidget extends StatefulWidget {
  const ListStudentWidget({Key? key}) : super(key: key);

  @override
  State<ListStudentWidget> createState() => _ListStudentWidgetState();
}

class _ListStudentWidgetState extends State<ListStudentWidget> {
  
  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: studentListNotifier,
        builder:
            (BuildContext ctx, List<StudentModel> studentList, Widget? child) {
          return ListView.separated(
            itemBuilder: (ctx, index) {
              final data = studentList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.pink,
                  backgroundImage: FileImage(File(data.image)),
                ),
                title: Text(data.name ),
                subtitle: Text(data.age ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          deleteStudent(index);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: const Color.fromARGB(255, 158, 52, 45),

                        )
                        ),
                        IconButton(onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>EditScreen(name: data.name, 
                          age: data.age,
                           number: data.number, 
                           clas: data.clas,
                            image: data.image, 
                            index: index)));
                        }, icon: Icon(Icons.edit))
                  ],
                ),
                    
              );
            },
            separatorBuilder: (ctx, index) {
              return Divider();
            },
            itemCount: studentList.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddStudentWidget()));
      }),
    );
  }
}
