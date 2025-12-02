import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:solar_icons/solar_icons.dart';

class QuizWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final int correctIndex;
  final VoidCallback? onComplete;

  const QuizWidget({
    super.key,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.onComplete,
  });

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int? _selectedIndex;
  bool _isSubmitted = false;

  void _handleSelection(int index) {
    if (_isSubmitted) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  void _submit() {
    if (_selectedIndex == null) return;
    setState(() {
      _isSubmitted = true;
    });
    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  void _reset() {
    setState(() {
      _selectedIndex = null;
      _isSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect = _selectedIndex == widget.correctIndex;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  SolarIconsBold.questionCircle,
                  color: AppTheme.accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Quick Check',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.question,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          ...List.generate(widget.options.length, (index) {
            final isSelected = _selectedIndex == index;
            final isCorrectOption = index == widget.correctIndex;

            Color? borderColor;
            Color? backgroundColor;
            IconData? icon;

            if (_isSubmitted) {
              if (isCorrectOption) {
                borderColor = Colors.green;
                backgroundColor = Colors.green.withOpacity(0.1);
                icon = SolarIconsBold.checkCircle;
              } else if (isSelected && !isCorrect) {
                borderColor = Colors.red;
                backgroundColor = Colors.red.withOpacity(0.1);
                icon = SolarIconsBold.closeCircle;
              }
            } else if (isSelected) {
              borderColor = AppTheme.primaryColor;
              backgroundColor = AppTheme.primaryColor.withOpacity(0.05);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _handleSelection(index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? Colors.grey[50],
                    border: Border.all(
                      color: borderColor ?? Colors.grey[300]!,
                      width:
                          isSelected || (_isSubmitted && isCorrectOption)
                              ? 2
                              : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.options[index],
                          style: TextStyle(
                            color:
                                _isSubmitted && isSelected && !isCorrect
                                    ? Colors.red
                                    : (_isSubmitted && isCorrectOption
                                        ? Colors.green
                                        : Colors.black87),
                            fontWeight:
                                isSelected || (_isSubmitted && isCorrectOption)
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (icon != null) ...[
                        const SizedBox(width: 8),
                        Icon(icon, color: borderColor, size: 20),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          if (!_isSubmitted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedIndex != null ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text('Check Answer'),
              ),
            )
          else
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isCorrect
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCorrect
                            ? SolarIconsBold.checkCircle
                            : SolarIconsBold.closeCircle,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isCorrect
                              ? 'Correct! Great job!'
                              : 'Not quite. Review the guide above and try again.',
                          style: TextStyle(
                            color:
                                isCorrect ? Colors.green[700] : Colors.red[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isCorrect)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextButton.icon(
                      onPressed: _reset,
                      icon: const Icon(SolarIconsOutline.restart),
                      label: const Text('Try Again'),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
