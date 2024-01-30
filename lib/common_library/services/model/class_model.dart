class GetProgressClassResponse{
  List<ProgressClassList>? progressClassList;

  GetProgressClassResponse({this.progressClassList});

  GetProgressClassResponse.fromJson(Map<String, dynamic> json){
    if (json['StuPrac'] != null) {
      progressClassList = <ProgressClassList>[];
      json['StuPrac'].forEach((v) {
        progressClassList!.add(ProgressClassList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    if(progressClassList != null){
      data['StuPrac'] = progressClassList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProgressClassList{
  String? id;
	String? merchantNo;
	String? icNo;
	String? stuNo;
	String? trandate;
	String? vehNo;
	String? trnCode;
	String? slipNo;
	String? sm4No;
	String? certNo;
	String? groupId;
	String? kppGroupId;
	String? kppGroupId2;
	String? kppGroupId3;
	String? classes;
	String? bgTime;
	String? endTime;
	String? employeNo;
	String? remark;
	String? dsCode;
	String? pracType;
	String? sysTime;
	String? closeUser;
	String? closeDate;
	String? epretCode;
	String? epretReqid;
	String? ekppCode;
	String? ekppReqid;
	String? transtamp;
	String? actBgTime;
	String? actEndTime;
	String? byFingerprn;
	String? ej2aTick;
	String? ej2aInd;
	String? ej2aStat;
	String? ej2bInd;
	String? ej2bTick;
	String? ej2bStat;
	String? snoBkpp;
	String? adminId1;
	String? actBgTime2;
	String? classCode;
	String? verifyTrncode;
	String? actEndTime2;
	String? ej2aRemark;
	String? ej2bRemark;
	String? entryType;
	String? sjlprndate;
	String? issueSjDate;
	String? courseCode;
	String? location;
	String? theoryType;
	String? totalTime;
	String? kpp02CertNo;
	String? kpp02IssueSjDate;
	String? kpp02Sjlprndate;
	String? sessionTotalTime;
	String? compCode;
	String? branchCode;
	String? rowKey;
	String? lastupload;
	String? deleted;
	String? diCode;

  ProgressClassList({
    this.id, 
    this.merchantNo, 
    this.icNo, 
    this.stuNo, 
    this.trandate, 
    this.vehNo, 
    this.trnCode, 
    this.slipNo, 
    this.sm4No, 
    this.certNo, 
    this.groupId, 
    this.kppGroupId, 
    this.kppGroupId2, 
    this.kppGroupId3, 
    this.classes, 
    this.bgTime, 
    this.endTime, 
    this.employeNo, 
    this.remark, 
    this.dsCode, 
    this.pracType, 
    this.sysTime, 
    this.closeUser, 
    this.closeDate, 
    this.epretCode, 
    this.epretReqid, 
    this.ekppCode, 
    this.ekppReqid, 
    this.transtamp, 
    this.actBgTime, 
    this.actEndTime, 
    this.byFingerprn, 
    this.ej2aTick, 
    this.ej2aInd, 
    this.ej2aStat, 
    this.ej2bInd, 
    this.ej2bTick, 
    this.ej2bStat, 
    this.snoBkpp, 
    this.adminId1, 
    this.actBgTime2, 
    this.classCode, 
    this.verifyTrncode, 
    this.actEndTime2, 
    this.ej2aRemark, 
    this.ej2bRemark, 
    this.entryType, 
    this.sjlprndate, 
    this.issueSjDate, 
    this.courseCode, 
    this.location,
    this.theoryType, 
    this.totalTime, 
    this.kpp02CertNo, 
    this.kpp02IssueSjDate,
    this.kpp02Sjlprndate, 
    this.sessionTotalTime, 
    this.compCode, 
    this.branchCode, 
    this.rowKey, 
    this.lastupload, 
    this.deleted, 
    this.diCode
  });

  ProgressClassList.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
		merchantNo = json['merchant_no'] ?? '';
		icNo = json['ic_no'] ?? '';
		stuNo = json['stu_no'] ?? '';
		trandate = json['trandate'];
		vehNo = json['veh_no'] ?? '';
		trnCode = json['trn_code'] ?? '';
		slipNo = json['slip_no'] ?? '';
		sm4No = json['sm4_no'] ?? '';
		certNo = json['cert_no'] ?? '';
		groupId = json['group_id'] ?? '';
		kppGroupId = json['kpp_group_id'] ?? '';
		kppGroupId2 = json['kpp_group_id_2'] ?? '';
		kppGroupId3 = json['kpp_group_id_3'] ?? '';
		classes = json['class'] ?? '';
		bgTime = json['bg_time'] ?? '';
		endTime = json['end_time'] ?? '';
		employeNo = json['employe_no'] ?? '';
		remark = json['remark'] ?? '';
		dsCode = json['ds_code'] ?? '';
		pracType = json['prac_type'] ?? '';
		sysTime = json['sys_time'] ?? '';
		closeUser = json['close_user'] ?? '';
		closeDate = json['close_date'];
		epretCode = json['epret_code'] ?? '';
		epretReqid = json['epret_reqid'] ?? '';
		ekppCode = json['ekpp_code'] ?? '';
		ekppReqid = json['ekpp_reqid'] ?? '';
		transtamp = json['transtamp'];
		actBgTime = json['act_bg_time'] ?? '';
		actEndTime = json['act_end_time'] ?? '';
		byFingerprn = json['by_fingerprn'] ?? '';
		ej2aTick = json['ej2a_tick'] ?? '';
		ej2aInd = json['ej2a_ind'] ?? '';
		ej2aStat = json['ej2a_stat'] ?? '';
		ej2bInd = json['ej2b_ind'] ?? '';
		ej2bTick = json['ej2b_tick'] ?? '';
		ej2bStat = json['ej2b_stat'] ?? '';
		snoBkpp = json['sno_bkpp'] ?? '';
		adminId1 = json['admin_id1'] ?? '';
		actBgTime2 = json['act_bg_time2'] ?? '';
		classCode = json['class_code'] ?? '';
		verifyTrncode = json['verify_trncode'] ?? '';
		actEndTime2 = json['act_end_time2'] ?? '';
		ej2aRemark = json['ej2a_remark'] ?? '';
		ej2bRemark = json['ej2b_remark'] ?? '';
		entryType = json['entry_type'] ?? '';
		sjlprndate = json['sjlprndate'];
		issueSjDate = json['issue_sj_date'];
		courseCode = json['course_code'] ?? '';
		location = json['location'] ?? '';
		theoryType = json['theory_type'] ?? '';
		totalTime = json['total_time'];
		kpp02CertNo = json['kpp02_cert_no'] ?? '';
		kpp02IssueSjDate = json['kpp02_issue_sj_date'];
		kpp02Sjlprndate = json['kpp02_sjlprndate'];
		sessionTotalTime = json['session_total_time'] ?? '';
		compCode = json['comp_code'] ?? '';
		branchCode = json['branch_code'] ?? '';
		rowKey = json['row_key'] ?? '';
		lastupload = json['lastupload'] ?? '';
		deleted = json['deleted'];
		diCode = json['di_code'] ?? '';
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
		data['merchant_no'] = merchantNo;
		data['ic_no'] = icNo;
		data['stu_no'] = stuNo;
		data['trandate'] = trandate;
		data['veh_no'] = vehNo;
		data['trn_code'] = trnCode;
		data['slip_no'] = slipNo;
		data['sm4_no'] = sm4No;
		data['cert_no'] = certNo;
		data['group_id'] = groupId;
		data['kpp_group_id'] = kppGroupId;
		data['kpp_group_id_2'] = kppGroupId2;
		data['kpp_group_id_3'] = kppGroupId3;
		data['class'] = classes;
		data['bg_time'] = bgTime;
		data['end_time'] = endTime;
		data['employe_no'] = employeNo;
		data['remark'] = remark;
		data['ds_code'] = dsCode;
		data['prac_type'] = pracType;
		data['sys_time'] = sysTime;
		data['close_user'] = closeUser;
		data['close_date'] = closeDate;
		data['epret_code'] = epretCode;
		data['epret_reqid'] = epretReqid;
		data['ekpp_code'] = ekppCode;
		data['ekpp_reqid'] = ekppReqid;
		data['transtamp'] = transtamp;
		data['act_bg_time'] = actBgTime;
		data['act_end_time'] = actEndTime;
		data['by_fingerprn'] = byFingerprn;
		data['ej2a_tick'] = ej2aTick;
		data['ej2a_ind'] = ej2aInd;
		data['ej2a_stat'] = ej2aStat;
		data['ej2b_ind'] = ej2bInd;
		data['ej2b_tick'] = ej2bTick;
		data['ej2b_stat'] = ej2bStat;
		data['sno_bkpp'] = snoBkpp;
		data['admin_id1'] = adminId1;
		data['act_bg_time2'] = actBgTime2;
		data['class_code'] = classCode;
		data['verify_trncode'] = verifyTrncode;
		data['act_end_time2'] = actEndTime2;
		data['ej2a_remark'] = ej2aRemark;
		data['ej2b_remark'] = ej2bRemark;
		data['entry_type'] = entryType;
		data['sjlprndate'] = sjlprndate;
		data['issue_sj_date'] = issueSjDate;
		data['course_code'] = courseCode;
		data['location'] = location;
		data['theory_type'] = theoryType;
		data['total_time'] = totalTime;
		data['kpp02_cert_no'] = kpp02CertNo;
		data['kpp02_issue_sj_date'] = kpp02IssueSjDate;
		data['kpp02_sjlprndate'] = kpp02Sjlprndate;
		data['session_total_time'] = sessionTotalTime;
		data['comp_code'] = compCode;
		data['branch_code'] = branchCode;
		data['row_key'] = rowKey;
		data['lastupload'] = lastupload;
		data['deleted'] = deleted;
		data['di_code'] = diCode;
    return data;
  }
}

class DecryptQrcodeResponse {
  List<Table1>? table1;

  DecryptQrcodeResponse({this.table1});

  DecryptQrcodeResponse.fromJson(Map<String, dynamic> json) {
    if (json['Table1'] != null) {
      table1 = <Table1>[];
      json['Table1'].forEach((v) {
        table1!.add(Table1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (table1 != null) {
      data['Table1'] = table1!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Table1 {
  String? groupId;
  String? testCode;
  String? nricNo;
  String? merchantNo;
  String? carNo;
  String? plateNo;

  Table1(
      {this.groupId,
      this.testCode,
      this.nricNo,
      this.merchantNo,
      this.carNo,
      this.plateNo});

  Table1.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    testCode = json['test_code'];
    nricNo = json['nric_no'];
    merchantNo = json['merchant_no'];
    carNo = json['car_no'];
    plateNo = json['plate_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    data['test_code'] = testCode;
    data['nric_no'] = nricNo;
    data['merchant_no'] = merchantNo;
    data['car_no'] = carNo;
    data['plate_no'] = plateNo;
    return data;
  }
}

class GetTodayClassResponse{
  List<TodayClassList>? todayClassList;

  GetTodayClassResponse({this.todayClassList});

  GetTodayClassResponse.fromJson(Map<String, dynamic> json){
    if (json['TimeTable'] != null) {
      todayClassList = <TodayClassList>[];
      json['TimeTable'].forEach((v) {
        todayClassList!.add(TodayClassList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    if (todayClassList != null) {
      data['TimeTable'] = todayClassList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TodayClassList{
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
  String? lastupload;
  String? compCode;
  String? branchCode;
  String? rowKey;
  String? createUser;
  String? createDate;
  String? editUser;
  String? editDate;
  String? deleted;
  String? approveUser;
  String? pick;
  String? workSheetCode;
  String? cancelUser;
  String? cancelDate;
  String? name;
  String? add1;
  String? add2;
  String? add3;
  String? state;
  String? city;
  String? zip;
  String? handPhone;

  TodayClassList({
    this.iD,
    this.merchantNo,
    this.timeTableNo,
    this.trnCode,
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
    this.lastupload,
    this.compCode,
    this.branchCode,
    this.rowKey,
    this.createUser,
    this.createDate,
    this.editUser,
    this.editDate,
    this.deleted,
    this.approveUser,
    this.pick,
    this.workSheetCode,
    this.cancelUser,
    this.cancelDate,
    this.name,
    this.add1,
    this.add2,
    this.add3,
    this.state,
    this.city,
    this.zip,
    this.handPhone
  });

  TodayClassList.fromJson(Map<String, dynamic> json){
    iD = json['ID'] ?? '';
    merchantNo = json['merchant_no'] ?? '';
    timeTableNo = json['time_table_no'] ?? '';
    trnCode = json['trn_code'] ?? '';
    icNo = json['ic_no'] ?? '-';
    groupId = json['group_id'] ?? '-';
    vehNo = json['veh_no'] ?? '-';
    courseCode = json['course_code'] ?? '-';
    startDate = json['start_date'] ?? '';
    endDate = json['end_date'] ?? '';
    totalHr = json['total_hr'] ?? '';
    subject = json['subject'] ?? '';
    remark = json['remark'] ?? '';
    transtamp = json['transtamp'] ?? '';
    lastupload = json['lastupload'] ?? '';
    compCode = json['comp_code'] ?? '';
    branchCode = json['branch_code'] ?? '';
    rowKey = json['row_key'] ?? '';
    createUser = json['create_user'] ?? '';
    createDate = json['create_date'] ?? '';
    editUser = json['edit_user'] ?? '';
    editDate = json['edit_date'] ?? '';
    deleted = json['deleted'] ?? '';
    approveUser = json['approve_user'] ?? '';
    pick = json['pick'] ?? '';
    workSheetCode = json['work_sheet_code'] ?? '';
    cancelUser = json['cancel_user'] ?? '';
    cancelDate = json['cancel_date'] ?? '';
    name = json['name'] ?? '-';
    add1 = json['add1'] ?? '';
    add2 = json['add2'] ?? '';
    add3 = json['add3'] ?? '';
    state = json['state'] ?? '';
    city = json['city'] ?? '';
    zip = json['zip'] ?? '';
    handPhone = json['hand_phone'] ?? '-';
  }

  Map<String, dynamic> toJson(){
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
    data['lastupload'] = lastupload;
    data['comp_code'] = compCode;
    data['branch_code'] = branchCode;
    data['row_key'] = rowKey;
    data['create_user'] = createUser;
    data['create_date'] = createDate;
    data['edit_user'] = editUser;
    data['edit_date'] = editDate;
    data['deleted'] = deleted;
    data['approve_user'] = approveUser;
    data['pick'] = pick;
    data['work_sheet_code'] = workSheetCode;
    data['cancel_user'] = cancelUser;
    data['cancel_date'] = cancelDate;
    data['name'] = name;
    data['add1'] = add1;
    data['add2'] = add2;
    data['add3'] = add3;
    data['state'] = state;
    data['city'] = city;
    data['zip'] = zip;
    data['hand_phone'] = handPhone;
    return data;
  }
}

class GetStuPracResponse{
  List<CompleteClassList>? stuPrac;

  GetStuPracResponse({this.stuPrac});

  GetStuPracResponse.fromJson(Map<String, dynamic> json){
    if (json['StuPrac'] != null) {
      stuPrac = <CompleteClassList>[];
      json['StuPrac'].forEach((v) {
        stuPrac!.add(CompleteClassList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (stuPrac != null) {
      data['StuPrac'] = stuPrac!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetCompleteClassResponse{
  List<CompleteClassList>? completeClassList;

  GetCompleteClassResponse({this.completeClassList});

  GetCompleteClassResponse.fromJson(Map<String, dynamic> json){
    if (json['StuPrac'] != null) {
      completeClassList = <CompleteClassList>[];
      json['StuPrac'].forEach((v) {
        completeClassList!.add(CompleteClassList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    if (completeClassList != null) {
      data['StuPrac'] = completeClassList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompleteClassList{
  String? id;
	String? merchantNo;
	String? icNo;
	String? stuNo;
	String? trandate;
	String? vehNo;
	String? trnCode;
	String? slipNo;
	String? sm4No;
	String? certNo;
	String? groupId;
	String? kppGroupId;
	String? kppGroupId2;
	String? kppGroupId3;
	String? classes;
	String? bgTime;
	String? endTime;
	String? employeNo;
	String? remark;
	String? dsCode;
	String? pracType;
	String? sysTime;
	String? closeUser;
	String? closeDate;
	String? epretCode;
	String? epretReqid;
	String? ekppCode;
	String? ekppReqid;
	String? transtamp;
	String? actBgTime;
	String? actEndTime;
	String? byFingerprn;
	String? ej2aTick;
	String? ej2aInd;
	String? ej2aStat;
	String? ej2bInd;
	String? ej2bTick;
	String? ej2bStat;
	String? snoBkpp;
	String? adminId1;
	String? actBgTime2;
	String? classCode;
	String? verifyTrncode;
	String? actEndTime2;
	String? ej2aRemark;
	String? ej2bRemark;
	String? entryType;
	String? sjlprndate;
	String? issueSjDate;
	String? courseCode;
	String? location;
	String? theoryType;
	String? totalTime;
	String? kpp02CertNo;
	String? kpp02IssueSjDate;
	String? kpp02Sjlprndate;
	String? sessionTotalTime;
	String? compCode;
	String? branchCode;
	String? rowKey;
	String? lastupload;
  String? customerphoto;
  String? customerphotoFilename;
	String? deleted;
	String? diCode;
  String? iD1;
	String? icNo1;
	String? nric;
	String? oldIc;
	String? category;
	String? name;
	String? add1;
	String? add2;
	String? add3;
	String? state;
	String? city;
	String? zip;
	String? emailAddr;
	String? handPhone;
	String? homePhone;
	String? offPhone;
	String? off2Phone;
	String? sex;
	String? race;
	String? birthPl;
	String? birthDt;
	String? citizenship;
	String? customerPhoto;
	String? customerPhotoFilename;
	String? qGroup;
	String? hwyExpDt;
	String? pic1;
	String? pic2;
	String? pic3;
	String? remarks;
	String? edeclCode;
	String? edeclReqid;
	String? eregCode;
	String? eregReqid;
	String? ekppCode1;
	String? ekppReqid1;
	String? transtamp1;
	String? dsCode1;
	String? eregTick;
	String? eregStat;
	String? eregInd;
	String? pgaHukum;
	String? pgaGila;
	String? pgaCacat;
	String? pgaPitam;
	String? pgaMata;
	String? pgaLain;
	String? lainRemark;
	String? pgaTiada;
	String? eregRemark;
	String? smcCount;
	String? entryType1;
	String? racetext;
	String? gpsLatitude;
	String? gpsLongitude;
	String? gpsZip;
	String? pickup;
	String? compCode1;
	String? branchCode1;
	String? rowKey1;
	String? lastupload1;
	String? deleted1;
	String? diCode1;

  CompleteClassList({
    this.id, 
    this.merchantNo, 
    this.icNo, 
    this.stuNo, 
    this.trandate, 
    this.vehNo, 
    this.trnCode, 
    this.slipNo, 
    this.sm4No, 
    this.certNo, 
    this.groupId, 
    this.kppGroupId, 
    this.kppGroupId2, 
    this.kppGroupId3, 
    this.classes, 
    this.bgTime, 
    this.endTime, 
    this.employeNo, 
    this.remark, 
    this.dsCode, 
    this.pracType, 
    this.sysTime, 
    this.closeUser, 
    this.closeDate, 
    this.epretCode, 
    this.epretReqid, 
    this.ekppCode, 
    this.ekppReqid, 
    this.transtamp, 
    this.actBgTime, 
    this.actEndTime, 
    this.byFingerprn, 
    this.ej2aTick, 
    this.ej2aInd, 
    this.ej2aStat, 
    this.ej2bInd, 
    this.ej2bTick, 
    this.ej2bStat, 
    this.snoBkpp, 
    this.adminId1, 
    this.actBgTime2, 
    this.classCode, 
    this.verifyTrncode, 
    this.actEndTime2, 
    this.ej2aRemark, 
    this.ej2bRemark, 
    this.entryType, 
    this.sjlprndate, 
    this.issueSjDate, 
    this.courseCode, 
    this.location,
    this.theoryType, 
    this.totalTime, 
    this.kpp02CertNo, 
    this.kpp02IssueSjDate,
    this.kpp02Sjlprndate, 
    this.sessionTotalTime, 
    this.compCode, 
    this.branchCode, 
    this.rowKey, 
    this.lastupload, 
    this.customerphoto,
    this.customerphotoFilename,
    this.deleted, 
    this.diCode,
    this.iD1, 
    this.icNo1, 
    this.nric, 
    this.oldIc, 
    this.category,
    this.name, 
    this.add1, 
    this.add2, 
    this.add3, 
    this.state, 
    this.city, 
    this.zip, 
    this.emailAddr, 
    this.handPhone, 
    this.homePhone, 
    this.offPhone, 
    this.off2Phone, 
    this.sex, 
    this.race, 
    this.birthPl, 
    this.birthDt, 
    this.citizenship, 
    this.customerPhoto, 
    this.customerPhotoFilename, 
    this.qGroup, 
    this.hwyExpDt,
    this.pic1, 
    this.pic2, 
    this.pic3, 
    this.remarks, 
    this.edeclCode, 
    this.edeclReqid, 
    this.eregCode, 
    this.eregReqid, 
    this.ekppCode1, 
    this.ekppReqid1, 
    this.transtamp1, 
    this.dsCode1, 
    this.eregTick, 
    this.eregStat, 
    this.eregInd, 
    this.pgaHukum, 
    this.pgaGila, 
    this.pgaCacat, 
    this.pgaPitam, 
    this.pgaMata, 
    this.pgaLain, 
    this.lainRemark, 
    this.pgaTiada, 
    this.eregRemark, 
    this.smcCount, 
    this.entryType1, 
    this.racetext, 
    this.gpsLatitude, 
    this.gpsLongitude, 
    this.gpsZip, 
    this.pickup, 
    this.compCode1, 
    this.branchCode1, 
    this.rowKey1, 
    this.lastupload1, 
    this.deleted1, 
    this.diCode1
  });

  CompleteClassList.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
		merchantNo = json['merchant_no'] ?? '';
		icNo = json['ic_no'] ?? '';
		stuNo = json['stu_no'] ?? '';
		trandate = json['trandate'] ?? '';
		vehNo = json['veh_no'] ?? '';
		trnCode = json['trn_code'] ?? '';
		slipNo = json['slip_no'] ?? '';
		sm4No = json['sm4_no'] ?? '';
		certNo = json['cert_no'] ?? '';
		groupId = json['group_id'] ?? '';
		kppGroupId = json['kpp_group_id'] ?? '';
		kppGroupId2 = json['kpp_group_id_2'] ?? '';
		kppGroupId3 = json['kpp_group_id_3'] ?? '';
		classes = json['class'] ?? '';
		bgTime = json['bg_time'] ?? '';
		endTime = json['end_time'] ?? '';
		employeNo = json['employe_no'] ?? '';
		remark = json['remark'] ?? '';
		dsCode = json['ds_code'] ?? '';
		pracType = json['prac_type'] ?? '';
		sysTime = json['sys_time'] ?? '';
		closeUser = json['close_user'] ?? '';
		closeDate = json['close_date'] ?? '';
		epretCode = json['epret_code'] ?? '';
		epretReqid = json['epret_reqid'] ?? '';
		ekppCode = json['ekpp_code'] ?? '';
		ekppReqid = json['ekpp_reqid'] ?? '';
		transtamp = json['transtamp'] ?? '';
		actBgTime = json['act_bg_time'] ?? '';
		actEndTime = json['act_end_time'] ?? '';
		byFingerprn = json['by_fingerprn'] ?? '';
		ej2aTick = json['ej2a_tick'] ?? '';
		ej2aInd = json['ej2a_ind'] ?? '';
		ej2aStat = json['ej2a_stat'] ?? '';
		ej2bInd = json['ej2b_ind'] ?? '';
		ej2bTick = json['ej2b_tick'] ?? '';
		ej2bStat = json['ej2b_stat'] ?? '';
		snoBkpp = json['sno_bkpp'] ?? '';
		adminId1 = json['admin_id1'] ?? '';
		actBgTime2 = json['act_bg_time2'] ?? '';
		classCode = json['class_code'] ?? '';
		verifyTrncode = json['verify_trncode'] ?? '';
		actEndTime2 = json['act_end_time2'] ?? '';
		ej2aRemark = json['ej2a_remark'] ?? '';
		ej2bRemark = json['ej2b_remark'] ?? '';
		entryType = json['entry_type'] ?? '';
		sjlprndate = json['sjlprndate'] ?? '';
		issueSjDate = json['issue_sj_date'] ?? '';
		courseCode = json['course_code'] ?? '';
		location = json['location'] ?? '';
		theoryType = json['theory_type'] ?? '';
		totalTime = json['total_time'] ?? '-';
		kpp02CertNo = json['kpp02_cert_no'] ?? '';
		kpp02IssueSjDate = json['kpp02_issue_sj_date'] ?? '';
		kpp02Sjlprndate = json['kpp02_sjlprndate'] ?? '';
		sessionTotalTime = json['session_total_time'] ?? '';
		compCode = json['comp_code'] ?? '';
		branchCode = json['branch_code'] ?? '';
		rowKey = json['row_key'] ?? '';
		lastupload = json['lastupload'] ?? '';
    customerphoto = json['__customer_photo'] ?? '';
    customerphotoFilename = json['__customer_photo_filename'] ?? '';
		deleted = json['deleted'] ?? '';
		diCode = json['di_code'] ?? '';
    iD1 = json['ID1'] ?? '';
		icNo1 = json['ic_no1'] ?? '';
		nric = json['nric'] ?? '';
		oldIc = json['old_ic'] ?? '';
		category = json['category'] ?? '';
		name = json['name'] ?? '';
		add1 = json['add1'] ?? '';
		add2 = json['add2'] ?? '';
		add3 = json['add3'] ?? '';
		state = json['state'] ?? '';
		city = json['city'] ?? '';
		zip = json['zip'] ?? '';
		emailAddr = json['email_addr'] ?? '-';
		handPhone = json['hand_phone'] ?? '-';
		homePhone = json['home_phone'] ?? '-';
		offPhone = json['off_phone'] ?? '-';
		off2Phone = json['off2_phone'] ?? '-';
		sex = json['sex'] ?? '';
		race = json['race'] ?? '';
		birthPl = json['birth_pl'] ?? '';
		birthDt = json['birth_dt'] ?? '';
		citizenship = json['citizenship'] ?? '';
		customerPhoto = json['customer_photo'] ?? '';
		customerPhotoFilename = json['customer_photo_filename'] ?? '';
		qGroup = json['q_group'] ?? '';
		hwyExpDt = json['hwy_exp_dt'] ?? '';
		pic1 = json['pic_1'] ?? '';
		pic2 = json['pic_2'] ?? '';
		pic3 = json['pic_3'] ?? '';
		remarks = json['remarks'] ?? '';
		edeclCode = json['edecl_code'] ?? '';
		edeclReqid = json['edecl_reqid'] ?? '';
		eregCode = json['ereg_code'] ?? '';
		eregReqid = json['ereg_reqid'] ?? '';
		ekppCode1 = json['ekpp_code1'] ?? '';
		ekppReqid1 = json['ekpp_reqid1'] ?? '';
		transtamp1 = json['transtamp1'] ?? '';
		dsCode1 = json['ds_code1'] ?? '';
		eregTick = json['ereg_tick'] ?? '';
		eregStat = json['ereg_stat'] ?? '';
		eregInd = json['ereg_ind'] ?? '';
		pgaHukum = json['pga_hukum'] ?? '';
		pgaGila = json['pga_gila'] ?? '';
		pgaCacat = json['pga_cacat'] ?? '';
		pgaPitam = json['pga_pitam'] ?? '';
		pgaMata = json['pga_mata'] ?? '';
		pgaLain = json['pga_lain'] ?? '';
		lainRemark = json['lain_remark'] ?? '';
		pgaTiada = json['pga_tiada'] ?? '';
		eregRemark = json['ereg_remark'] ?? '';
		smcCount = json['smc_count'] ?? '';
		entryType1 = json['entry_type1'] ?? '';
		racetext = json['racetext'] ?? '';
		gpsLatitude = json['gps_latitude'] ?? '';
		gpsLongitude = json['gps_longitude'] ?? '';
		gpsZip = json['gps_zip'] ?? '';
		pickup = json['pickup'] ?? '';
		compCode1 = json['comp_code1'] ?? '';
		branchCode1 = json['branch_code1'] ?? '';
		rowKey1 = json['row_key1'] ?? '';
		lastupload1 = json['lastupload1'] ?? '';
		deleted1 = json['deleted1'] ?? '';
		diCode1 = json['di_code1'] ?? '';
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
		data['merchant_no'] = merchantNo;
		data['ic_no'] = icNo;
		data['stu_no'] = stuNo;
		data['trandate'] = trandate;
		data['veh_no'] = vehNo;
		data['trn_code'] = trnCode;
		data['slip_no'] = slipNo;
		data['sm4_no'] = sm4No;
		data['cert_no'] = certNo;
		data['group_id'] = groupId;
		data['kpp_group_id'] = kppGroupId;
		data['kpp_group_id_2'] = kppGroupId2;
		data['kpp_group_id_3'] = kppGroupId3;
		data['class'] = classes;
		data['bg_time'] = bgTime;
		data['end_time'] = endTime;
		data['employe_no'] = employeNo;
		data['remark'] = remark;
		data['ds_code'] = dsCode;
		data['prac_type'] = pracType;
		data['sys_time'] = sysTime;
		data['close_user'] = closeUser;
		data['close_date'] = closeDate;
		data['epret_code'] = epretCode;
		data['epret_reqid'] = epretReqid;
		data['ekpp_code'] = ekppCode;
		data['ekpp_reqid'] = ekppReqid;
		data['transtamp'] = transtamp;
		data['act_bg_time'] = actBgTime;
		data['act_end_time'] = actEndTime;
		data['by_fingerprn'] = byFingerprn;
		data['ej2a_tick'] = ej2aTick;
		data['ej2a_ind'] = ej2aInd;
		data['ej2a_stat'] = ej2aStat;
		data['ej2b_ind'] = ej2bInd;
		data['ej2b_tick'] = ej2bTick;
		data['ej2b_stat'] = ej2bStat;
		data['sno_bkpp'] = snoBkpp;
		data['admin_id1'] = adminId1;
		data['act_bg_time2'] = actBgTime2;
		data['class_code'] = classCode;
		data['verify_trncode'] = verifyTrncode;
		data['act_end_time2'] = actEndTime2;
		data['ej2a_remark'] = ej2aRemark;
		data['ej2b_remark'] = ej2bRemark;
		data['entry_type'] = entryType;
		data['sjlprndate'] = sjlprndate;
		data['issue_sj_date'] = issueSjDate;
		data['course_code'] = courseCode;
		data['location'] = location;
		data['theory_type'] = theoryType;
		data['total_time'] = totalTime;
		data['kpp02_cert_no'] = kpp02CertNo;
		data['kpp02_issue_sj_date'] = kpp02IssueSjDate;
		data['kpp02_sjlprndate'] = kpp02Sjlprndate;
		data['session_total_time'] = sessionTotalTime;
		data['comp_code'] = compCode;
		data['branch_code'] = branchCode;
		data['row_key'] = rowKey;
		data['lastupload'] = lastupload;
    data['__customer_photo'] = customerphoto;
    data['__customer_photo_filename'] = customerphotoFilename;
		data['deleted'] = deleted;
		data['di_code'] = diCode;
    data['ID1'] = iD1;
		data['ic_no1'] = icNo1;
		data['nric'] = nric;
		data['old_ic'] = oldIc;
		data['category'] = category;
		data['name'] = name;
		data['add1'] = add1;
		data['add2'] = add2;
		data['add3'] = add3;
		data['state'] = state;
		data['city'] = city;
		data['zip'] = zip;
		data['email_addr'] = emailAddr;
		data['hand_phone'] = handPhone;
		data['home_phone'] = homePhone;
		data['off_phone'] = offPhone;
		data['off2_phone'] = off2Phone;
		data['sex'] = sex;
		data['race'] = race;
		data['birth_pl'] = birthPl;
		data['birth_dt'] = birthDt;
		data['citizenship'] = citizenship;
		data['customer_photo'] = customerPhoto;
		data['customer_photo_filename'] = customerPhotoFilename;
		data['q_group'] = qGroup;
		data['hwy_exp_dt'] = hwyExpDt;
		data['pic_1'] = pic1;
		data['pic_2'] = pic2;
		data['pic_3'] = pic3;
		data['remarks'] = remarks;
		data['edecl_code'] = edeclCode;
		data['edecl_reqid'] = edeclReqid;
		data['ereg_code'] = eregCode;
		data['ereg_reqid'] = eregReqid;
		data['ekpp_code1'] = ekppCode1;
		data['ekpp_reqid1'] = ekppReqid1;
		data['transtamp1'] = transtamp1;
		data['ds_code1'] = dsCode1;
		data['ereg_tick'] = eregTick;
		data['ereg_stat'] = eregStat;
		data['ereg_ind'] = eregInd;
		data['pga_hukum'] = pgaHukum;
		data['pga_gila'] = pgaGila;
		data['pga_cacat'] = pgaCacat;
		data['pga_pitam'] = pgaPitam;
		data['pga_mata'] = pgaMata;
		data['pga_lain'] = pgaLain;
		data['lain_remark'] = lainRemark;
		data['pga_tiada'] = pgaTiada;
		data['ereg_remark'] = eregRemark;
		data['smc_count'] = smcCount;
		data['entry_type1'] = entryType1;
		data['racetext'] = racetext;
		data['gps_latitude'] = gpsLatitude;
		data['gps_longitude'] = gpsLongitude;
		data['gps_zip'] = gpsZip;
		data['pickup'] = pickup;
		data['comp_code1'] = compCode1;
		data['branch_code1'] = branchCode1;
		data['row_key1'] = rowKey1;
		data['lastupload1'] = lastupload1;
		data['deleted1'] = deleted1;
		data['di_code1'] = diCode1;
    return data;
  }
}

class SaveStuPrac{
  String? wsCodeCrypt;
  String? caUid;
  String? caPwd;
  String? merchantNo;
  String? icNo;
  String? groupId;
  String? startTime;
  String? endTime;
  String? courseCode;
  String? trandateString;
  String? trnCode;
  String? byFingerPrn;
  String? dsCode;
  String? vehNo;

  SaveStuPrac({
    this.wsCodeCrypt,
      this.caUid,
      this.caPwd,
      this.merchantNo,
      this.icNo,
      this.groupId,
      this.startTime,
      this.endTime,
      this.courseCode,
      this.trandateString,
      this.trnCode,
      this.byFingerPrn,
      this.dsCode,
      this.vehNo
  });

  SaveStuPrac.fromJson(Map<String, dynamic> json) {
    wsCodeCrypt = json['wsCodeCrypt'];
    caUid = json['caUid'];
    caPwd = json['caPwd'];
    merchantNo = json['merchantNo'];
    icNo = json['icNo'];
    groupId = json['groupId'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    courseCode = json['courseCode'];
    trandateString = json['trandateString'];
    trnCode = json['trnCode'];
    byFingerPrn = json['byFingerPrn'];
    dsCode = json['dsCode'];
    vehNo = json['vehNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wsCodeCrypt'] = wsCodeCrypt;
    data['caUid'] = caUid;
    data['caPwd'] = caPwd;
    data['merchantNo'] = merchantNo;
    data['icNo'] = icNo;
    data['groupId'] = groupId;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['courseCode'] = courseCode;
    data['trandateString'] = trandateString;
    data['trnCode'] = trnCode;
    data['byFingerPrn'] = byFingerPrn;
    data['dsCode'] = dsCode;
    data['vehNo'] = vehNo;
    return data;
  }

}

class GetCustomerByMifareCardResponse{
  List<MiFareCardList>? mifareCardList;

  GetCustomerByMifareCardResponse({this.mifareCardList});

  GetCustomerByMifareCardResponse.fromJson(Map<String, dynamic> json){
    if (json['Customer'] != null) {
      mifareCardList = <MiFareCardList>[];
      json['Customer'].forEach((v) {
        mifareCardList!.add(MiFareCardList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    if(mifareCardList != null){
      data['Customer'] = mifareCardList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MiFareCardList{
  String? id;
  String? icNo;
  String? nric;
  String? oldIc;
  String? category;
  String? name;
  String? add1;
  String? add2;
  String? add3;
  String? state;
  String? city;
  String? zip;
  String? emailAddr;
  String? handPhone;
  String? homePhone;
  String? offPhone;
  String? off2Phone;
  String? sex;
  String? race;
  String? birthPl;
  String? birthDt;
  String? citizenship;
  String? customerPhoto;
  String? customerPhotoFilename;
  String? qGroup;
  String? hwyExpDt;
  String? pic1;
  String? pic2;
  String? pic3;
  String? remarks;
  String? edeclCode;
  String? edeclReqid;
  String? eregCode;
  String? eregReqid;
  String? ekppCode;
  String? ekppReqid;
  String? transtamp;
  String? dsCode;
  String? eregTick;
  String? eregStat;
  String? eregInd;
  String? pgaHukum;
  String? pgaGila;
  String? pgaCacat;
  String? pgaPitam;
  String? pgaMata;
  String? pgaLain;
  String? lainRemark;
  String? pgaTiada;
  String? eregRemark;
  String? smcCount;
  String? entryType;
  String? racetext;
  String? gpsLatitude;
  String? gpsLongitude;
  String? gpsZip;
  String? pickup;
  String? deleted;
  String? diCode;
  String? cardNo;
  String? nricNo;
  String? rowKey;
  String? createUser;
  String? createDate;
  String? editUser;
  String? editDate;
  String? lastupload;

  MiFareCardList({
    this.id,
      this.icNo,
      this.nric,
      this.oldIc,
      this.category,
      this.name,
      this.add1,
      this.add2,
      this.add3,
      this.state,
      this.city,
      this.zip,
      this.emailAddr,
      this.handPhone,
      this.homePhone,
      this.offPhone,
      this.off2Phone,
      this.sex,
      this.race,
      this.birthPl,
      this.birthDt,
      this.citizenship,
      this.customerPhoto,
      this.customerPhotoFilename,
      this.qGroup,
      this.hwyExpDt,
      this.pic1,
      this.pic2,
      this.pic3,
      this.remarks,
      this.edeclCode,
      this.edeclReqid,
      this.eregCode,
      this.eregReqid,
      this.ekppCode,
      this.ekppReqid,
      this.transtamp,
      this.dsCode,
      this.eregTick,
      this.eregStat,
      this.eregInd,
      this.pgaHukum,
      this.pgaGila,
      this.pgaCacat,
      this.pgaPitam,
      this.pgaMata,
      this.pgaLain,
      this.lainRemark,
      this.pgaTiada,
      this.eregRemark,
      this.smcCount,
      this.entryType,
      this.racetext,
      this.gpsLatitude,
      this.gpsLongitude,
      this.gpsZip,
      this.pickup,
      this.deleted,
      this.diCode,
      this.cardNo,
      this.nricNo,
      this.rowKey,
      this.createUser,
      this.createDate,
      this.editUser,
      this.editDate,
      this.lastupload
  });

  MiFareCardList.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    icNo = json['ic_no'] ?? '';
    nric = json['nric'] ?? '';
    oldIc = json['old_ic'] ?? '';
    category = json['category'] ?? '';
    name = json['name'] ?? '';
    add1 = json['add1'] ?? '';
    add2 = json['add2'] ?? '';
    add3 = json['add3'] ?? '';
    state = json['state'] ?? '';
    city = json['city'] ?? '';
    zip = json['zip'] ?? '';
    emailAddr = json['email_addr'] ?? '';
    handPhone = json['hand_phone'] ?? '';
    homePhone = json['home_phone'] ?? '';
    offPhone = json['off_phone'] ?? '';
    off2Phone = json['off2_phone'] ?? '';
    sex = json['sex'] ?? '';
    race = json['race'] ?? '';
    birthPl = json['birth_pl'] ?? '';
    birthDt = json['birth_dt'] ?? '';
    citizenship = json['citizenship'] ?? '';
    customerPhoto = json['customer_photo'] ?? '';
    customerPhotoFilename = json['customer_photo_filename'] ?? '';
    qGroup = json['q_group'] ?? '';
    hwyExpDt = json['hwy_exp_dt'] ?? '';
    pic1 = json['pic_1'] ?? '';
    pic2 = json['pic_2'] ?? '';
    pic3 = json['pic_3'] ?? '';
    remarks = json['remarks'] ?? '';
    edeclCode = json['edecl_code'] ?? '';
    edeclReqid = json['edecl_reqid'] ?? '';
    eregCode = json['ereg_code'] ?? '';
    eregReqid = json['ereg_reqid'] ?? '';
    ekppCode = json['ekpp_code'] ?? '';
    ekppReqid = json['ekpp_reqid'] ?? '';
    transtamp = json['transtamp'] ?? '';
    dsCode = json['ds_code'] ?? '';
    eregTick = json['ereg_tick'] ?? '';
    eregStat = json['ereg_stat'] ?? '';
    eregInd = json['ereg_ind'] ?? '';
    pgaHukum = json['pga_hukum'] ?? '';
    pgaGila = json['pga_gila'] ?? '';
    pgaCacat = json['pga_cacat'] ?? '';
    pgaPitam = json['pga_pitam'] ?? '';
    pgaMata = json['pga_mata'] ?? '';
    pgaLain = json['pga_lain'] ?? '';
    lainRemark = json['lain_remark'] ?? '';
    pgaTiada = json['pga_tiada'] ?? '';
    eregRemark = json['ereg_remark'] ?? '';
    smcCount = json['smc_count'] ?? '';
    entryType = json['entry_type'] ?? '';
    racetext = json['racetext'] ?? '';
    gpsLatitude = json['gps_latitude'] ?? '';
    gpsLongitude = json['gps_longitude'] ?? '';
    gpsZip = json['gps_zip'] ?? '';
    pickup = json['pickup'] ?? '';
    deleted = json['deleted'] ?? '';
    diCode = json['di_code'] ?? '';
    cardNo = json['card_no'] ?? '';
    nricNo = json['nric_no'] ?? '';
    rowKey = json['row_key'] ?? '';
    createUser = json['create_user'] ?? '';
    createDate = json['create_date'] ?? '';
    editUser = json['edit_user'] ?? '';
    editDate = json['edit_date'] ?? '';
    lastupload = json['lastupload'] ?? '';
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ic_no'] = icNo;
    data['nric'] = nric;
    data['old_ic'] = oldIc;
    data['category'] = category;
    data['name'] = name;
    data['add1'] = add1;
    data['add2'] = add2;
    data['add3'] = add3;
    data['state'] = state;
    data['city'] = city;
    data['zip'] = zip;
    data['email_addr'] = emailAddr;
    data['hand_phone'] = handPhone;
    data['home_phone'] = homePhone;
    data['off_phone'] = offPhone;
    data['off2_phone'] = off2Phone;
    data['sex'] = sex;
    data['race'] = race;
    data['birth_pl'] = birthPl;
    data['birth_dt'] = birthDt;
    data['citizenship'] = citizenship;
    data['customer_photo'] = customerPhoto;
    data['customer_photo_filename'] = customerPhotoFilename;
    data['q_group'] = qGroup;
    data['hwy_exp_dt'] = hwyExpDt;
    data['pic_1'] = pic1;
    data['pic_2'] = pic2;
    data['pic_3'] = pic3;
    data['remarks'] = remarks;
    data['edecl_code'] = edeclCode;
    data['edecl_reqid'] = edeclReqid;
    data['ereg_code'] = eregCode;
    data['ereg_reqid'] = eregReqid;
    data['ekpp_code'] = ekppCode;
    data['ekpp_reqid'] = ekppReqid;
    data['transtamp'] = transtamp;
    data['ds_code'] = dsCode;
    data['ereg_tick'] = eregTick;
    data['ereg_stat'] = eregStat;
    data['ereg_ind'] = eregInd;
    data['pga_hukum'] = pgaHukum;
    data['pga_gila'] = pgaGila;
    data['pga_cacat'] = pgaCacat;
    data['pga_pitam'] = pgaPitam;
    data['pga_mata'] = pgaMata;
    data['pga_lain'] = pgaLain;
    data['lain_remark'] = lainRemark;
    data['pga_tiada'] = pgaTiada;
    data['ereg_remark'] = eregRemark;
    data['smc_count'] = smcCount;
    data['entry_type'] = entryType;
    data['racetext'] = racetext;
    data['gps_latitude'] = gpsLatitude;
    data['gps_longitude'] = gpsLongitude;
    data['gps_zip'] = gpsZip;
    data['pickup'] = pickup;
    data['deleted'] = deleted;
    data['di_code'] = diCode;
    data['card_no'] = cardNo;
    data['nric_no'] = nricNo;
    data['row_key'] = rowKey;
    data['create_user'] = createUser;
    data['create_date'] = createDate;
    data['edit_user'] = editUser;
    data['edit_date'] = editDate;
    data['lastupload'] = lastupload;
    return data;
  }
}
