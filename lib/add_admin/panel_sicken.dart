import 'package:dawinadmin/models/static_values.dart';
import 'package:flutter/material.dart';
import 'add_sicken.dart';
import 'edit_sicken.dart';

class PanelSicken extends StatelessWidget {
  const PanelSicken({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sicken Management',
          style: TextStyle(
            color: Colors.white, // Gold
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: accentColor, // Deep Purple
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accentColor, accentColor2], // Deep purple gradient
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Wrap the button in a SizedBox to set a fixed width
              SizedBox(
                width: double.infinity, // Makes both buttons the same width
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor, // Purple button background
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
                          builder: (context) => const AdminAddSick()),
                    );
                  },
                  icon: Icon(Icons.add, color: accentColor2), // Gold icon
                  label: Text(
                    'Add Disease',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: accentColor2, // Gold text color
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Makes both buttons the same width
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor, // Purple button background
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
                          builder: (context) => const AdminEditSick()),
                    );
                  },
                  icon: Icon(Icons.edit, color: accentColor2), // Gold icon
                  label: Text(
                    'Edit Disease',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: accentColor2, // Gold text color
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
