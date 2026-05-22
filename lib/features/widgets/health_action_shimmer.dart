import 'package:flutter/material.dart';
import 'package:health_action_plan/features/core/colors.dart';
import 'package:health_action_plan/features/widgets/app_space_widget.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that displays a shimmer effect for a report loading view.
///
/// The [HealthActionShimmer] widget is used to show a placeholder while the healthaction data is loading.
/// It consists of a series of shimmer effects that mimic the loading state of various UI elements.
///
/// The widget includes:
/// - A header shimmer effect for text.
/// - A row of shimmer circles to represent loading indicators.
/// - A list of shimmer containers to represent loading list items.
///
/// The layout and appearance of the shimmer effect are defined by the child widgets: [TextShimmer] and [SimmerCircle].

class HealthActionShimmer extends StatelessWidget {
  const HealthActionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TextShimmer(), // Shimmer effect for text.
          // Shimmer effect for text.
          setHeight(20), // Spacer between UI elements.
          Padding(
            padding: const EdgeInsets.only(left: 32.0, right: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                setHeight(20), // Spacing between widgets
                // Main title for the Health Action Plan
                const TextShimmer(),
                const TextShimmer(),
                setHeight(8), // Spacing between widgets

                // Subtitle with a brief description of the plan
                const TextShimmer(),
                setHeight(8),

                // Container displaying the physician's note
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: PageView.builder(
                      // physics: NeverScrollableScrollPhysics(),

                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return ListView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemCount: 6,
                          itemBuilder: (context, noteIndex) {
                            return Shimmer.fromColors(
                              baseColor: AppColors
                                  .backgroundBlueLight, // Base color for shimmer effect.
                              highlightColor: Colors
                                  .white, // Highlight color for shimmer effect.
                              child: Container(
                                height: 50, // Height of shimmer list item.
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 20,
                                ), // Margin around shimmer list item.
                                color: AppColors
                                    .backgroundBlueLight, // Background color of shimmer list item.
                              ),
                            );
                          },
                        );
                      },),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget that displays a shimmer effect for text placeholders.
///
/// The [TextShimmer] widget is used to show a shimmer effect for text areas while data is loading.
/// It consists of two placeholder containers with a shimmer effect to mimic text loading.
///
/// The layout and appearance of the shimmer effect are defined by the size and margins of the containers.

class TextShimmer extends StatelessWidget {
  const TextShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:
          AppColors.backgroundBlueLight, // Base color for shimmer effect.
      highlightColor: Colors.white, // Highlight color for shimmer effect.
      child: Column(
        children: [
          Container(
            height: 15, // Height of the shimmer text placeholder.
            color: AppColors
                .backgroundBlueLight, // Background color of shimmer text placeholder.
            margin: const EdgeInsets.fromLTRB(
              20,
              0,
              100,
              0,
            ), // Margin around the shimmer text placeholder.
          ),
          Container(
            height: 15, // Height of the shimmer text placeholder.
            color: AppColors
                .backgroundBlueLight, // Background color of shimmer text placeholder.
            margin: const EdgeInsets.fromLTRB(
              20,
              10,
              200,
              0,
            ), // Margin around the shimmer text placeholder.
          ),
        ],
      ),
    );
  }
}

/// A widget that displays a shimmer effect for circular placeholders.
///
/// The [SimmerCircle] widget is used to show a shimmer effect for circular placeholders, typically used
/// to represent loading profile pictures or icons.
///
/// The layout and appearance of the shimmer effect are defined by the size and shape of the circular container.

class SimmerCircle extends StatelessWidget {
  const SimmerCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:
          AppColors.backgroundBlueLight, // Base color for shimmer effect.
      highlightColor: Colors.white, // Highlight color for shimmer effect.
      child: Container(
        height: 60, // Height of the shimmer circle.
        width: 60, // Width of the shimmer circle.
        margin: const EdgeInsets.only(
          right: 10,
        ), // Margin around the shimmer circle.
        decoration: const BoxDecoration(
          color: AppColors
              .backgroundBlueLight, // Background color of shimmer circle.
          shape: BoxShape.circle, // Shape of the shimmer circle.
        ),
      ),
    );
  }
}
