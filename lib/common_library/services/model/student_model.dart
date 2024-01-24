class GetStudentResponse{
  List<StudentList>? studentList;
  
  GetStudentResponse({this.studentList});

  GetStudentResponse.fromJson(Map<String, dynamic> json){
    if (json['Vehicle'] != null) {
      studentList = <StudentList>[];
      json['Vehicle'].forEach((v) {
        studentList!.add(StudentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (studentList != null) {
      data['Vehicle'] = studentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentList{
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
  String? compCode;
  String? branchCode;
  String? rowKey;
  String? lastupload;

  StudentList(
      {this.id,
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
      this.compCode,
      this.branchCode,
      this.rowKey,
      this.lastupload});

  StudentList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icNo = json['ic_no'];
    nric = json['nric'];
    oldIc = json['old_ic'];
    category = json['category'];
    name = json['name'];
    add1 = json['add1'];
    add2 = json['add2'];
    add3 = json['add3'];
    state = json['state'];
    city = json['city'];
    zip = json['zip'];
    emailAddr = json['email_addr'];
    handPhone = json['hand_phone'];
    homePhone = json['home_phone'];
    offPhone = json['off_phone'];
    off2Phone = json['off2_phone'];
    sex = json['sex'];
    race = json['race'];
    birthPl = json['birth_pl'];
    birthDt = json['birth_dt'];
    citizenship = json['citizenship'];
    customerPhoto = json['customer_photo'];
    customerPhotoFilename = json['customer_photo_filename'];
    qGroup = json['q_group'];
    hwyExpDt = json['hwy_exp_dt'];
    pic1 = json['pic_1'];
    pic2 = json['pic_2'];
    pic3 = json['pic_3'];
    remarks = json['remarks'];
    edeclCode = json['edecl_code'];
    edeclReqid = json['edecl_reqid'];
    eregCode = json['ereg_code'];
    eregReqid = json['ereg_reqid'];
    ekppCode = json['ekpp_code'];
    ekppReqid = json['ekpp_reqid'];
    transtamp = json['transtamp'];
    dsCode = json['ds_code'];
    eregTick = json['ereg_tick'];
    eregStat = json['ereg_stat'];
    eregInd = json['ereg_ind'];
    pgaHukum = json['pga_hukum'];
    pgaGila = json['pga_gila'];
    pgaCacat = json['pga_cacat'];
    pgaPitam = json['pga_pitam'];
    pgaMata = json['pga_mata'];
    pgaLain = json['pga_lain'];
    lainRemark = json['lain_remark'];
    pgaTiada = json['pga_tiada'];
    eregRemark = json['ereg_remark'];
    smcCount = json['smc_count'];
    entryType = json['entry_type'];
    racetext = json['racetext'];
    gpsLatitude = json['gps_latitude'];
    gpsLongitude = json['gps_longitude'];
    gpsZip = json['gps_zip'];
    pickup = json['pickup'];
    deleted = json['deleted'];
    diCode = json['di_code'];
    compCode = json['comp_code'];
    branchCode = json['branch_code'];
    rowKey = json['row_key'];
    lastupload = json['lastupload'];
  }

  Map<String, dynamic> toJson() {
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
    data['comp_code'] = compCode;
    data['branch_code'] = branchCode;
    data['row_key'] = rowKey;
    data['lastupload'] = lastupload;
    return data;
  }
}