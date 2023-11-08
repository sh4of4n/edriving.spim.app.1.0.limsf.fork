class GetInstructorResponse {
  List<TrainerList>? trainerList;

  GetInstructorResponse({this.trainerList});

  GetInstructorResponse.fromJson(Map<String, dynamic> json){
    if (json['Trainer'] != null) {
      trainerList = <TrainerList>[];
      json['Trainer'].forEach((v) {
        trainerList!.add(TrainerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (trainerList != null) {
      data['Trainer'] = trainerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrainerList{
  String? trnCode;
  String? empno;
  String? trnName;
  String? addr1;
  String? addr2;
  String? addr3;
  String? telHm;
  String? telHp;
  String? workGrpCode;
  String? pagerNo;
  String? descriptio;
  String? defaAmt;
  String? serTax;
  String? handChrg;
  String? serChrg;
  String? deptCode;
  String? offCatago;
  String? remarks;
  String? eduGrade;
  String? jpjNote;
  String? certNo;
  String? certExpDt;
  String? kppGroupId;
  String? spimGroupId;
  String? qtiGroupId;
  String? sm2No;
  String? sm2ExpDt;
  String? calCode;
  String? transtamp;
  String? nric;
  String? oldIc;
  String? validGroupId;
  String? blacklist;
  String? remark;
  String? photo;
  String? compCode;
  String? branchCode;
  String? rowKey;
  String? lastupload;
  String? deleted;
  String? createUser;
  String? createDate;
  String? editUser;
  String? editDate;
  String? merchantNo;
  String? iD;
  String? joinDate;
  String? resignDate;
  String? exclude;
  String? diCode;
  String? lastEditedBy;
  String? createdBy;
  String? photoFileName;

  TrainerList(
      {this.trnCode,
      this.empno,
      this.trnName,
      this.addr1,
      this.addr2,
      this.addr3,
      this.telHm,
      this.telHp,
      this.workGrpCode,
      this.pagerNo,
      this.descriptio,
      this.defaAmt,
      this.serTax,
      this.handChrg,
      this.serChrg,
      this.deptCode,
      this.offCatago,
      this.remarks,
      this.eduGrade,
      this.jpjNote,
      this.certNo,
      this.certExpDt,
      this.kppGroupId,
      this.spimGroupId,
      this.qtiGroupId,
      this.sm2No,
      this.sm2ExpDt,
      this.calCode,
      this.transtamp,
      this.nric,
      this.oldIc,
      this.validGroupId,
      this.blacklist,
      this.remark,
      this.photo,
      this.compCode,
      this.branchCode,
      this.rowKey,
      this.lastupload,
      this.deleted,
      this.createUser,
      this.createDate,
      this.editUser,
      this.editDate,
      this.merchantNo,
      this.iD,
      this.joinDate,
      this.resignDate,
      this.exclude,
      this.diCode,
      this.lastEditedBy,
      this.createdBy,
      this.photoFileName});

  TrainerList.fromJson(Map<String, dynamic> json) {
    trnCode = json['trn_code'];
    empno = json['empno'];
    trnName = json['trn_name'];
    addr1 = json['addr1'];
    addr2 = json['addr2'];
    addr3 = json['addr3'];
    telHm = json['tel_hm'];
    telHp = json['tel_hp'];
    workGrpCode = json['work_grp_code'];
    pagerNo = json['pager_no'];
    descriptio = json['descriptio'];
    defaAmt = json['defa_amt'];
    serTax = json['ser_tax'];
    handChrg = json['hand_chrg'];
    serChrg = json['ser_chrg'];
    deptCode = json['dept_code'];
    offCatago = json['off_catago'];
    remarks = json['remarks'];
    eduGrade = json['edu_grade'];
    jpjNote = json['jpj_note'];
    certNo = json['cert_no'];
    certExpDt = json['cert_exp_dt'];
    kppGroupId = json['kpp_group_id'];
    spimGroupId = json['spim_group_id'];
    qtiGroupId = json['qti_group_id'];
    sm2No = json['sm2_no'];
    sm2ExpDt = json['sm2_exp_dt'];
    calCode = json['cal_code'];
    transtamp = json['transtamp'];
    nric = json['nric'];
    oldIc = json['old_ic'];
    validGroupId = json['valid_group_id'];
    blacklist = json['blacklist'];
    remark = json['remark'];
    photo = json['photo'];
    compCode = json['comp_code'];
    branchCode = json['branch_code'];
    rowKey = json['row_key'];
    lastupload = json['lastupload'];
    deleted = json['deleted'];
    createUser = json['create_user'];
    createDate = json['create_date'];
    editUser = json['edit_user'];
    editDate = json['edit_date'];
    merchantNo = json['merchant_no'];
    iD = json['ID'];
    joinDate = json['join_date'];
    resignDate = json['resign_date'];
    exclude = json['exclude'];
    diCode = json['di_code'];
    lastEditedBy = json['last_edited_by'];
    createdBy = json['created_by'];
    photoFileName = json['photo_filename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trn_code'] = trnCode;
    data['empno'] = empno;
    data['trn_name'] = trnName;
    data['addr1'] = addr1;
    data['addr2'] = addr2;
    data['addr3'] = addr3;
    data['tel_hm'] = telHm;
    data['tel_hp'] = telHp;
    data['work_grp_code'] = workGrpCode;
    data['pager_no'] = pagerNo;
    data['descriptio'] = descriptio;
    data['defa_amt'] = defaAmt;
    data['ser_tax'] = serTax;
    data['hand_chrg'] = handChrg;
    data['ser_chrg'] = serChrg;
    data['dept_code'] = deptCode;
    data['off_catago'] = offCatago;
    data['remarks'] = remarks;
    data['edu_grade'] = eduGrade;
    data['jpj_note'] = jpjNote;
    data['cert_no'] = certNo;
    data['cert_exp_dt'] = certExpDt;
    data['kpp_group_id'] = kppGroupId;
    data['spim_group_id'] = spimGroupId;
    data['qti_group_id'] = qtiGroupId;
    data['sm2_no'] = sm2No;
    data['sm2_exp_dt'] = sm2ExpDt;
    data['cal_code'] = calCode;
    data['transtamp'] = transtamp;
    data['nric'] = nric;
    data['old_ic'] = oldIc;
    data['valid_group_id'] = validGroupId;
    data['blacklist'] = blacklist;
    data['remark'] = remark;
    data['photo'] = photo;
    data['comp_code'] = compCode;
    data['branch_code'] = branchCode;
    data['row_key'] = rowKey;
    data['lastupload'] = lastupload;
    data['deleted'] = deleted;
    data['create_user'] = createUser;
    data['create_date'] = createDate;
    data['edit_user'] = editUser;
    data['edit_date'] = editDate;
    data['merchant_no'] = merchantNo;
    data['ID'] = iD;
    data['join_date'] = joinDate;
    data['resign_date'] = resignDate;
    data['exclude'] = exclude;
    data['di_code'] = diCode;
    data['last_edited_by'] = lastEditedBy;
    data['created_by'] = createdBy;
    data['photo_filename'] = photoFileName;
    return data;
  }
}

class DeleteInstructorRequest {
  String? wsCodeCrypt;
  String? caUid;
  String? caPwd;
  String? mLoginId;
  String? appId;
  String? deviceId;
  String? diCode;
  String? trnCode;

  DeleteInstructorRequest({
    this.wsCodeCrypt,
    this.caUid,
    this.caPwd,
    this.mLoginId,
    this.appId,
    this.deviceId,
    this.diCode,
    this.trnCode
  });

  DeleteInstructorRequest.fromJson(Map<String, dynamic> json){
    wsCodeCrypt = json['wsCodeCrypt'];
    caUid = json['caUid'];
    caPwd = json['caPwd'];
    mLoginId = json['mLoginId'];
    appId = json['appId'];
    deviceId = json['deviceId'];
    diCode = json['diCode'];
    trnCode = json['trnCode'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wsCodeCrypt'] = wsCodeCrypt;
    data['caUid'] = caUid;
    data['caPwd'] = caPwd;
    data['mLoginId'] = mLoginId;
    data['appId'] = appId;
    data['deviceId'] = deviceId;
    data['diCode'] = diCode;
    data['trnCode'] = trnCode;
    return data;
  }
}