import 'package:dawinadmin/models/static_values.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Medicine {
  String name;
  String description;
  String type;
  String imageUrl;

  Medicine({
    required this.name,
    required this.description,
    required this.type,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'imageUrl': imageUrl,
    };
  }
}

class AddMedicineForm extends StatefulWidget {
  const AddMedicineForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddMedicineFormState createState() => _AddMedicineFormState();
}

class _AddMedicineFormState extends State<AddMedicineForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _conflictMedicineController =
      TextEditingController();
  final List<String> _conflictMedicines = [];
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    String fileName =
        'medicines/${DateTime.now().millisecondsSinceEpoch.toString()}.png';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }

  void _addMedicine() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    String imageUrl = await _uploadImage(_imageFile!);

    Medicine medicine = Medicine(
      name: _nameController.text,
      description: _descriptionController.text,
      type: _selectedMedicineType!,
      imageUrl: imageUrl,
    );
    if (_selectedMedicineType != null) {
      FirebaseFirestore.instance.collection('Medicine').add({
        'medicine': medicine.toMap(),
        'conflictMedicines': _conflictMedicines,
      });
    }

    _nameController.clear();
    _descriptionController.clear();
    _typeController.clear();
    _conflictMedicines.clear();
    _conflictMedicineController.clear();
    setState(() {
      _imageFile = null;
    });
  }

  void _addConflictMedicine() {
    String conflictMedicine = _conflictMedicineController.text;
    if (conflictMedicine.isNotEmpty) {
      setState(() {
        _conflictMedicines.add(conflictMedicine);
      });
      _conflictMedicineController.clear();
    }
  }

  void _clearConflictMedicines() {
    setState(() {
      _conflictMedicines.clear();
    });
  }

  final List<String> medicinetype = [
    'Cardiology',
    'Neurology',
    'Dermatology',
    'Pediatrics',
    'Orthopedics',
    'Ophthalmology',
    'Gynecology',
    'Urology',
    'General Medicine',
    'Dentistry',
    'ENT',
    'Gastroenterology',
    'Nephrology',
    'Pulmonology',
    'Oncology',
    'Psychiatry',
    'Sports Medicine',
    'Infectious Diseases',
    'Physical Therapy'
  ];

  String? _selectedMedicineType; // سيتم تخزين القيمة المحددة هنا
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: accentColor2, // Deep Purple
        title: const Text(
          'Add Medicine',
          style: TextStyle(
            color: Colors.white, // Gold
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                  labelStyle: TextStyle(color: accentColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: accentColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: accentColor),
                  ),
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: accentColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: accentColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: accentColor),
                  ),
                ),
              ),
              DropdownButton<String>(
                value: _selectedMedicineType, // القيمة المحددة حاليًا
                hint: Text(
                  'Select Medicine Type',
                  style: TextStyle(color: accentColor),
                ), // نص افتراضي عند عدم الاختيار
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMedicineType = newValue; // تحديث القيمة المحددة
                  });
                },
                items:
                    medicinetype.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(), // تحويل القائمة إلى عناصر DropdownMenuItem
                underline: Container(
                  height: 2,
                  color: accentColor, // لون الخط السفلي
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: accentColor, // لون الأيقونة
                ),
                dropdownColor: Colors.white, // لون خلفية القائمة المنسدلة
                style: const TextStyle(color: Colors.black), // لون النص
              ),
              // TextField(
              //   controller: _typeController,
              //   decoration: InputDecoration(
              //     labelText: 'Type',
              //     labelStyle: TextStyle(color: accentColor),
              //     enabledBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(color: accentColor),
              //     ),
              //     focusedBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(color: accentColor),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 10),
              Text(
                'Conflict Medicines:',
                style:
                    TextStyle(color: accentColor, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _conflictMedicines.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _conflictMedicines[index],
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _conflictMedicineController,
                      decoration: const InputDecoration(
                        labelText: 'Add Conflict Medicine',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor2,
                    ),
                    onPressed: _addConflictMedicine,
                    child: const Text('Add'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor2,
                    ),
                    onPressed: _clearConflictMedicines,
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 150)
                  : const Placeholder(fallbackHeight: 150),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor2,
                ),
                onPressed: _pickImage,
                child: const Text('Pick Image',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor2,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _addMedicine,
                    child: const Text(
                      'Add Medicine',
                      style: TextStyle(
                        color: Colors.white, // Gold
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
