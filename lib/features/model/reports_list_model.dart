// To parse this JSON data, do
//
//     final reportSummaryModel = reportSummaryModelFromJson(jsonString?);

import 'dart:convert';

ReportSummaryModel reportSummaryModelFromJson(String? str) =>
    ReportSummaryModel.fromJson(json.decode(str!));

String? reportSummaryModelToJson(ReportSummaryModel data) =>
    json.encode(data.toJson());

class ReportSummaryModel {
  int? statusCode;
  String? message;
  bool? success;
  List<Response>? response;

  ReportSummaryModel({
    this.statusCode,
    this.message,
    this.success,
    this.response,
  });

  factory ReportSummaryModel.fromJson(Map<String?, dynamic> json) =>
      ReportSummaryModel(
        statusCode: json["statusCode"],
        message: json["message"],
        success: json["success"],
        response: List<Response>.from(
          json["response"].map((x) => Response.fromJson(x)),
        ),
      );

  Map<String?, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "success": success,
        "response": List<dynamic>.from(response!.map((x) => x.toJson())),
      };

  String get latestOpBill {
    if (response == null) {
      return "";
    }

    if (response!.isEmpty) {
      return "";
    }

    return response![0].opBill!.opbId ?? "";
  }
}

class Response {
  OpBill? opBill;
  Report? report;
  List<SubReport>? subReports;

  Response({
    this.opBill,
    this.report,
    this.subReports,
  });

  factory Response.fromJson(Map<String?, dynamic> json) => Response(
        opBill: OpBill.fromJson(json["opBill"]),
        report: Report.fromJson(json["report"]),
        subReports: List<SubReport>.from(
          json["sub_reports"].map((x) => SubReport.fromJson(x)),
        ),
      );

  Map<String?, dynamic> toJson() => {
        "opBill": opBill!.toJson(),
        "report": report!.toJson(),
        "sub_reports": List<dynamic>.from(subReports!.map((x) => x.toJson())),
      };
}

class OpBill {
  String? branch;
  String? opbId;
  String? opbMode;
  String? opbBtype;
  String? opbBno;
  DateTime? opbDt;
  DateTime? opbTm;
  String? opbOpno;
  String? opbOpid;
  String? opbIpno;
  String? opbName;
  String? opbAdd1;
  String? opbAdd2;
  String? opbPlace;
  String? opbGender;
  String? opbAge;
  String? opbPatcatptr;
  String? opbDoctorptr;
  String? opbReferrerptr;
  int? opbAmt;
  int? opbTaxmainamt;
  int? opbTaxcessamt;
  int? opbTaxamt;
  int? opbBdisper;
  int? opbBdisamt;
  int? opbDisamt;
  int? opbRndamt;
  int? opbNetamt;
  String? opbUser;
  String? opbUserid;
  int? opbShiftno;
  DateTime? opbShiftdt;
  String? opbCanflg;
  dynamic opbCanuser;
  dynamic opbCanuserid;
  dynamic opbCantime;
  dynamic opbCanremarks;
  dynamic opbCanshiftno;
  dynamic opbCanshiftdt;
  int? opbFinyearid;
  String? opbRemarks;
  String? opbPaidflg;
  int? opbPaidamt;
  String? opbRefundflg;
  int? opbRefundamt;
  dynamic opbIscrdrcard;
  String? opbMobile;
  String? opbEmail;
  String? opbWebuser;
  String? opbWebpwd;
  dynamic opbCorporateptr;
  dynamic opbLatebdisamt;
  dynamic opbCorporateamt;
  int? opbCorpamt;
  int? opbPatamt;
  dynamic opbDeptmode;
  dynamic opbCorpinsrpolno;
  dynamic opbCorpinsrcertno;
  dynamic opbCorpinsrexpdt;
  dynamic opbBtypeothmode;
  String? opbClinicalinform;
  dynamic opbReportlink;
  String? opbBranchptr;
  String? opbFirmptr;

  OpBill({
    this.branch,
    this.opbId,
    this.opbMode,
    this.opbBtype,
    this.opbBno,
    this.opbDt,
    this.opbTm,
    this.opbOpno,
    this.opbOpid,
    this.opbIpno,
    this.opbName,
    this.opbAdd1,
    this.opbAdd2,
    this.opbPlace,
    this.opbGender,
    this.opbAge,
    this.opbPatcatptr,
    this.opbDoctorptr,
    this.opbReferrerptr,
    this.opbAmt,
    this.opbTaxmainamt,
    this.opbTaxcessamt,
    this.opbTaxamt,
    this.opbBdisper,
    this.opbBdisamt,
    this.opbDisamt,
    this.opbRndamt,
    this.opbNetamt,
    this.opbUser,
    this.opbUserid,
    this.opbShiftno,
    this.opbShiftdt,
    this.opbCanflg,
    this.opbCanuser,
    this.opbCanuserid,
    this.opbCantime,
    this.opbCanremarks,
    this.opbCanshiftno,
    this.opbCanshiftdt,
    this.opbFinyearid,
    this.opbRemarks,
    this.opbPaidflg,
    this.opbPaidamt,
    this.opbRefundflg,
    this.opbRefundamt,
    this.opbIscrdrcard,
    this.opbMobile,
    this.opbEmail,
    this.opbWebuser,
    this.opbWebpwd,
    this.opbCorporateptr,
    this.opbLatebdisamt,
    this.opbCorporateamt,
    this.opbCorpamt,
    this.opbPatamt,
    this.opbDeptmode,
    this.opbCorpinsrpolno,
    this.opbCorpinsrcertno,
    this.opbCorpinsrexpdt,
    this.opbBtypeothmode,
    this.opbClinicalinform,
    this.opbReportlink,
    this.opbBranchptr,
    this.opbFirmptr,
  });

  factory OpBill.fromJson(Map<String?, dynamic> json) => OpBill(
        branch: json["branch"],
        opbId: (json["opb_id"])?.toString() ?? "",
        opbMode: json["opb_mode"],
        opbBtype: json["opb_btype"],
        opbBno: json["opb_bno"],
        opbDt: json["opb_dt"] != null
    ? DateTime.parse(json["opb_dt"])
    : null,
        opbTm: DateTime.parse(json["opb_tm"]),
        opbOpno: json["opb_opno"],
        opbOpid: json["opb_opid"],
        opbIpno: json["opb_ipno"],
        opbName: json["opb_name"],
        opbAdd1: json["opb_add1"],
        opbAdd2: json["opb_add2"],
        opbPlace: json["opb_place"],
        opbGender: json["opb_gender"],
        opbAge: json["opb_age"],
        opbPatcatptr: json["opb_patcatptr"],
        opbDoctorptr: json["opb_doctorptr"],
        opbReferrerptr: json["opb_referrerptr"],
        opbAmt: json["opb_amt"],
        opbTaxmainamt: json["opb_taxmainamt"],
        opbTaxcessamt: json["opb_taxcessamt"],
        opbTaxamt: json["opb_taxamt"],
        opbBdisper: json["opb_bdisper"],
        opbBdisamt: json["opb_bdisamt"],
        opbDisamt: json["opb_disamt"],
        opbRndamt: json["opb_rndamt"],
        opbNetamt: json["opb_netamt"],
        opbUser: json["opb_user"],
        opbUserid: json["opb_userid"],
        opbShiftno: json["opb_shiftno"],
        opbShiftdt: DateTime.parse(json["opb_shiftdt"]),
        opbCanflg: json["opb_canflg"],
        opbCanuser: json["opb_canuser"],
        opbCanuserid: json["opb_canuserid"],
        opbCantime: json["opb_cantime"],
        opbCanremarks: json["opb_canremarks"],
        opbCanshiftno: json["opb_canshiftno"],
        opbCanshiftdt: json["opb_canshiftdt"],
        opbFinyearid: json["opb_finyearid"],
        opbRemarks: json["opb_remarks"],
        opbPaidflg: json["opb_paidflg"],
        opbPaidamt: json["opb_paidamt"],
        opbRefundflg: json["opb_refundflg"],
        opbRefundamt: json["opb_refundamt"],
        opbIscrdrcard: json["opb_iscrdrcard"],
        opbMobile: json["opb_mobile"],
        opbEmail: json["opb_email"],
        opbWebuser: json["opb_webuser"],
        opbWebpwd: json["opb_webpwd"],
        opbCorporateptr: json["opb_corporateptr"],
        opbLatebdisamt: json["opb_latebdisamt"],
        opbCorporateamt: json["opb_corporateamt"],
        opbCorpamt: json["opb_corpamt"],
        opbPatamt: json["opb_patamt"],
        opbDeptmode: json["opb_deptmode"],
        opbCorpinsrpolno: json["opb_corpinsrpolno"],
        opbCorpinsrcertno: json["opb_corpinsrcertno"],
        opbCorpinsrexpdt: json["opb_corpinsrexpdt"],
        opbBtypeothmode: json["opb_btypeothmode"],
        opbClinicalinform: json["opb_clinicalinform"],
        opbReportlink: json["opb_reportlink"],
        opbBranchptr: json["opb_branchptr"],
        opbFirmptr: json["opb_firmptr"],
      );

  Map<String?, dynamic> toJson() => {
        "branch": branch,
        "opb_id": opbId,
        "opb_mode": opbMode,
        "opb_btype": opbBtype,
        "opb_bno": opbBno,
        "opb_dt": opbDt?.toIso8601String(),
        "opb_tm": opbTm?.toIso8601String(),
        "opb_opno": opbOpno,
        "opb_opid": opbOpid,
        "opb_ipno": opbIpno,
        "opb_name": opbName,
        "opb_add1": opbAdd1,
        "opb_add2": opbAdd2,
        "opb_place": opbPlace,
        "opb_gender": opbGender,
        "opb_age": opbAge,
        "opb_patcatptr": opbPatcatptr,
        "opb_doctorptr": opbDoctorptr,
        "opb_referrerptr": opbReferrerptr,
        "opb_amt": opbAmt,
        "opb_taxmainamt": opbTaxmainamt,
        "opb_taxcessamt": opbTaxcessamt,
        "opb_taxamt": opbTaxamt,
        "opb_bdisper": opbBdisper,
        "opb_bdisamt": opbBdisamt,
        "opb_disamt": opbDisamt,
        "opb_rndamt": opbRndamt,
        "opb_netamt": opbNetamt,
        "opb_user": opbUser,
        "opb_userid": opbUserid,
        "opb_shiftno": opbShiftno,
        "opb_shiftdt": opbShiftdt?.toIso8601String(),
        "opb_canflg": opbCanflg,
        "opb_canuser": opbCanuser,
        "opb_canuserid": opbCanuserid,
        "opb_cantime": opbCantime,
        "opb_canremarks": opbCanremarks,
        "opb_canshiftno": opbCanshiftno,
        "opb_canshiftdt": opbCanshiftdt,
        "opb_finyearid": opbFinyearid,
        "opb_remarks": opbRemarks,
        "opb_paidflg": opbPaidflg,
        "opb_paidamt": opbPaidamt,
        "opb_refundflg": opbRefundflg,
        "opb_refundamt": opbRefundamt,
        "opb_iscrdrcard": opbIscrdrcard,
        "opb_mobile": opbMobile,
        "opb_email": opbEmail,
        "opb_webuser": opbWebuser,
        "opb_webpwd": opbWebpwd,
        "opb_corporateptr": opbCorporateptr,
        "opb_latebdisamt": opbLatebdisamt,
        "opb_corporateamt": opbCorporateamt,
        "opb_corpamt": opbCorpamt,
        "opb_patamt": opbPatamt,
        "opb_deptmode": opbDeptmode,
        "opb_corpinsrpolno": opbCorpinsrpolno,
        "opb_corpinsrcertno": opbCorpinsrcertno,
        "opb_corpinsrexpdt": opbCorpinsrexpdt,
        "opb_btypeothmode": opbBtypeothmode,
        "opb_clinicalinform": opbClinicalinform,
        "opb_reportlink": opbReportlink,
        "opb_branchptr": opbBranchptr,
        "opb_firmptr": opbFirmptr,
      };
}

class Report {
  String? indexSub;
  int? scrreptId;
  String? scrreptOpno;
  String? scrreptReportmasptr;
  int? scrreptReferenceid;
  String? scrreptReferenceno;
  String? scrreptFilename;
  DateTime? scrreptDate;
  DateTime? scrreptTime;
  String? scrreptUser;
  DateTime? scrreptUpdttm;
  String? scrreptOtherdetails2;

  String? srepmCode;
  String? srepmDesc;
  String? srepmOtherdet1;
  dynamic srepmOtherdet2;
  String? type;

  Report({
    this.indexSub,
    this.scrreptId,
    this.scrreptOpno,
    this.scrreptReportmasptr,
    this.scrreptReferenceid,
    this.scrreptReferenceno,
    this.scrreptFilename,
    this.scrreptDate,
    this.scrreptTime,
    this.scrreptUser,
    this.scrreptUpdttm,
    this.scrreptOtherdetails2,
    this.srepmCode,
    this.srepmDesc,
    this.srepmOtherdet1,
    this.srepmOtherdet2,
    this.type,
  });

  factory Report.fromJson(Map<String?, dynamic> json) => Report(
        indexSub: json["index_sub"],
        scrreptId: json["scrrept_id"],
        scrreptOpno: json["scrrept_opno"],
        scrreptReportmasptr: json["scrrept_reportmasptr"],
        scrreptReferenceid: json["scrrept_referenceid"],
        scrreptReferenceno: json["scrrept_referenceno"],
        scrreptFilename: json["scrrept_filename"],
        scrreptDate: DateTime.parse(json["scrrept_date"]),
        scrreptTime: DateTime.parse(json["scrrept_time"]),
        scrreptUser: json["scrrept_user"],
        scrreptUpdttm: DateTime.parse(json["scrrept_updttm"]),
        scrreptOtherdetails2: json["scrrept_otherdetails2"],
        srepmCode: json["srepm_code"],
        srepmDesc: json["srepm_desc"],
        srepmOtherdet1: json["srepm_otherdet1"],
        srepmOtherdet2: json["srepm_otherdet2"],
        type: json["type"],
      );

  Map<String?, dynamic> toJson() => {
        "index_sub": indexSub,
        "scrrept_id": scrreptId,
        "scrrept_opno": scrreptOpno,
        "scrrept_reportmasptr": scrreptReportmasptr,
        "scrrept_referenceid": scrreptReferenceid,
        "scrrept_referenceno": scrreptReferenceno,
        "scrrept_filename": scrreptFilename,
        "scrrept_date": scrreptDate?.toIso8601String(),
        "scrrept_time": scrreptTime?.toIso8601String(),
        "scrrept_user": scrreptUser,
        "scrrept_updttm": scrreptUpdttm?.toIso8601String(),
        "scrrept_otherdetails2": scrreptOtherdetails2,
        "srepm_code": srepmCode,
        "srepm_desc": srepmDesc,
        "srepm_otherdet1": srepmOtherdet1,
        "srepm_otherdet2": srepmOtherdet2,
        "type": type,
      };
}

class SubReport {
  String? scrreptdId;
  String? scrreptdHdrid;
  int? scrreptdReportmasptr;
  String? scrreptdReferenceid;
  String? scrreptdReferenceno;
  String? scrreptdFilename;
  DateTime? scrreptdDate;
  DateTime? scrreptdTime;
  int? scrreptdSlno;
  String? scrreptdUser;
  DateTime? scrreptdUpdttm;
  int? srepmdId;
  String? srepmdDesc;
  String? srepmdFiletype;

  SubReport({
    this.scrreptdId,
    this.scrreptdHdrid,
    this.scrreptdReportmasptr,
    this.scrreptdReferenceid,
    this.scrreptdReferenceno,
    this.scrreptdFilename,
    this.scrreptdDate,
    this.scrreptdTime,
    this.scrreptdSlno,
    this.scrreptdUser,
    this.scrreptdUpdttm,
    this.srepmdId,
    this.srepmdDesc,
    this.srepmdFiletype,
  });

  factory SubReport.fromJson(Map<String?, dynamic> json) => SubReport(
        scrreptdId: (json["scrreptd_id"])?.toString() ?? "",
        scrreptdHdrid: json["scrreptd_hdrid"],
        scrreptdReportmasptr: json["scrreptd_reportmasptr"],
        scrreptdReferenceid: (json["scrreptd_referenceid"])?.toString() ?? "",
        scrreptdReferenceno: json["scrreptd_referenceno"],
        scrreptdFilename: json["scrreptd_filename"],
        scrreptdDate: DateTime.parse(json["scrreptd_date"]),
        scrreptdTime: DateTime.parse(json["scrreptd_time"]),
        scrreptdSlno: json["scrreptd_slno"],
        scrreptdUser: json["scrreptd_user"],
        scrreptdUpdttm: DateTime.parse(json["scrreptd_updttm"]),
        srepmdId: json["srepmd_id"],
        srepmdDesc: json["srepmd_desc"],
        srepmdFiletype: json["srepmd_filetype"],
      );

  Map<String?, dynamic> toJson() => {
        "scrreptd_id": scrreptdId,
        "scrreptd_hdrid": scrreptdHdrid,
        "scrreptd_reportmasptr": scrreptdReportmasptr,
        "scrreptd_referenceid": scrreptdReferenceid,
        "scrreptd_referenceno": scrreptdReferenceno,
        "scrreptd_filename": scrreptdFilename,
        "scrreptd_date": scrreptdDate?.toIso8601String(),
        "scrreptd_time": scrreptdTime?.toIso8601String(),
        "scrreptd_slno": scrreptdSlno,
        "scrreptd_user": scrreptdUser,
        "scrreptd_updttm": scrreptdUpdttm?.toIso8601String(),
        "srepmd_id": srepmdId,
        "srepmd_desc": srepmdDesc,
        "srepmd_filetype": srepmdFiletype,
      };
}
