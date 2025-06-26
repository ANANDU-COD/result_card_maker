import 'dart:typed_data';

class StudentModel {
  String examname;
  int year;
  String Studentname;
  String location;
  String batchId;
  int mobile;
  int mark;
  Uint8List? photo;

  StudentModel({
    this.examname='',
    this.year=0000,
    this.Studentname = '',
    this.location = '',
    this.batchId = '',
    this.mobile = 0,
    this.mark = 0,
    this.photo,
  });
}
