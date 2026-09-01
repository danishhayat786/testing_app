import 'dart:async' ;

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
final String category;

const QuizScreen({
super.key,
required this.category,
});

@override
State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
with SingleTickerProviderStateMixin {
// =========================================================
// VARIABLES
// =========================================================

int currentQuestion = 0;
int score = 0;
int remainingSeconds = 10;

bool answerSelected = false;

Timer? _timer;

final AudioPlayer _audioPlayer = AudioPlayer();

late AnimationController _controller;
late Animation<double> _fadeAnimation;
late Animation<double> _scaleAnimation;

List<Map<String, dynamic>> questions = [];

// =========================================================
// ALL QUESTIONS
// =========================================================

final List<Map<String, dynamic>> allQuestions = [
// =========================
// SCIENCE
// =========================

    {
"subject": "Science",
"question": "What planet is known as the Red Planet?",
"options": [
"Earth",
"Mars",
"Jupiter",
"Venus",
],
"answer": "Mars",
},
{
"subject": "Science",
"question": "Plants prepare food by?",
"options": [
"Respiration",
"Photosynthesis",
"Digestion",
"Transpiration",
],
"answer": "Photosynthesis",
},

// =========================
// MATH
// =========================

    {
"subject": "Math",
"question": "15 × 4 = ?",
"options": [
"45",
"50",
"60",
"65",
],
"answer": "60",
},
{
"subject": "Math",
"question": "Square root of 81 is?",
"options": [
"7",
"8",
"9",
"10",
],
"answer": "9",
},

// =========================
// COMPUTER
// =========================

    {
"subject": "Computer",
"question": "Flutter is developed by?",
"options": [
"Apple",
"Microsoft",
"Google",
"Meta",
],
"answer": "Google",
},
{
"subject": "Computer",
"question":
"Which device is used to store data permanently?",
"options": [
"RAM",
"CPU",
"Hard Disk",
"Keyboard",
],
"answer": "Hard Disk",
},

// =========================
// HISTORY
// =========================

    {
"subject": "History",
"question": "Who was the founder of Pakistan?",
"options": [
"Allama Iqbal",
"Liaquat Ali Khan",
"Quaid-e-Azam",
"Sir Syed Ahmed Khan",
],
"answer": "Quaid-e-Azam",
},
{
"subject": "History",
"question":
"Who was the first President of Pakistan?",
"options": [
"Ayub Khan",
"Iskander Mirza",
"Zulfikar Ali Bhutto",
"Liaquat Ali Khan",
],
"answer": "Iskander Mirza",
},
];

// =========================================================
// INIT STATE
// =========================================================

@override
void initState() {
super.initState();

// =======================================================
// ANIMATION CONTROLLER
// =======================================================

_controller = AnimationController(
vsync: this,
duration: const Duration(milliseconds: 700),
);

_fadeAnimation = CurvedAnimation(
parent: _controller,
curve: Curves.easeIn,
);

_scaleAnimation = Tween<double>(
begin: 0.85,
end: 1.0,
).animate(
CurvedAnimation(
parent: _controller,
curve: Curves.easeOutBack,
),
);

// =======================================================
// FIND QUESTIONS FOR SELECTED CATEGORY
// =======================================================

final String selectedCategory =
widget.category.trim().toLowerCase();

questions = allQuestions.where((question) {
final String subject =
question["subject"].toString().trim().toLowerCase();

return subject == selectedCategory;
}).toList();

// =======================================================
// DEBUG
// =======================================================

debugPrint(
"======================================",
);

debugPrint(
"CATEGORY RECEIVED: ${widget.category}",
);

debugPrint(
"QUESTIONS FOUND: ${questions.length}",
);

debugPrint(
"======================================",
);

// =======================================================
// START QUIZ
// =======================================================

if (questions.isNotEmpty) {
_controller.forward();
startTimer();
}
}

// =========================================================
// TIMER
// =========================================================

void startTimer() {
_timer?.cancel();

if (!mounted || questions.isEmpty) {
return;
}

setState(() {
remainingSeconds = 10;
});

_timer = Timer.periodic(
const Duration(seconds: 1),
(timer) {
if (!mounted || answerSelected) {
timer.cancel();
return;
}

if (remainingSeconds > 1) {
setState(() {
remainingSeconds--;
});
} else {
timer.cancel();

setState(() {
remainingSeconds = 0;
});

timeUp();
}
},
);
}

// =========================================================
// TIME UP
// =========================================================

Future<void> timeUp() async {
if (answerSelected) {
return;
}

answerSelected = true;

await playSound("sounds/timeout.mp3");

if (!mounted) {
return;
}

await Future.delayed(
const Duration(milliseconds: 500),
);

if (!mounted) {
return;
}

moveToNextQuestion();
}

// =========================================================
// CHECK ANSWER
// =========================================================

Future<void> checkAnswer(String selectedAnswer) async {
if (answerSelected || questions.isEmpty) {
return;
}

answerSelected = true;

_timer?.cancel();

final String correctAnswer =
questions[currentQuestion]["answer"].toString();

final bool correct =
selectedAnswer == correctAnswer;

if (correct) {
score++;

await playSound(
"sounds/correct.mp3",
);
} else {
await playSound(
"sounds/wrong.mp3",
);
}

if (!mounted) {
return;
}

await Future.delayed(
const Duration(milliseconds: 500),
);

if (!mounted) {
return;
}

moveToNextQuestion();
}

// =========================================================
// NEXT QUESTION
// =========================================================

void moveToNextQuestion() {
if (questions.isEmpty) {
return;
}

if (currentQuestion < questions.length - 1) {
setState(() {
currentQuestion++;
answerSelected = false;
remainingSeconds = 10;
});

_controller.reset();
_controller.forward();

startTimer();
} else {
_timer?.cancel();

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context) {
return ResultScreen(
score: score,
totalQuestions: questions.length,
);
},
),
);
}
}

// =========================================================
// PLAY SOUND
// =========================================================

Future<void> playSound(String fileName) async {
try {
await _audioPlayer.stop();

await _audioPlayer.play(
AssetSource(fileName),
);
} catch (e) {
debugPrint(
"Sound error: $e",
);
}
}

// =========================================================
// BUILD
// =========================================================

@override
Widget build(BuildContext context) {
// =======================================================
// NO QUESTIONS
// =======================================================

if (questions.isEmpty) {
return Scaffold(
appBar: AppBar(
title: const Text("Quiz"),
backgroundColor: Colors.indigo,
foregroundColor: Colors.white,
),
body: Center(
child: Padding(
padding: const EdgeInsets.all(20),
child: Column(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
const Icon(
Icons.quiz_outlined,
size: 80,
color: Colors.indigo,
),

const SizedBox(height: 20),

const Text(
"No questions available",
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 10),

Text(
"Category: ${widget.category}",
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 18,
),
),

const SizedBox(height: 20),

ElevatedButton(
onPressed: () {
Navigator.pop(context);
},
child: const Text(
"Choose Another Category",
),
),
],
),
),
),
);
}

// =======================================================
// CURRENT QUESTION
// =======================================================

final double questionProgress =
(currentQuestion + 1) / questions.length;

final double timerProgress =
remainingSeconds / 10;

final bool warning =
remainingSeconds <= 3;

final String currentSubject =
questions[currentQuestion]["subject"].toString();

final String currentQuestionText =
questions[currentQuestion]["question"].toString();

final List<dynamic> options =
questions[currentQuestion]["options"]
as List<dynamic>;

// =======================================================
// SCREEN
// =======================================================

return Scaffold(
backgroundColor: Colors.blue.shade50,

appBar: AppBar(
backgroundColor: Colors.indigo,
foregroundColor: Colors.white,
centerTitle: true,
elevation: 0,

title: Text(
"${widget.category} Quiz",
style: const TextStyle(
fontSize: 23,
fontWeight: FontWeight.bold,
),
),
),

body: SafeArea(
child: SingleChildScrollView(
physics:
const BouncingScrollPhysics(),

child: Padding(
padding: const EdgeInsets.all(18),

child: Column(
children: [
// =================================================
// QUESTION NUMBER + SCORE
// =================================================

Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
Text(
"Question ${currentQuestion + 1}/${questions.length}",
style: const TextStyle(
fontSize: 18,
fontWeight:
FontWeight.bold,
),
),

Text(
"Score: $score",
style: const TextStyle(
fontSize: 18,
fontWeight:
FontWeight.bold,
color: Colors.indigo,
),
),
],
),

const SizedBox(height: 15),

// =================================================
// QUESTION PROGRESS
// =================================================

TweenAnimationBuilder<double>(
key: ValueKey(
currentQuestion,
),

tween: Tween<double>(
begin: 0,
end: questionProgress,
),

duration:
const Duration(
milliseconds: 600,
),

curve: Curves.easeOut,

builder: (
context,
value,
child,
) {
return LinearProgressIndicator(
value: value,
minHeight: 10,
borderRadius:
BorderRadius.circular(20),
backgroundColor:
Colors.grey.shade300,
color: Colors.indigo,
);
},
),

const SizedBox(height: 20),

// =================================================
// TIMER
// =================================================

AnimatedContainer(
duration:
const Duration(
milliseconds: 300,
),

width: double.infinity,

padding:
const EdgeInsets.all(15),

decoration: BoxDecoration(
color: warning
? Colors.red.shade50
    : Colors.white,

borderRadius:
BorderRadius.circular(18),

boxShadow: [
BoxShadow(
color: Colors.black
    .withOpacity(0.08),
blurRadius: 8,
offset:
const Offset(0, 3),
),
],
),

child: Column(
children: [
Row(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
AnimatedSwitcher(
duration:
const Duration(
milliseconds: 300,
),

child: Icon(
warning
? Icons.warning
    : Icons.timer,

key: ValueKey(
warning,
),

size: 28,

color: warning
? Colors.red
    : Colors.indigo,
),
),

const SizedBox(width: 8),

AnimatedDefaultTextStyle(
duration:
const Duration(
milliseconds: 300,
),

style: TextStyle(
fontSize: 22,
fontWeight:
FontWeight.bold,
color: warning
? Colors.red
    : Colors.indigo,
),

child: Text(
"$remainingSeconds seconds",
),
),
],
),

const SizedBox(height: 10),

LinearProgressIndicator(
value: timerProgress,
minHeight: 8,
borderRadius:
BorderRadius.circular(20),
backgroundColor:
Colors.grey.shade300,
color: warning
? Colors.red
    : Colors.indigo,
),
],
),
),

const SizedBox(height: 25),

// =================================================
// SUBJECT
// =================================================

AnimatedSwitcher(
duration:
const Duration(
milliseconds: 400,
),

child: Container(
key: ValueKey(
currentSubject,
),

padding:
const EdgeInsets.symmetric(
horizontal: 18,
vertical: 8,
),

decoration: BoxDecoration(
color:
Colors.indigo.shade100,
borderRadius:
BorderRadius.circular(20),
),

child: Text(
currentSubject,

style: const TextStyle(
color: Colors.indigo,
fontWeight:
FontWeight.bold,
fontSize: 16,
),
),
),
),

const SizedBox(height: 18),

// =================================================
// QUESTION CARD
// =================================================

FadeTransition(
opacity: _fadeAnimation,

child: ScaleTransition(
scale: _scaleAnimation,

child: Card(
elevation: 10,

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(
20,
),
),

child: Padding(
padding:
const EdgeInsets.all(
25,
),

child: Column(
children: [
TweenAnimationBuilder<
double>(
tween: Tween<double>(
begin: 0.5,
end: 1.0,
),

duration:
const Duration(
milliseconds: 600,
),

curve:
Curves.elasticOut,

builder: (
context,
value,
child,
) {
return Transform.scale(
scale: value,
child: child,
);
},

child: const Icon(
Icons.quiz,
size: 60,
color:
Colors.indigo,
),
),

const SizedBox(
height: 20,
),

AnimatedSwitcher(
duration:
const Duration(
milliseconds: 400,
),

child: Text(
currentQuestionText,

key: ValueKey(
currentQuestionText,
),

textAlign:
TextAlign.center,

style:
const TextStyle(
fontSize: 23,
fontWeight:
FontWeight.bold,
),
),
),
],
),
),
),
),
),

const SizedBox(height: 30),

// =================================================
// ANSWER BUTTONS
// =================================================

Column(
children: List.generate(
options.length,
(index) {
final String option =
options[index].toString();

return Padding(
padding:
const EdgeInsets.only(
bottom: 15,
),

child:
TweenAnimationBuilder<
double>(
key: ValueKey(
"$currentQuestion-$index",
),

duration: Duration(
milliseconds:
300 +
(index * 100),
),

tween: Tween<double>(
begin: 0,
end: 1,
),

curve:
Curves.easeOutBack,

builder: (
context,
value,
child,
) {
return Opacity(
opacity: value,

child:
Transform.translate(
offset: Offset(
0,
20 *
(1 - value),
),

child: child,
),
);
},

child: SizedBox(
width:
double.infinity,
height: 60,

child:
ElevatedButton(
style:
ElevatedButton
    .styleFrom(
backgroundColor:
Colors.white,

foregroundColor:
Colors.indigo,

elevation: 6,

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius
    .circular(
15,
),
),
),

onPressed:
answerSelected
? null
    : () {
checkAnswer(
option,
);
},

child: Text(
option,

textAlign:
TextAlign.center,

style:
const TextStyle(
fontSize: 18,
fontWeight:
FontWeight.w600,
),
),
),
),
),
);
},
),
),

const SizedBox(height: 10),
],
),
),
),
),
);
}

// =========================================================
// DISPOSE
// =========================================================

@override
void dispose() {
_timer?.cancel();
_controller.dispose();
_audioPlayer.dispose();

super.dispose();
}
}
