import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
const CategoryScreen({super.key});

final List<Map<String, dynamic>> categories = const [
{
"name": "Science",
"icon": Icons.science,
"color": Colors.green,
},
{
"name": "Math",
"icon": Icons.calculate,
"color": Colors.blue,
},
{
"name": "Computer",
"icon": Icons.computer,
"color": Colors.orange,
},
{
"name": "History",
"icon": Icons.history_edu,
"color": Colors.red,
},
];

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.blue.shade50,

appBar: AppBar(
title: const Text(
"Select Category",
style: TextStyle(
fontSize: 23,
fontWeight: FontWeight.bold,
),
),
centerTitle: true,
backgroundColor: Colors.indigo,
foregroundColor: Colors.white,
elevation: 0,
),

body: Padding(
padding: const EdgeInsets.all(20),

child: GridView.builder(
itemCount: categories.length,

gridDelegate:
const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 2,
crossAxisSpacing: 18,
mainAxisSpacing: 18,
childAspectRatio: 0.95,
),

itemBuilder: (context, index) {
final category = categories[index];

return Card(
elevation: 8,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
),

child: InkWell(
borderRadius: BorderRadius.circular(20),

onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => QuizScreen(
category: category["name"],
),
),
);
},

child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
category["icon"],
size: 60,
color: category["color"],
),

const SizedBox(height: 15),

Text(
category["name"],
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 19,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 8),

const Text(
"Start Quiz",
style: TextStyle(
fontSize: 14,
color: Colors.grey,
),
),
],
),
),
);
},
),
),
);
}
}
