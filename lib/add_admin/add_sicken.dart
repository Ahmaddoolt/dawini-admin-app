import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/sicken.dart';
import '../models/static_values.dart';
import '../models/sympols.dart';

class AdminAddSick extends StatefulWidget {
  const AdminAddSick({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminAddSickState createState() => _AdminAddSickState();
}

class _AdminAddSickState extends State<AdminAddSick> {
  final List<String> specializations = [
    'Physical diseases',
    'Mental illness',
    'Psychiatric illness',
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
    'Gum diseases',
    'Oral and maxillofacial surgery',
    'Ear, nose, and throat (ENT)',
    'Liver and gastrointestinal diseases',
    'Kidney diseases',
    'Respiratory diseases',
    'Internal medicine',
    'Sports medicine',
    'Infectious diseases',
    'Oncology',
    'Physical therapy',
    'Immunological diseases',
    'Child and adolescent psychiatry'
  ];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedType = '';
  XFile? _pickedImage;
  List<Symptom> symptoms = [];
  List<Causes> causes = [];
  List<Cure> cure = [];

  Future<String> _uploadImage(File imageFile, String imageName) async {
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('book_images')
        .child(imageName);
    await storageReference.putFile(imageFile);
    return await storageReference.getDownloadURL();
  }

  void addSick() async {
    final CollectionReference sicks =
        FirebaseFirestore.instance.collection('Sickens');

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedType == "" ||
        _pickedImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
            content: Text('Please fill in all the fields and pick an image.',
                style:
                    TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK',
                    style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
            ],
            backgroundColor: mainColor2,
          );
        },
      );
      return;
    }

    if (_pickedImage != null) {
      String imageUrl = await _uploadImage(File(_pickedImage!.path), imageName);

      Sick newSick = Sick(
        title: titleController.text,
        description: descriptionController.text,
        imageUrl: imageUrl,
        type: selectedType,
        symptoms: symptoms,
        causes: causes,
        cure: cure,
      );

      await sicks.add({
        'title': newSick.title,
        'description': newSick.description,
        'imageUrl': newSick.imageUrl,
        'type': newSick.type,
        'symptoms': newSick.symptoms
            .map((symptom) => {
                  'name': symptom.name,
                })
            .toList(),
        'causes': newSick.causes
            .map((causes) => {
                  'name': causes.name,
                })
            .toList(),
        'cure': newSick.cure
            .map((cure) => {
                  'name': cure.name,
                })
            .toList(),
      });

      titleController.clear();
      descriptionController.clear();
      setState(() {
        _pickedImage = null;
        selectedType = "";
        symptoms.clear();
        causes.clear();
        cure.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text(
          'Add Disease to Collection',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              onPressed: () async {
                XFile? pickedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    _pickedImage = pickedImage;
                  });
                }
              },
              child: const SizedBox(
                width: 300,
                child: Center(
                  child: Text(
                    'Pick Image',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
              ),
            ),
            Container(
              child: _pickedImage != null
                  ? Image.file(File(_pickedImage!.path))
                  : Image(
                      image: const AssetImage('assets/logg.jpg'),
                      width: 300,
                      height: height * 0.25,
                    ),
            ),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                hintStyle: const TextStyle(color: Colors.black),
              ),
            ),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: descriptionController,
              decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
          const SizedBox(height: 16,),
            DropdownButton<String>(
              value: selectedType.isEmpty ? null : selectedType,
              hint: Text(
                'Choose type',
                style: TextStyle(
                    color: accentColor, // You can customize the hint text color
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              items: specializations.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    color: mainColor2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          value,
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedType = newValue ?? '';
                });
              },
              underline: Container(
                height: 2,
                color: accentColor, // Customize the underline color
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: accentColor, // Customize the dropdown icon color
              ),
              isExpanded: true, // Makes the dropdown take full width
            ),
            const SizedBox(height: 20),
            // TextFormField to input causes
            AddCausesWidget(
              onAdd: (cause) {
                setState(() {
                  causes.add(cause);
                });
              },
            ),
            const SizedBox(height: 16),
            // Widget to add symptoms
            AddSymptomWidget(
              onAdd: (symptom) {
                setState(() {
                  symptoms.add(symptom);
                });
              },
            ),
            const SizedBox(height: 16),
            // Widget to add symptoms
            AddCureWidget(
              onAdd: (cureObject) {
                setState(() {
                  cure.add(cureObject);
                });
              },
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              onPressed: addSick,
              child: const Text(
                'Add Disease',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddSymptomWidget extends StatefulWidget {
  final void Function(Symptom) onAdd;

  const AddSymptomWidget({super.key, required this.onAdd});

  @override
  // ignore: library_private_types_in_public_api
  _AddSymptomWidgetState createState() => _AddSymptomWidgetState();
}

class _AddSymptomWidgetState extends State<AddSymptomWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedSymptom = '';
  List<Symptom> addedSymptoms = [];
  List<String> allSymptoms = [
    'Coughing',
    'Wheezing',
    'Shortness of breath',
    'Fever',
    'Chest pain or tightness',
    'Sore throat',
    'Nasal congestion',
    'Dizziness',
    'Headaches',
    'Joint pain',
    'Fatigue',
    'Chills',
    'Sweating',
    'Runny nose',
    'Loss of appetite',
    'Nausea',
    'Vomiting',
    'Diarrhea',
    'Abdominal pain',
    'Muscle pain',
    'Swollen glands',
    'Rash',
    'Itchy skin',
    'Weight loss',
    'Weight gain',
    'Palpitations',
    'Difficulty swallowing',
    'Hoarseness',
    'Frequent urination',
    'Night sweats',
    //brain
    'Memory loss',
    'Confusion',
    'Difficulty concentrating',
    'Mood swings',
    'Depression',
    'Anxiety',
    'Seizures',
    'Tingling sensations',
    'Vision problems',
    'Speech difficulties',
  ];

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          content: Text(message,
              style:
                  TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK',
                  style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
          ],
          backgroundColor: mainColor2,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Symptoms',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        DropdownButtonFormField<String>(
          value: selectedSymptom.isNotEmpty ? selectedSymptom : null,
          decoration: const InputDecoration(
            labelText: 'Select Symptom',
            labelStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          items: allSymptoms.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                color: mainColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Center(
                    child: Text(
                      value,
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedSymptom = newValue!;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              onPressed: () {
                setState(() {
                  addedSymptoms.clear();
                });
              },
              child: const Text(
                'Clear Symptoms',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              onPressed: () {
                if (selectedSymptom.isNotEmpty) {
                  // Check for repetition
                  bool alreadyExists = addedSymptoms.any((symptom) =>
                      symptom.name.toLowerCase() ==
                      selectedSymptom.toLowerCase());

                  if (alreadyExists) {
                    _showErrorDialog('This symptom has already been added.');
                  } else {
                    final symptom = Symptom(name: selectedSymptom);
                    widget.onAdd(symptom);
                    setState(() {
                      addedSymptoms.add(symptom);
                      selectedSymptom = '';
                    });
                  }
                }
              },
              child: const Text(
                'Add Symptom',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Added Symptoms',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 200, // Set a fixed height for the ListView
          child: ListView.builder(
            itemCount: addedSymptoms.length,
            itemBuilder: (context, index) {
              return Card(
                color: accentColor,
                child: ListTile(
                  title: Text(
                    addedSymptoms[index].name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AddCausesWidget extends StatefulWidget {
  final void Function(Causes) onAdd;

  const AddCausesWidget({super.key, required this.onAdd});

  @override
  // ignore: library_private_types_in_public_api
  _AddCausesWidgetState createState() => _AddCausesWidgetState();
}

class _AddCausesWidgetState extends State<AddCausesWidget> {
  TextEditingController nameController = TextEditingController();
  List<Causes> addedCauses = [];

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          content: Text(message,
              style:
                  TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK',
                  style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
          ],
          backgroundColor: mainColor2,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Causes',
          style: TextStyle(
            color: accentColor2,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            labelStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            hintStyle: TextStyle(color: Colors.black),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              onPressed: () {
                setState(() {
                  addedCauses.clear();
                });
              },
              child: const Text(
                'Clear Causes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  // Check for repetition
                  bool alreadyExists = addedCauses.any((cause) =>
                      cause.name.toLowerCase() ==
                      nameController.text.toLowerCase());

                  if (alreadyExists) {
                    _showErrorDialog('This cause has already been added.');
                  } else {
                    final causesObject = Causes(name: nameController.text);
                    widget.onAdd(causesObject);
                    setState(() {
                      addedCauses.add(causesObject);
                      nameController.clear();
                    });
                  }
                } else {
                  _showErrorDialog('Please enter a cause name.');
                }
              },
              child: const Text(
                'Add Cause',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Added Causes',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 200, // Set a fixed height for the ListView
          child: ListView.builder(
            itemCount: addedCauses.length,
            itemBuilder: (context, index) {
              return Card(
                color: accentColor,
                child: ListTile(
                  title: Text(
                    addedCauses[index].name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AddCureWidget extends StatefulWidget {
  final void Function(Cure) onAdd;

  const AddCureWidget({super.key, required this.onAdd});

  @override
  // ignore: library_private_types_in_public_api
  _AddCureWidgetState createState() => _AddCureWidgetState();
}

class _AddCureWidgetState extends State<AddCureWidget> {
  TextEditingController nameController = TextEditingController();
  List<Cure> addedCures = [];

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          content: Text(message,
              style:
                  TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK',
                  style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
          ],
          backgroundColor: mainColor2,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cure',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            labelStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            hintStyle: TextStyle(color: Colors.black),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              onPressed: () {
                setState(() {
                  addedCures.clear();
                });
              },
              child: const Text(
                'Clear Cures',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  // Check for repetition
                  bool alreadyExists = addedCures.any((cure) =>
                      cure.name.toLowerCase() ==
                      nameController.text.toLowerCase());

                  if (alreadyExists) {
                    _showErrorDialog('This cure has already been added.');
                  } else {
                    final cureObject = Cure(name: nameController.text);
                    widget.onAdd(cureObject);
                    setState(() {
                      addedCures.add(cureObject);
                      nameController.clear();
                    });
                  }
                } else {
                  _showErrorDialog('Please enter a cure name.');
                }
              },
              child: const Text(
                'Add Cure',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Added Cures',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 200, // Set a fixed height for the ListView
          child: ListView.builder(
            itemCount: addedCures.length,
            itemBuilder: (context, index) {
              return Card(
                color: mainColor2,
                child: ListTile(
                  title: Text(
                    addedCures[index].name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
