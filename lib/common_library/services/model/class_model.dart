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
    icNo = json['ic_no'] ?? '';
    groupId = json['group_id'] ?? '';
    vehNo = json['veh_no'] ?? '';
    courseCode = json['course_code'] ?? '';
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
    name = json['name'] ?? '';
    add1 = json['add1'] ?? '';
    add2 = json['add2'] ?? '';
    add3 = json['add3'] ?? '';
    state = json['state'] ?? '';
    city = json['city'] ?? '';
    zip = json['zip'] ?? '';
    handPhone = json['hand_phone'] ?? '';
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
	String? deleted;
	String? diCode;

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
    this.deleted, 
    this.diCode
  });

  CompleteClassList.fromJson(Map<String, dynamic> json){
    id = json['id'];
		merchantNo = json['merchant_no'];
		icNo = json['ic_no'];
		stuNo = json['stu_no'];
		trandate = json['trandate'];
		vehNo = json['veh_no'];
		trnCode = json['trn_code'];
		slipNo = json['slip_no'];
		sm4No = json['sm4_no'];
		certNo = json['cert_no'];
		groupId = json['group_id'];
		kppGroupId = json['kpp_group_id'];
		kppGroupId2 = json['kpp_group_id_2'];
		kppGroupId3 = json['kpp_group_id_3'];
		classes = json['class'];
		bgTime = json['bg_time'];
		endTime = json['end_time'];
		employeNo = json['employe_no'];
		remark = json['remark'];
		dsCode = json['ds_code'];
		pracType = json['prac_type'];
		sysTime = json['sys_time'];
		closeUser = json['close_user'];
		closeDate = json['close_date'];
		epretCode = json['epret_code'];
		epretReqid = json['epret_reqid'];
		ekppCode = json['ekpp_code'];
		ekppReqid = json['ekpp_reqid'];
		transtamp = json['transtamp'];
		actBgTime = json['act_bg_time'];
		actEndTime = json['act_end_time'];
		byFingerprn = json['by_fingerprn'];
		ej2aTick = json['ej2a_tick'];
		ej2aInd = json['ej2a_ind'];
		ej2aStat = json['ej2a_stat'];
		ej2bInd = json['ej2b_ind'];
		ej2bTick = json['ej2b_tick'];
		ej2bStat = json['ej2b_stat'];
		snoBkpp = json['sno_bkpp'];
		adminId1 = json['admin_id1'];
		actBgTime2 = json['act_bg_time2'];
		classCode = json['class_code'];
		verifyTrncode = json['verify_trncode'];
		actEndTime2 = json['act_end_time2'];
		ej2aRemark = json['ej2a_remark'];
		ej2bRemark = json['ej2b_remark'];
		entryType = json['entry_type'];
		sjlprndate = json['sjlprndate'];
		issueSjDate = json['issue_sj_date'];
		courseCode = json['course_code'];
		location = json['location'];
		theoryType = json['theory_type'];
		totalTime = json['total_time'];
		kpp02CertNo = json['kpp02_cert_no'];
		kpp02IssueSjDate = json['kpp02_issue_sj_date'];
		kpp02Sjlprndate = json['kpp02_sjlprndate'];
		sessionTotalTime = json['session_total_time'];
		compCode = json['comp_code'];
		branchCode = json['branch_code'];
		rowKey = json['row_key'];
		lastupload = json['lastupload'];
		deleted = json['deleted'];
		diCode = json['di_code'];
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