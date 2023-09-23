import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivep/db/model/data_model.dart';
import 'package:hivep/db/model/data_model.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

Future<void> addStudent(StudentModel value) async {
  final studentdb = await Hive.openBox<StudentModel>('student_db');
  await studentdb.add(value);
   getAllStudents();
}

Future<void> getAllStudents() async {
  final studentdb = await Hive.openBox<StudentModel>('student_db');
  studentListNotifier.value.clear();

  studentListNotifier.value.addAll(studentdb.values);
  studentListNotifier.notifyListeners();
}

Future<void> deleteStudent(int index) async {
  final studentdb = await Hive.openBox<StudentModel>('student_db');
  studentdb.deleteAt(index);
  getAllStudents();

}
void editstudent(index,StudentModel value) async {
  final studentdb = await Hive.openBox<StudentModel>('student_db');
  studentListNotifier.value.clear();
  studentListNotifier.value.addAll(studentdb.values);
  studentdb.putAt(index, value);
}
