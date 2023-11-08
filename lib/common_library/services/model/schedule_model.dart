class GetScheduleResponse {
  List<TrainerSchedule>? trainerSchedule;

  GetScheduleResponse({this.trainerSchedule});

  GetScheduleResponse.fromJson(Map<String, dynamic> json){
    if (json['TimeTable'] != null) {
      trainerSchedule = <TrainerSchedule>[];
      json['TimeTable'].forEach((v) {
        trainerSchedule!.add(TrainerSchedule.fromJson(v));
      });
    }
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (trainerSchedule != null) {
      data['TimeTable'] = trainerSchedule!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrainerSchedule{
  String? iD;
  String? merchantNo;
  String? timeTableNo;
  String? trnCode;
  String? icNo;
  String? groupId;
  String? vehNo;
  String? courseCode;
  String? startDate;
  String? endDate;
  String? totalHr;
  String? subject;
  String? remark;
  String? transtamp;
  String? lastUpload;
  String? compCode;
  String? branchCode;
  String? rowKey;
  String? createUser;
  String? createDate;
  String? editUser;
  String? editDate;
  String? deleted;
  String? approveUser;
  String? cancelUser;
  String? cancelDate;
  String? name;
  String? add1;
  String? add2;
  String? add3;
  String? state;
  String? city;
  String? zip;

  TrainerSchedule({
    this.trnCode,
    this.iD,
    this.merchantNo,
    this.timeTableNo,
    this.icNo,
    this.groupId,
    this.vehNo,
    this.courseCode,
    this.startDate,
    this.endDate,
    this.totalHr,
    this.subject,
    this.remark,
    this.transtamp,
    this.lastUpload,
    this.compCode,
    this.branchCode,
    this.rowKey,
    this.createUser,
    this.createDate,
    this.editUser,
    this.editDate,
    this.deleted,
    this.approveUser,
    this.cancelUser,
    this.cancelDate,
    this.name,
    this.add1,
    this.add2,
    this.add3,
    this.state,
    this.city,
    this.zip,
  });

  TrainerSchedule.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    merchantNo = json['merchant_no'];
    timeTableNo = json['time_table_no'];
    trnCode = json['trn_code'];
    icNo = json['ic_no'];
    groupId = json['group_id'];
    vehNo = json['veh_no'];
    courseCode = json['course_code'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalHr = json['total_hr'];
    subject = json['subject'];
    remark = json['remark'];
    transtamp = json['transtamp'];
    lastUpload = json['lastupload'];
    compCode = json['comp_code'];
    branchCode = json['branch_code'];
    rowKey = json['row_key'];
    createUser = json['create_user'];
    createDate = json['create_date'];
    editUser = json['edit_user'];
    editDate = json['edit_date'];
    deleted = json['deleted'];
    approveUser = json['approve_user'];
    cancelUser = json['cancel_user'];
    cancelDate = json['cancel_date'];
    name = json['name'];
    add1 = json['add1'];
    add2 = json['add2'];
    add3 = json['add3'];
    state = json['state'];
    city = json['city'];
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['merchant_no'] = merchantNo;
    data['time_table_no'] = timeTableNo;
    data['trn_code'] = trnCode;
    data['ic_no'] = icNo;
    data['group_id'] = groupId;
    data['veh_no'] = vehNo;
    data['course_code'] = courseCode;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['total_hr'] = totalHr;
    data['subject'] = subject;
    data['remark'] = remark;
    data['transtamp'] = transtamp;
    data['lastupload'] = lastUpload;
    data['comp_code'] = compCode;
    data['branch_code'] = branchCode;
    data['row_key'] = rowKey;
    data['create_user'] = createUser;
    data['create_date'] = createDate;
    data['edit_user'] = editUser;
    data['edit_date'] = editDate;
    data['deleted'] = deleted;
    data['approve_user'] = approveUser;
    data['cancel_user'] = cancelUser;
    data['cancel_date'] = cancelDate;
    data['name'] = name;
    data['add1'] = add1;
    data['add2'] = add2;
    data['add3'] = add3;
    data['state'] = state;
    data['city'] = city;
    data['zip'] = zip;
    return data;
  }
}