import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:share_plus/share_plus.dart';

class ScoreScreen extends StatefulWidget {
  final double bmiScore;
  final int age;

  const ScoreScreen({super.key, required this.bmiScore, required this.age});

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final CollectionReference resultCollection =
      FirebaseFirestore.instance.collection('result');

  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  void _saveResult() {
    final bmiInfo = getBmiInterpretation(widget.bmiScore);
    resultCollection.add({
      'bmi': widget.bmiScore,
      'age': widget.age,  
      'status': bmiInfo['status'],
      'message': bmiInfo['message'],
      'timestamp': Timestamp.now(),
    });
  }

  Map<String, dynamic> getBmiInterpretation(double bmi) {
    if (bmi > 30) {
      return {
        'status': 'Béo phì',
        'message': 'Hãy hành động để giảm béo phì',
        'color': Colors.pink
      };
    } else if (bmi >= 25) {
      return {
        'status': 'Thừa cân',
        'message': 'Tập thể dục thường xuyên và giảm cân',
        'color': Colors.orange
      };
    } else if (bmi >= 18.5) {
      return {
        'status': 'Bình thường',
        'message': 'Tận hưởng sức khỏe tốt',
        'color': Colors.green
      };
    } else {
      return {
        'status': 'Thiếu cân',
        'message': 'Cố gắng ăn uống đầy đủ để tăng cân',
        'color': Colors.red
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final bmiInfo = getBmiInterpretation(widget.bmiScore);

    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 600,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 209, 173, 173),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Your Score",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              SizedBox(height: 20),
              PrettyGauge(
                gaugeSize: 250,
                minValue: 0,
                maxValue: 40,
                segments: [
                  GaugeSegment('Thiếu cân', 18.5, Colors.red),
                  GaugeSegment('Bình thường', 6.4, Colors.green),
                  GaugeSegment('Thừa cân', 5, Colors.orange),
                  GaugeSegment('Béo phì', 10.1, Colors.pink),
                ],
                valueWidget: Text(widget.bmiScore.toStringAsFixed(1),
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                currentValue: widget.bmiScore,
                needleColor: Colors.blue,
              ),
              SizedBox(height: 10),
              Text(bmiInfo['status'],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: bmiInfo['color'])),
              SizedBox(height: 10),
              Text(bmiInfo['message'],
                  style: TextStyle(fontSize: 15), textAlign: TextAlign.center),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Tính toán lại"),
                  ),
                  ElevatedButton(
                    onPressed: () => Share.share(
                        "Your BMI is ${widget.bmiScore.toStringAsFixed(1)} at age ${widget.age}"),
                    child: Text("Chia sẻ"),
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
