import 'package:flutter/material.dart';
import 'package:health_action_plan/features/core/colors.dart';
import 'package:health_action_plan/features/widgets/app_space_widget.dart';
import 'package:health_action_plan/features/widgets/refracted_text.dart';

class EmptyReports extends StatelessWidget {
  const EmptyReports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLight,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RefractedText(text: 'It looks like there are no reports yet.'),
            setHeight(16),
            RefractedText(
              text:
                  "This could be because your screening test isn’t complete, or results are still processing. Please check back later or contact support if needed.",
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
