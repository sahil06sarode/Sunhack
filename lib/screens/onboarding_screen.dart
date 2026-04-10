import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:conflictsense/screens/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> _regions = ["Middle East", "Eastern Europe", "Africa", "Latin America", "Southeast Asia", "North America", "Global"];
  final List<String> _topics = ["Protests", "Armed Conflict", "Election Integrity", "Economic Crisis", "Displacement", "Terrorism", "Geopolitics"];
  final List<String> _roles = ["Journalist", "NGO Worker", "Corporate Security", "Government Analyst", "Academic Researcher", "Citizen"];
  final List<String> _alertLevels = ["High (All Events)", "Medium (Escalations)", "Low (Critical Only)"];
  
  final Set<String> _selectedRegions = {};
  final Set<String> _selectedTopics = {};
  String? _selectedRole;
  String? _selectedAlertLevel;

  bool _isSaving = false;

  Future<void> _savePreferences() async {
    if (_selectedRegions.isEmpty || _selectedTopics.isEmpty || _selectedRole == null || _selectedAlertLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all sections to initialize the system.")),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName ?? 'Operative',
          'email': user.email,
          'regions': _selectedRegions.toList(),
          'topics': _selectedTopics.toList(),
          'role': _selectedRole,
          'alertSensitivity': _selectedAlertLevel,
          'onboardingComplete': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const IntelligenceDashboard()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("Analyst Profile Configuration", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: _isSaving 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF0F4C81)))
        : ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const Text(
                "1. Primary Objective / Role",
                style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "How will you be using this intelligence data?",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _roles.map((role) {
                  final isSelected = _selectedRole == role;
                  return ChoiceChip(
                    label: Text(role),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedRole = selected ? role : null);
                    },
                    selectedColor: const Color(0xFF0F4C81).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF0F4C81) : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF0F4C81) : Colors.grey.shade300,
                      )
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              const Text(
                "2. Primary Regions of Interest",
                style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Select regions for the AI to prioritize in your live feed.",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _regions.map((region) {
                  final isSelected = _selectedRegions.contains(region);
                  return FilterChip(
                    label: Text(region),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) _selectedRegions.add(region);
                        else _selectedRegions.remove(region);
                      });
                    },
                    selectedColor: const Color(0xFF0F4C81).withOpacity(0.1),
                    checkmarkColor: const Color(0xFF0F4C81),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF0F4C81) : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF0F4C81) : Colors.grey.shade300,
                      )
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              const Text(
                "3. Key Threat Vectors",
                style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "What types of conflicts or events are you tracking?",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _topics.map((topic) {
                  final isSelected = _selectedTopics.contains(topic);
                  return FilterChip(
                    label: Text(topic),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) _selectedTopics.add(topic);
                        else _selectedTopics.remove(topic);
                      });
                    },
                    selectedColor: const Color(0xFF0F4C81).withOpacity(0.1),
                    checkmarkColor: const Color(0xFF0F4C81),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF0F4C81) : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF0F4C81) : Colors.grey.shade300,
                      )
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              const Text(
                "4. Alert Sensitivity",
                style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "How aggressively should the system notify you?",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _alertLevels.map((level) {
                  final isSelected = _selectedAlertLevel == level;
                  return ChoiceChip(
                    label: Text(level),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedAlertLevel = selected ? level : null);
                    },
                    selectedColor: const Color(0xFF0F4C81).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF0F4C81) : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF0F4C81) : Colors.grey.shade300,
                      )
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: _savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F4C81),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("INITIALIZE SYSTEM", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ),
              const SizedBox(height: 24),
            ],
          ),
    );
  }
}
