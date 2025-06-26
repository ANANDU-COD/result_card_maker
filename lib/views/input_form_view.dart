import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../controllers/result_controller.dart';
import '../widgets/result_card_widget.dart';

class InputFormView extends StatefulWidget {
  @override
  _InputFormViewState createState() => _InputFormViewState();
}

class _InputFormViewState extends State<InputFormView> {
  final ResultController controller = Get.put(ResultController());

  final examNameController = TextEditingController();
  final examYearController = TextEditingController();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final batchController = TextEditingController();
  final mobileController = TextEditingController();
  final markController = TextEditingController();

  final RxString selectedExamName = ''.obs;
  final RxBool isPhotoUploaded = false.obs;
  String? selectedState;
  String? selectedDistrict;

  final Map<String, List<String>> stateDistrictMap = {
    'Kerala': ['Kasaragod', 'Kannur','Wayanad', 'Kozhikode', 'Malappuram', 'Palakkad', 'Thrissur', 'Ernakulam', 'Idukki', 'Kottayam', 'Alappuzha', 'Pathanamthitta', 'Kollam','Thiruvananthapuram'],
    'Tamil Nadu': [ 'Ariyalur', 'Chengalpattu', 'Chennai', 'Coimbatore', 'Cuddalore', 'Dharmapuri', 'Dindigul', 'Erode', 'Kallakurichi', 'Kanchipuram', 'Kanyakumari', 'Karur', 'Krishnagiri', 'Madurai', 'Nagapattinam', 'Namakkal', 'Nilgiris', 'Perambalur', 'Pudukkottai', 'Ramanathapuram', 'Ranipet', 'Salem', 'Sivaganga', 'Tenkasi', 'Thanjavur', 'Thenkasi', 'Tiruchirappalli', 'Tirunelveli', 'Tirupathur', 'Tiruppur', 'Tiruvallur', 'Tiruvarur', 'Tiruvannamalai', 'Thoothukudi',' Vellore', 'Viluppuram', 'Virudhunagar'],
    'Karnataka': ['Bagalkote', 'Ballari', 'Belagavi', 'Bengaluru Rural', 'Bengaluru Urban','Bidar', 'Chamarajanagar', 'Chikkaballapur', 'Chikkamagaluru', 'Chitradurga', 'Dakshina Kannada', 'Davanagere', 'Dharwad', 'Gadag', 'Hassan', 'Haveri', 'Kalaburagi', 'Kodagu', 'Kolar', 'Koppal', 'Mandya', 'Mysuru', 'Raichur', 'Ramanagara', 'Shivamogga', 'Tumakuru', 'Udupi','Uttara Kannada',' Vijayapura', 'Yadgir','Vijayanagara'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  'assets/images/logo2.png',
                  width: 300.0,
                ),
              ),
            ),
            Text("Enter your details", textAlign: TextAlign.center),
            SizedBox(height: 8),
            Obx(() => DropdownButtonFormField<String>(
              value: selectedExamName.value.isEmpty ? null : selectedExamName.value,
              items: [
                'CA FOUNDATION',
                'CA INTER GROUP 1',
                'CA INTER GROUP 2',
                'CA INTERMEDIATE QUALIFIED',
              ].map((exam) {
                return DropdownMenuItem<String>(
                  value: exam,
                  child: Text(exam),
                );
              }).toList(),
              onChanged: (value) {
                selectedExamName.value = value!;
                examNameController.text = value;
              },
              decoration: InputDecoration(
                labelText: 'Exam Name',
                border: OutlineInputBorder(),
              ),
            )),
            SizedBox(height: 8),
            TextField(
              controller: examYearController,
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  helpText: 'Select Exam Year',
                );
                if (picked != null) {
                  examYearController.text = picked.year.toString();
                }
              },
              decoration: InputDecoration(
                labelText: 'Exam Year',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedState,
              items: stateDistrictMap.keys.map((state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value;
                  selectedDistrict = null;
                });
              },
              decoration: InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              items: selectedState == null ? [] : stateDistrictMap[selectedState!]!.map((district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  locationController.text = value ?? '';
                });
              },
              decoration: InputDecoration(
                labelText: 'District',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: batchController,
              decoration: InputDecoration(
                labelText: 'Reg. No',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: mobileController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 8),
            TextField(
              controller: markController,
              decoration: InputDecoration(
                labelText: 'Mark (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            Obx(() => GradientIconButton(
              icon: Icons.image,
              label: isPhotoUploaded.value ? 'Photo Uploaded' : 'Add Your Photo',
              onPressed: () async {
                Uint8List? photo = await ImagePickerWeb.getImageAsBytes();
                if (photo != null) {
                  controller.student.value.photo = photo;
                  controller.student.refresh();
                  isPhotoUploaded.value = true;
                } else {
                  isPhotoUploaded.value = false;
                }
              },
            )),
            SizedBox(height: 20),
            ButtonFive(
              onPressed: () async {
                if (!validateInputs()) return;

                controller.student.value.Studentname = nameController.text;
                controller.student.value.location = locationController.text;
                controller.student.value.batchId = batchController.text;
                controller.student.value.mobile =
                    int.tryParse(mobileController.text) ?? 0;
                controller.student.value.mark =
                    int.tryParse(markController.text) ?? 0;
                controller.student.refresh();

                await sendToTelegram(
                  token: '8064963792:AAE-h8_zAg1FJh3A0xx93-BDHxZrV9A4UOw',
                  chatId: '-1002779580613',
                  message: '''
🎓 <b>New Result Submission</b>
 Name: ${nameController.text}
 District: ${locationController.text}
 Exam: ${examNameController.text} ${examYearController.text}
 Reg. No: ${batchController.text}
 Mobile: ${mobileController.text}
 Mark: ${markController.text}%
''',
                );

                await submitToGoogleSheet();

                Get.to(() => Scaffold(
                  appBar: AppBar(title: Text("Result Card")),
                  body: Center(
                    child: ResultCardWidget(
                      name: controller.student.value.Studentname,
                      location: controller.student.value.location,
                      mark: controller.student.value.mark,
                      image: controller.student.value.photo != null
                          ? MemoryImage(controller.student.value.photo!)
                          : AssetImage('assets/images/default_avatar.png')
                      as ImageProvider,
                      examName: examNameController.text,
                      examYear: examYearController.text,
                    ),
                  ),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
  bool validateInputs() {
    if (examNameController.text.isEmpty ||
        examYearController.text.isEmpty ||
        nameController.text.isEmpty ||
        locationController.text.isEmpty ||
        batchController.text.isEmpty ||
        mobileController.text.isEmpty ||
        markController.text.isEmpty) {
      Get.snackbar("Missing Fields", "Please fill in all the fields",
          backgroundColor: Colors.white, colorText: Colors.red);
      return false;
    }

    if (!RegExp(r'^\d{4}$').hasMatch(examYearController.text)) {
      Get.snackbar("Invalid Exam Year", "Enter a valid 4-digit year",
          backgroundColor: Colors.white, colorText: Colors.red);
      return false;
    }

    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(nameController.text)) {
      Get.snackbar("Invalid Name", "Name should contain only alphabets",
          backgroundColor: Colors.white, colorText: Colors.red);
      return false;
    }

    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(locationController.text)) {
      Get.snackbar("Invalid Location", "Location should contain only alphabets",
          backgroundColor: Colors.white, colorText: Colors.red);
      return false;
    }

    // ✅ Reg. No: must be like NRO0123456 (3 capital letters + 7 digits)
    if (!RegExp(r'^[A-Z]{3}[0-9]{7}$').hasMatch(batchController.text)) {
      Get.snackbar("Invalid Reg. No", "Reg. No must be like NRO0123456",
          backgroundColor: Colors.white, colorText: Colors.red);
      return false;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(mobileController.text)) {
      Get.snackbar("Invalid Mobile", "Mobile number must be 10 digits",
          backgroundColor: Colors.white, colorText: Colors.red);
      return false;
    }

    // ✅ Mark must be between 0 and 100
    final int? mark = int.tryParse(markController.text);
    if (mark == null || mark < 0 || mark > 100) {
      Get.snackbar("Invalid Mark", "Mark must be between 0% and 100%",
          backgroundColor: Colors.white, colorText: Colors.red);
      return false;
    }

    return true;
  }


  Future<void> sendToTelegram({
    required String token,
    required String chatId,
    required String message,
  }) async {
    final url = 'https://api.telegram.org/bot$token/sendMessage';
    try {
      await http.post(
        Uri.parse(url),
        body: {
          'chat_id': chatId,
          'text': message,
          'parse_mode': 'HTML',
        },
      );
    } catch (e) {
      print("Telegram error: $e");
    }
  }

  Future<void> submitToGoogleSheet() async {
    final url = Uri.parse('https://script.google.com/macros/s/AKfycbzP3eu1zzDMgnqNuINJ2ETJMixBSJ7rYfcKeu1_8Qn8qDbCuR1oVmIzM49RX-uf_Pu1qw/exec');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'examName': examNameController.text,
          'examYear': examYearController.text,
          'name': nameController.text,
          'location': locationController.text,
          'regNo': batchController.text,
          'mobile': mobileController.text,
          'mark': markController.text,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Data sent to Google Sheet');
      } else {
        print('❌ Failed to send data: \${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error submitting to Google Sheet: $e');
    }
  }
}

class ButtonFive extends StatelessWidget {
  final VoidCallback onPressed;

  const ButtonFive({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: onPressed,
        child: const Text(
          'Generate Result Card',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class GradientIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const GradientIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent],
        ),
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
