import 'package:dawinadmin/models/static_values.dart';
import 'package:flutter/material.dart';
import 'add_medicalculture.dart';
import 'edit_medicalculture.dart';

class PanelMedicalCulture extends StatelessWidget {
  const PanelMedicalCulture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor2, // Deep Purple
        title: const Text(
          'Medical Culture',
          style: TextStyle(
            color: Colors.white, // Gold
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accentColor2, accentColor], // Purple gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor, // Purple button background
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MedicalCultureAdminPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add, color: accentColor2), // Gold icon
                  label: Text(
                    'Add Content',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: accentColor2, // Gold text
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor, // Purple button background
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageMedicalCulturePage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit, color: accentColor2), // Gold icon
                  label: Text(
                    'Edit Content',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: accentColor2, // Gold text
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
