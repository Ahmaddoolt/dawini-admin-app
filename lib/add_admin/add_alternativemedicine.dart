import 'package:dawinadmin/models/static_values.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AlternativeMedicineAdminPage extends StatefulWidget {
  const AlternativeMedicineAdminPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AlternativeMedicineAdminPageState createState() =>
      _AlternativeMedicineAdminPageState();
}

class _AlternativeMedicineAdminPageState
    extends State<AlternativeMedicineAdminPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late final String emailAdmin;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    String? savedEmail = await _storage.read(key: 'saved_email');

    setState(() {
      emailAdmin = savedEmail ?? "empty";
      // rememberMe = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: accentColor2,
        title: const Text('Enter Alternative Medicine Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.healing,
                  color: accentColor,
                  weight: double.infinity,
                  size: 150,
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: accentColor2)),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: accentColor2)),
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor, // Change to purple
                  ),
                  onPressed: () {
                    _saveData();
                  },
                  child: const Text('Save Data'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveData() async {
    // Get data from text fields
    String title = _titleController.text;
    String description = _descriptionController.text;

    // Validate data
    if (title.isNotEmpty && description.isNotEmpty) {
      try {
        // Save data to Firestore
        await FirebaseFirestore.instance.collection('AlternativeMedicine').add(
            {'title': title, 'description': description, 'admin': emailAdmin});

        // Clear text fields after saving data
        _titleController.clear();
        _descriptionController.clear();

        // Show a success message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Data saved successfully!'),
          duration: Duration(seconds: 2),
        ));
      } catch (error) {
        // Show an error message if saving fails
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to save data. Please try again later.'),
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all fields.'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
