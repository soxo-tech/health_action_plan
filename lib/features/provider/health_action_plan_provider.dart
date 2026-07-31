import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:health_action_plan/features/core/env.dart';
import 'package:health_action_plan/features/model/health_action_plan_model.dart';
import 'package:health_action_plan/features/model/reports_list_model.dart';
import 'package:health_action_plan/features/services/security_service/secure_fetch.dart';

/// Manages the health score data.
class HealthActionPlanProvider extends ChangeNotifier {
  bool isHealthActiondataLoading = true;
  bool isHealthActiondataAvailable = false;

  HealthActionModel healthActionModel = HealthActionModel();
  List<SubReport> subReports = [];

  /// List of yearsextracted from the health action plan data
  List<String> years = [];

  Future<void> getHealthActionPlan(String opno) async {
    isHealthActiondataLoading = true;
    isHealthActiondataAvailable = false;
    notifyListeners();

    try {
     final response = await secureFetch(
        method: 'GET',
        endpoint: Env().healthActionPlanAPI(opno),
      );

      final json = response?.data;
      log('Health Action Plan: $json');

      if (json == null || json['response'] == 'No data found') {
        log('No health action plan available for $opno');
        isHealthActiondataAvailable = false;
      } else {
        healthActionModel = HealthActionModel.fromJson(json);

        // Extract and store years here
        final data = healthActionModel.data ?? [];
        if (data.isNotEmpty && data.first.physicianNotesByYear != null) {
          years = data.first.physicianNotesByYear!.keys.toList();
        } else {
          years = [];
        }

        log('Extracted years: $years');
        isHealthActiondataAvailable = true;
      }
    } catch (e) {
      log('Error fetching reports: $e');
      isHealthActiondataAvailable = false;
    } finally {
      isHealthActiondataLoading = false;
      notifyListeners();
    }
  }

  bool hasNoPhysicianNotes() {
    final data = healthActionModel.data;
    if (data == null || data.isEmpty) return true;

    // Loop through all data and all years
    for (final item in data) {
      final notesByYear = item.physicianNotesByYear;
      if (notesByYear != null) {
        for (final notes in notesByYear.values) {
          if (notes.isNotEmpty) {
            return false; // Found at least one note
          }
        }
      }
    }
    return true; // No notes found anywhere
  }
}
