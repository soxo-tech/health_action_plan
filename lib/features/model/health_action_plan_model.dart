import 'dart:convert';

HealthActionModel healthActionModelFromJson(String str) =>
    HealthActionModel.fromJson(json.decode(str));

String healthActionModelToJson(HealthActionModel data) =>
    json.encode(data.toJson());

class HealthActionModel {
  int? statusCode;
  bool? success;
  List<Datum>? data;

  HealthActionModel({
    this.statusCode,
    this.success,
    this.data,
  });

  factory HealthActionModel.fromJson(Map<String, dynamic> json) =>
      HealthActionModel(
        statusCode: json["statusCode"],
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? guestId;
  Map<String, List<PhysicianNote>>? physicianNotesByYear;

  Datum({
    this.guestId,
    this.physicianNotesByYear,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        guestId: json["guest_id"],
        physicianNotesByYear: json["physician_notes_by_year"] == null
            ? {}
            : Map.from(json["physician_notes_by_year"]).map(
                (k, v) => MapEntry<String, List<PhysicianNote>>(
                    k,
                    List<PhysicianNote>.from(
                        v.map((x) => PhysicianNote.fromJson(x)),),),),
      );

  Map<String, dynamic> toJson() => {
        "guest_id": guestId,
        "physician_notes_by_year": physicianNotesByYear == null
            ? {}
            : Map.from(physicianNotesByYear!).map(
                (k, v) => MapEntry<String, dynamic>(
                    k, List<dynamic>.from(v.map((x) => x.toJson())),),),
      };
}

class PhysicianNote {
  String? screeningDate;
  String? physicianNotes;
  String? doctorName;
  String? designation;
  String? qualification;
  String? registrationNo;

  PhysicianNote({
    this.screeningDate,
    this.physicianNotes,
    this.doctorName,
    this.designation,
    this.qualification,
    this.registrationNo,
  });

  factory PhysicianNote.fromJson(Map<String, dynamic> json) => PhysicianNote(
        screeningDate: json["screening_date"],
        physicianNotes: json["physician_notes"],
        doctorName: json["doctor_name"] ?? json["doctor name"], // handles both key names
        designation: json["designation"],
        qualification: json["qualification"],
        registrationNo: json["registration_no"],
      );

  Map<String, dynamic> toJson() => {
        "screening_date": screeningDate,
        "physician_notes": physicianNotes,
        "doctor_name": doctorName,
        "designation": designation,
        "qualification": qualification,
        "registration_no": registrationNo,
      };
}
