


import 'package:flutter/material.dart';
import 'package:hivep/db/model/data_model.dart';
import 'package:hivep/widget/add_student_widget.dart';
import 'package:hivep/widget/list_student_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main()async{
  
await Hive.initFlutter();
if(!Hive.isAdapterRegistered(StudentModelAdapter().typeId))
{
  Hive.registerAdapter(StudentModelAdapter());
}

runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: ListStudent(),
     
     );


    
  }
}