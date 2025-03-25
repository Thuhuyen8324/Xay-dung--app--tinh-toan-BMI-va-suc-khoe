import 'package:firebase_core/firebase_core.dart'; 
import 'package:flutter/material.dart';
import 'dart:math';
import 'score_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyBdkgpYT-D0cVVS_wJUkYRPIWKrGBOjFI8",
    authDomain: "bmimanagement-b69f6.firebaseapp.com",
    projectId: "bmimanagement-b69f6",
    storageBucket: "bmimanagement-b69f6.firebasestorage.app",
    messagingSenderId: "934846873072",
    appId: "1:934846873072:web:6254aa4d6cfbb8161e7135",
  ));
  runApp(BMICalculatorApp());
}

enum Gender { nam, nu }

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  Gender selectedGender = Gender.nu;
  double height = 168;
  int weight = 53;
  int age = 21;

  void _calculateBMI() {
    double bmi = weight / pow(height / 100, 2);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreScreen(bmiScore: bmi, age: age),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 600,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                'BMI Calculator',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GenderCard(
                      icon: Icons.male,
                      label: 'Nam',
                      isSelected: selectedGender == Gender.nam,
                      onTap: () => setState(() => selectedGender = Gender.nam)),
                  GenderCard(
                      icon: Icons.female,
                      label: 'Nữ',
                      isSelected: selectedGender == Gender.nu,
                      onTap: () => setState(() => selectedGender = Gender.nu)),
                ],
              ),
              SizedBox(height: 20),
              Text('Height', style: TextStyle(fontSize: 18)),
              Text('${height.round()} cm',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Slider(
                value: height,
                min: 100,
                max: 220,
                divisions: 120,
                label: '${height.round()} cm',
                onChanged: (value) => setState(() => height = value),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CounterCard(
                      label: 'Age',
                      value: age,
                      onChanged: (val) => setState(() => age = val)),
                  CounterCard(
                      label: 'Weight (kg)',
                      value: weight,
                      onChanged: (val) => setState(() => weight = val)),
                ],
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 59, 161, 63),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  minimumSize: Size(250, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _calculateBMI,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Tính BMI",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  GenderCard(
      {required this.icon,
      required this.label,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 40, color: isSelected ? Colors.white : Colors.black),
            SizedBox(height: 5),
            Text(label,
                style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}

class CounterCard extends StatelessWidget {
  final String label;
  final int value;
  final Function(int) onChanged;

  CounterCard(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text('$value',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton("-", () => onChanged(value > 1 ? value - 1 : value)),
            SizedBox(width: 20),
            _buildButton("+", () => onChanged(value + 1)),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        child: Text(text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
