import 'package:flutter/material.dart';
import 'package:health_action_plan/features/core/colors.dart';
import 'package:health_action_plan/features/model/health_action_plan_model.dart';
import 'package:health_action_plan/features/provider/health_action_plan_provider.dart';
import 'package:health_action_plan/features/widgets/app_space_widget.dart';
import 'package:health_action_plan/features/widgets/empty_reports.dart';
import 'package:health_action_plan/features/widgets/health_action_shimmer.dart';
import 'package:health_action_plan/features/widgets/refracted_text.dart';
import 'package:health_action_plan/features/widgets/svg_image.dart';
import 'package:provider/provider.dart';

/// A StatefulWidget that displays a health action plan based on a user's consultation with a doctor.
/// It provides recommendations and physician's notes for the user's health plan.
///
/// This widget expects a [HealthActionPlanProvider] to be available in the widget tree.
class HealthActionPlan extends StatefulWidget {
  final String opno;
  final String? packageName;
  const HealthActionPlan(this.opno, {this.packageName, super.key});

  @override
  State<HealthActionPlan> createState() => _HealthActionPlanState();
}

class _HealthActionPlanState extends State<HealthActionPlan>
    with TickerProviderStateMixin {
  /// Manages the synchronized state between the [TabBar] and the [PageView].
  /// Initialized dynamically based on the years available in the provider.
  TabController? controller;

  /// Manages navigation for the content area containing physician notes.
  late PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<HealthActionPlanProvider>();
      await provider.getHealthActionPlan(widget.opno);
      // Initialize tab controller after fetching years
      if (mounted && provider.years.isNotEmpty) {
        setState(() {
          controller = TabController(
            length: provider.years.length,
            vsync: this,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final healthActionEntryProvider = Provider.of<HealthActionPlanProvider>(
      context,
    );

    return Scaffold(
      backgroundColor: AppColors.white,

      // The main content is displayed within a CustomScrollView for better scrolling performance
      body: healthActionEntryProvider.isHealthActiondataLoading
          ? const HealthActionShimmer()
          : (!healthActionEntryProvider.isHealthActiondataAvailable ||
                controller == null)
          ? const EmptyReports() //Shows welcome screen if reports are not available
          : healthActionEntryProvider.hasNoPhysicianNotes()
          ? Center(
              child: Text(
                "Physician notes for you will be shown soon \n— we’re on track for you!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.buttonBlue,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              // Faint baseline line across all tabs
                              Container(height: 0.7, color: Colors.grey[300]),
                              TabBar(
                                indicatorColor: AppColors.buttonBlue,
                                indicatorSize: TabBarIndicatorSize.label,
                                tabAlignment: TabAlignment.start,
                                isScrollable: true,
                                onTap: (value) {
                                  pageController.animateToPage(
                                    value,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                },
                                controller: controller,
                                tabs: healthActionEntryProvider.years
                                    .map(
                                      (year) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: RefractedText(text: year),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        setHeight(20), // Spacing between widgets
                        // Main title for the Health Action Plan
                        SvgImage(
                          svgPath: 'bookmark',
                          svgHeight: 27.04,
                          svgWidth: 27.05,
                          packageName: widget.packageName,
                        ),
                        setHeight(10),
                        Text(
                          "Your Health\nAction Plan",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: AppColors.buttonBlue),
                        ),
                        setHeight(8), // Spacing between widgets
                        // Subtitle with a brief description of the plan
                        Text(
                          "Based on your discussion with your Nura Doctor, here is our recommended plan to get your health back on track.",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppColors.buttonBlue),
                        ),
                        setHeight(8),

                        // Container displaying the physician's note
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: PageView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            controller: pageController,
                            itemCount: healthActionEntryProvider.years.length,
                            onPageChanged: (value) {
                              if (controller != null &&
                                  controller!.length > value) {
                                controller!.animateTo(value);
                              }
                            },
                            itemBuilder: (context, index) {
                              final year =
                                  healthActionEntryProvider.years[index];
                              final notes =
                                  healthActionEntryProvider
                                      .healthActionModel
                                      .data
                                      ?.expand(
                                        (e) =>
                                            e.physicianNotesByYear?[year] ??
                                            <PhysicianNote>[],
                                      )
                                      .toList() ??
                                  [];

                              if (notes.isEmpty) {
                                return const EmptyReports();
                              }

                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                itemCount: notes.length,
                                itemBuilder: (context, noteIndex) {
                                  final note = notes[noteIndex];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 60),
                                    child: Container(
                                      padding: const EdgeInsets.all(32),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundBlueLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          // Section title for the physician's note
                                          Text(
                                            "Physician’s Note",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.buttonBlue,
                                                ),
                                          ),
                                          setHeight(8),

                                          // Actual content of the physician's note
                                          (note.physicianNotes?.isEmpty ?? true)
                                              ? const SizedBox.shrink()
                                              : Text(
                                                  note.physicianNotes ?? "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .physicianNotesLight,
                                                      ),
                                                ),
                                          setHeight(16),

                                          // Signature of the physician
                                          (note.doctorName?.isNotEmpty ?? false)
                                              ? Text(
                                                  (note
                                                              .qualification
                                                              ?.isNotEmpty ??
                                                          false)
                                                      ? '${note.doctorName}, ${note.qualification}'
                                                      : '${note.doctorName}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .buttonBlue,
                                                      ),
                                                )
                                              : const SizedBox(),

                                          // Physician's title and registration number
                                          (note.designation?.isEmpty ?? true)
                                              ? const SizedBox.shrink()
                                              : Text(
                                                  note.designation!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        color: AppColors
                                                            .buttonBlue,
                                                      ),
                                                ),
                                          (note.registrationNo?.isEmpty ?? true)
                                              ? const SizedBox.shrink()
                                              : Text(
                                                  note.registrationNo!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        color: AppColors
                                                            .buttonBlue,
                                                      ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
