import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../models/sicken.dart';
import '../models/sympols.dart';
import '../models/static_values.dart';
import 'add_sicken.dart';

class AdminEditSick extends StatefulWidget {
  const AdminEditSick({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminEditSickState createState() => _AdminEditSickState();
}

class _AdminEditSickState extends State<AdminEditSick> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text(
          'Edit or Delete Disease',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Sickens').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No sickness found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              Sick sick = Sick.fromDocumentSnapshot(document);
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                  child: ListTile(
                    title: Text(sick.title),
                    subtitle: Text(sick.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditSickPage(
                                    sick: sick, documentId: document.id),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteSick(document.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _deleteSick(String documentId) async {
    await FirebaseFirestore.instance
        .collection('Sickens')
        .doc(documentId)
        .delete();
  }
}

class EditSickPage extends StatefulWidget {
  final Sick sick;
  final String documentId;

  const EditSickPage({required this.sick, required this.documentId, Key? key})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditSickPageState createState() => _EditSickPageState();
}

class _EditSickPageState extends State<EditSickPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedType = '';
  XFile? _pickedImage;
  List<Symptom> symptoms = [];
  List<Causes> causes = [];
  List<Cure> cure = [];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.sick.title;
    descriptionController.text = widget.sick.description;
    selectedType = widget.sick.type;
    symptoms = widget.sick.symptoms;
    causes = widget.sick.causes;
    cure = widget.sick.cure;
  }

  Future<String> _uploadImage(File imageFile, String imageName) async {
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('book_images')
        .child(imageName);
    await storageReference.putFile(imageFile);
    return await storageReference.getDownloadURL();
  }

  void _updateSick() async {
    String imageUrl = widget.sick.imageUrl;

    if (_pickedImage != null) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      imageUrl = await _uploadImage(File(_pickedImage!.path), imageName);
    }

    Sick updatedSick = Sick(
      title: titleController.text,
      description: descriptionController.text,
      imageUrl: imageUrl,
      type: selectedType,
      symptoms: symptoms,
      causes: causes,
      cure: cure,
    );

    await FirebaseFirestore.instance
        .collection('Sickens')
        .doc(widget.documentId)
        .update({
      'title': updatedSick.title,
      'description': updatedSick.description,
      'imageUrl': updatedSick.imageUrl,
      'type': updatedSick.type,
      'symptoms': updatedSick.symptoms
          .map((symptom) => {'name': symptom.name})
          .toList(),
      'causes':
          updatedSick.causes.map((causes) => {'name': causes.name}).toList(),
      'cure': updatedSick.cure.map((cure) => {'name': cure.name}).toList(),
    });

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text(
          'Edit Sickness',
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
                  : Image.network(
                      widget.sick.imageUrl,
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
            DropdownButtonFormField<String>(
              value: selectedType.isNotEmpty ? selectedType : null,
              decoration: InputDecoration(
                labelText: 'Type',
                labelStyle: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              items: [
                'Physical diseases.',
                'Mental illness.',
                'Psychiatric illness.'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    color: mainColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      child: Center(
                          child: Text(value,
                              style: const TextStyle(
                                  color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 20))),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedType = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            AddCausesWidget(
              onAdd: (cause) {
                setState(() {
                  causes.add(cause);
                });
              },
            ),
            const SizedBox(height: 16),
            AddSymptomWidget(
              onAdd: (symptom) {
                setState(() {
                  symptoms.add(symptom);
                });
              },
            ),
            const SizedBox(height: 16),
            AddCureWidget(
              onAdd: (cureObject) {
                setState(() {
                  cure.add(cureObject);
                });
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              onPressed: _updateSick,
              child: const Text(
                'Update Disease',
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
