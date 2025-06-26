import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/result_controller.dart';

class ResultCardView extends StatelessWidget {
  final ResultController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final student = controller.student.value;

    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(title: Text('Result Card')),
      body: Center(
        child: Container(
          width: 600,
          height: 850,
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/bg.jpeg', // replace with your background
                  fit: BoxFit.cover,
                ),
              ),

              // Photo
              if (student.photo != null)
                Positioned(
                  top: 120,
                  left: 30,
                  child: ClipOval(
                    child: Image.memory(
                      student.photo! as Uint8List,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              // Text fields
              Positioned(
                top: 280,
                left: 30,
                right: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoText('Name: ${student.Studentname}'),
                    infoText('Location: ${student.location}'),
                    infoText('Batch ID: ${student.batchId}'),
                    infoText('Mobile: ${student.mobile}'),
                    infoText('Mark: ${student.mark}%'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
