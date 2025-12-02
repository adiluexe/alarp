import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/learn/data/static_lesson_data.dart';
import 'package:alarp/features/learn/models/lesson.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  const FlashcardScreen({super.key});

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> {
  late List<Lesson> _lessons;
  late Lesson _currentLesson;
  late List<String> _options;
  bool _isAnswered = false;
  bool _isCorrect = false;
  int _score = 0;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _lessons = allStaticLessons.where((l) => l.imageUrl != null).toList();
    if (_lessons.isEmpty) {
      // Fallback if no images
      _lessons = allStaticLessons;
    }
    _nextCard();
  }

  void _nextCard() {
    setState(() {
      _isAnswered = false;
      _isCorrect = false;
      _currentLesson = _lessons[Random().nextInt(_lessons.length)];
      _generateOptions();
    });
  }

  void _generateOptions() {
    final correctOption = _currentLesson.title;
    final otherOptions =
        _lessons
            .where((l) => l.id != _currentLesson.id)
            .map((l) => l.title)
            .toSet() // Ensure unique titles
            .toList();

    otherOptions.shuffle();
    _options = [correctOption, ...otherOptions.take(3)]..shuffle();
  }

  void _handleAnswer(String selectedOption) {
    if (_isAnswered) return;

    final correct = selectedOption == _currentLesson.title;
    setState(() {
      _isAnswered = true;
      _isCorrect = correct;
      if (correct) {
        _score += 10;
        _streak++;
      } else {
        _streak = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Flashcards'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontFamily: 'Chillax',
          fontWeight: FontWeight.bold,
          color: AppTheme.textColor,
        ),
        leading: IconButton(
          icon: const Icon(
            SolarIconsOutline.arrowLeft,
            color: AppTheme.textColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      SolarIconsBold.flame,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_streak',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
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
          // Score
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Score: $_score',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textColor.withOpacity(0.6),
              ),
            ),
          ),

          // Flashcard
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Image Area
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          color: Colors.grey[100],
                          image:
                              _currentLesson.imageUrl != null
                                  ? DecorationImage(
                                    image: AssetImage(_currentLesson.imageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                  : null,
                        ),
                        child:
                            _currentLesson.imageUrl == null
                                ? Center(
                                  child: Icon(
                                    SolarIconsOutline.gallery,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                )
                                : null,
                      ),
                    ),

                    // Options Area
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isAnswered) ...[
                              Icon(
                                _isCorrect
                                    ? SolarIconsBold.checkCircle
                                    : SolarIconsBold.closeCircle,
                                size: 48,
                                color: _isCorrect ? Colors.green : Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _isCorrect ? 'Correct!' : 'Incorrect',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(
                                  color: _isCorrect ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (!_isCorrect)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Answer: ${_currentLesson.title}',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(color: AppTheme.textColor),
                                  ),
                                ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _nextCard,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text('Next Card'),
                                ),
                              ),
                            ] else ...[
                              Text(
                                'Identify this projection',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.textColor.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 24),
                              ..._options.map(
                                (option) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () => _handleAnswer(option),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        side: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        option,
                                        style: const TextStyle(
                                          color: AppTheme.textColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
