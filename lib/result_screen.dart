import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // =========================================
    // PERCENTAGE
    // =========================================

    final int percentage = widget.totalQuestions == 0
        ? 0
        : ((widget.score / widget.totalQuestions) * 100).round();

    // 50% OR ABOVE = PASS
    final bool passed = percentage >= 50;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff4A00E0),
              Color(0xff8E2DE2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FadeTransition(
                opacity: fadeAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // =====================================
                        // PASS / FAIL ICON
                        // =====================================

                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0,
                            end: 1,
                          ),
                          duration: const Duration(
                            milliseconds: 1200,
                          ),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Icon(
                                passed
                                    ? Icons.emoji_events
                                    : Icons.sentiment_neutral,
                                color: passed
                                    ? Colors.amber
                                    : Colors.white,
                                size: 120,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // =====================================
                        // MESSAGE
                        // =====================================

                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0,
                            end: 1,
                          ),
                          duration: const Duration(
                            milliseconds: 1000,
                          ),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(
                                  0,
                                  30 * (1 - value),
                                ),
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            passed
                                ? "Congratulations!"
                                : "Keep Practicing!",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // =====================================
                        // RESULT CARD
                        // =====================================

                        Card(
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(25),
                          ),
                          child: Container(
                            width: 300,
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(25),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Your Score",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                // SCORE
                                TweenAnimationBuilder<int>(
                                  tween: IntTween(
                                    begin: 0,
                                    end: widget.score,
                                  ),
                                  duration: const Duration(
                                    seconds: 2,
                                  ),
                                  builder:
                                      (context, value, child) {
                                    return Text(
                                      "$value / ${widget.totalQuestions}",
                                      style: const TextStyle(
                                        fontSize: 42,
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 20),

                                const Text(
                                  "Percentage",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // PERCENTAGE
                                TweenAnimationBuilder<int>(
                                  tween: IntTween(
                                    begin: 0,
                                    end: percentage,
                                  ),
                                  duration: const Duration(
                                    seconds: 2,
                                  ),
                                  curve: Curves.easeOut,
                                  builder:
                                      (context, value, child) {
                                    return Text(
                                      "$value%",
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight:
                                        FontWeight.bold,
                                        color: passed
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 15),

                                // PASS / FAIL
                                TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: 1,
                                  ),
                                  duration:
                                  const Duration(
                                    milliseconds: 1500,
                                  ),
                                  curve: Curves.elasticOut,
                                  builder:
                                      (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: child,
                                    );
                                  },
                                  child: Container(
                                    padding:
                                    const EdgeInsets
                                        .symmetric(
                                      horizontal: 25,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: passed
                                          ? Colors.green.shade50
                                          : Colors.red.shade50,
                                      borderRadius:
                                      BorderRadius.circular(
                                        20,
                                      ),
                                      border: Border.all(
                                        color: passed
                                            ? Colors.green
                                            : Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      passed ? "PASS" : "FAIL",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight:
                                        FontWeight.bold,
                                        color: passed
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  passed
                                      ? "Excellent Work!"
                                      : "Practice More & Try Again",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  passed
                                      ? "You scored 50% or above."
                                      : "You scored below 50%.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: passed
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 35),

                        // =====================================
                        // PLAY AGAIN
                        // =====================================

                        SizedBox(
                          width: 220,
                          height: 55,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text(
                              "Play Again",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.indigo,
                              elevation: 8,
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QuizScreen(
                                        category: "General Knowledge",
                                      ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // =====================================
                        // HOME
                        // =====================================

                        SizedBox(
                          width: 220,
                          height: 55,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.home),
                            label: const Text(
                              "Home",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            style:
                            OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                    (route) => route.isFirst,
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================
  // DISPOSE
  // =========================================

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


