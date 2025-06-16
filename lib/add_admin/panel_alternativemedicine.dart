import 'package:dawinadmin/models/static_values.dart';
import 'package:flutter/material.dart';
import 'add_alternativemedicine.dart';
import 'edit_alternativemedicine.dart';

class PanelAlternative extends StatelessWidget {
  const PanelAlternative({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor2, // Deep Purple
        title: const Text(
          'Alternative Medicine',
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
                        builder: (context) =>
                            const AlternativeMedicineAdminPage(),
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
                        builder: (context) =>
                            const ManageAlternativeMedicinePage(),
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
