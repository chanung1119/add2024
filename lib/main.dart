import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'dart:async';
import 'package:serious_python/serious_python.dart';
import 'package:http/http.dart' as http;

void main() {
  startPython();
  runApp(const MyApp());
}

void startPython() async {//start 'main.py'
  SeriousPython.run("app/app.zip");
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
          title: const Text('3D Viewer'),
        ),
        body: const VeiwMolecule(),
          ),
    );
  }
}

class VeiwMolecule extends StatefulWidget {
  const VeiwMolecule({super.key});

  @override
  State<VeiwMolecule> createState() => _VeiwMoleculeState();
}

class _VeiwMoleculeState extends State<VeiwMolecule> {
  late Flutter3DController _controller;
  double xOffset = 0.0;
  String? _result;

  @override
  void initState() {
    super.initState();
    _controller = Flutter3DController();
    getServiceResult();
    Timer.periodic(const Duration(milliseconds: 10), (timer) {//automatically rotate 3d model
      _controller.resetCameraTarget();
      _controller.setCameraOrbit(xOffset, 70, 100);
      xOffset += 0.4;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getServiceResult() async {
    while(true) {
      try {
        var response = await http.get(Uri.parse("http://127.0.0.1:8080"));
        setState(() {
          _result = response.body;
        });
        return;
      }
      catch (_) {
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    Widget? result;
    if(_result != null) {
      result = Flutter3DViewer(
        progressBarColor: Colors.transparent,
        controller: _controller,
        // src: 'http://127.0.0.1:8080/molecule.glb', //이거는 안됨
        src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb', //이거는 됨
      );
    }
    else {
      result = const CircularProgressIndicator();
    }

    return Align(
      alignment: const Alignment(0, -0.7),
      child: Container(
          width: MediaQuery.of(context).size.width/1.2,
          height: MediaQuery.of(context).size.width/1.2,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(7, 7),
            ),]
          ),
          child: result
        ),
    );
  }
}

// Flutter3DViewer(
// progressBarColor: Colors.transparent,
// controller: _controller,
// src: 'assets/h2o _molecule.glb',
// ),