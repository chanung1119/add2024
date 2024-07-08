import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 3D Controller',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('3D Viewer'),
        ),
        body: const MyHomePage(),
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Flutter3DController controller = Flutter3DController();
  double x_offset = 0.0;

  @override
  void initState() {
    super.initState();
    //3d 모델 자동 회전 기능
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      controller.resetCameraTarget();
      controller.setCameraOrbit(x_offset, 70, 100);
      x_offset += 0.4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, -0.7),
      child: Container(
          width: MediaQuery.of(context).size.width/1.5,
          height: MediaQuery.of(context).size.width/1.5,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(7, 7),
            ),]
          ),
          child: Flutter3DViewer(
            progressBarColor: Colors.transparent,
            controller: controller,
            src: 'assets/molecule.glb',
          ),
        ),
    );
  }

}