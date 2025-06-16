import 'package:dawinadmin/models/static_values.dart';
import 'package:flutter/material.dart';
import 'add_medicine.dart';
import 'edit_medicine.dart';

class MedicinePanel extends StatelessWidget {
  const MedicinePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicine Management',
          style: TextStyle(
            color: Colors.white, // Gold
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: accentColor2, // Deep Purple
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accentColor2, accentColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // First button wrapped in SizedBox to ensure equal width
              SizedBox(
                width: double.infinity, // Makes both buttons the same width
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor, // Purple
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddMedicineForm()),
                    );
                  },
                  icon: Icon(Icons.add, color: accentColor2), // Gold Icon
                  label: Text(
                    'Add Medicine',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: accentColor2, // Gold Text
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Second button wrapped in SizedBox to ensure equal width
              SizedBox(
                width: double.infinity, // Makes both buttons the same width
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor, // Purple
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageMedicinePage()),
                    );
                  },
                  icon: Icon(Icons.edit, color: accentColor2), // Gold Icon
                  label: Text(
                    'Manage Medicine',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: accentColor2, // Gold Text
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
