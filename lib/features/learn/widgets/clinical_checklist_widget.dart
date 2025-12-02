import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:solar_icons/solar_icons.dart';

class ClinicalChecklistWidget extends StatefulWidget {
  final List<String> criteria;

  const ClinicalChecklistWidget({Key? key, required this.criteria})
    : super(key: key);

  @override
  State<ClinicalChecklistWidget> createState() =>
      _ClinicalChecklistWidgetState();
}

class _ClinicalChecklistWidgetState extends State<ClinicalChecklistWidget> {
  // Track checked state for each item
  late List<bool> _checkedStates;

  @override
  void initState() {
    super.initState();
    _checkedStates = List.filled(widget.criteria.length, false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.criteria.isEmpty) {
      return const SizedBox.shrink();
    }

    final allChecked = _checkedStates.every((state) => state);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
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
        border: Border.all(
          color: allChecked ? AppTheme.primaryColor : Colors.grey.shade100,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      allChecked
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : AppTheme.secondaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  allChecked
                      ? SolarIconsBold.verifiedCheck
                      : SolarIconsBold.clipboardCheck,
                  color:
                      allChecked
                          ? AppTheme.primaryColor
                          : AppTheme.secondaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allChecked ? 'Criteria Met!' : 'Clinical Criteria',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      allChecked
                          ? 'Great job verifying the image.'
                          : 'Verify these points for a diagnostic image.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(widget.criteria.length, (index) {
            final isChecked = _checkedStates[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _checkedStates[index] = !isChecked;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isChecked
                            ? AppTheme.primaryColor.withOpacity(0.05)
                            : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isChecked
                              ? AppTheme.primaryColor.withOpacity(0.3)
                              : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color:
                              isChecked
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                          border: Border.all(
                            color:
                                isChecked
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade400,
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child:
                            isChecked
                                ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.criteria[index],
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color:
                                isChecked
                                    ? AppTheme.textColor
                                    : AppTheme.textColor.withOpacity(0.8),
                            decoration:
                                isChecked ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
