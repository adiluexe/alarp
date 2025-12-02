import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/learn/data/static_lesson_data.dart';
import 'package:alarp/features/learn/models/lesson.dart';

class SpeedRunScreen extends ConsumerStatefulWidget {
  final String? regionId;
  const SpeedRunScreen({super.key, this.regionId});

  @override
  ConsumerState<SpeedRunScreen> createState() => _SpeedRunScreenState();
}

class _SpeedRunScreenState extends ConsumerState<SpeedRunScreen> {
  late List<QuizQuestion> _allQuestions;
  late QuizQuestion _currentQuestion;
  Timer? _timer;
  int _remainingSeconds = 180; // 3 minutes
  int _score = 0;
  int _questionsAnswered = 0;
  bool _isGameOver = false;
  bool _isAnswered = false;
  int? _selectedOptionIndex;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
    _nextQuestion();
  }

  void _loadQuestions() {
    _allQuestions = [];
    for (final lesson in allStaticLessons) {
      if (widget.regionId == null || lesson.bodyRegion == widget.regionId) {
        _allQuestions.addAll(lesson.quizQuestions);
      }
    }
    // Fallback if no questions found
    if (_allQuestions.isEmpty) {
      _allQuestions.add(
        const QuizQuestion(
          question: 'Placeholder Question',
          options: ['A', 'B', 'C', 'D'],
          correctIndex: 0,
          explanation: 'Placeholder',
        ),
      );
    }
    _allQuestions.shuffle();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _endGame();
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _isGameOver = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      _isAnswered = false;
      _selectedOptionIndex = null;
      _currentQuestion = _allQuestions[Random().nextInt(_allQuestions.length)];
    });
  }

  void _handleAnswer(int index) {
    if (_isAnswered || _isGameOver) return;

    final correct = index == _currentQuestion.correctIndex;
    setState(() {
      _isAnswered = true;
      _selectedOptionIndex = index;
      _isCorrect = correct;
      if (correct) {
        _score += 100;
      }
      _questionsAnswered++;
    });

    // Auto advance after short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && !_isGameOver) {
        _nextQuestion();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isGameOver) {
      return _buildGameOver();
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Speed Run'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontFamily: 'Chillax',
          fontWeight: FontWeight.bold,
          color: AppTheme.textColor,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      SolarIconsOutline.clockCircle,
                      size: 16,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Score Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_questionsAnswered + 1}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textColor.withOpacity(0.6),
                  ),
                ),
                Text(
                  'Score: $_score',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Question Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentQuestion.question,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textColor,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ...List.generate(
                      _currentQuestion.options.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildOption(index),
                      ),
                    ),
                    if (_isAnswered) ...[
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              _isCorrect
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isCorrect
                                  ? SolarIconsBold.checkCircle
                                  : SolarIconsBold.closeCircle,
                              color: _isCorrect ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _isCorrect
                                    ? 'Correct!'
                                    : 'Incorrect. ${_currentQuestion.explanation}',
                                style: TextStyle(
                                  color: _isCorrect ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(int index) {
    final isSelected = _selectedOptionIndex == index;
    final isCorrectOption = index == _currentQuestion.correctIndex;

    Color borderColor = Colors.grey[200]!;
    Color backgroundColor = Colors.transparent;
    Color textColor = AppTheme.textColor;

    if (_isAnswered) {
      if (isCorrectOption) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
      } else if (isSelected && !isCorrectOption) {
        borderColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
      }
    } else if (isSelected) {
      borderColor = AppTheme.primaryColor;
      backgroundColor = AppTheme.primaryColor.withOpacity(0.05);
      textColor = AppTheme.primaryColor;
    }

    return InkWell(
      onTap: () => _handleAnswer(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color:
                    _isAnswered && isCorrectOption
                        ? Colors.green
                        : (_isAnswered && isSelected && !isCorrectOption
                            ? Colors.red
                            : Colors.grey[100]),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        _isAnswered && (isCorrectOption || isSelected)
                            ? Colors.white
                            : Colors.grey[600],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _currentQuestion.options[index],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOver() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                SolarIconsBold.cupStar,
                size: 80,
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 24),
              Text(
                'Time\'s Up!',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontFamily: 'Chillax',
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You scored',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textColor.withOpacity(0.6),
                ),
              ),
              Text(
                '$_score',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Questions Answered: $_questionsAnswered',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Back to Menu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
