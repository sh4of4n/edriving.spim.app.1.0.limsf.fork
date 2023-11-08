class GetVehicleListResponse {
  List<VehicleList>? vcList;

  GetVehicleListResponse({this.vcList});

  GetVehicleListResponse.fromJson(Map<String, dynamic> json) {
    if (json['Vehicle'] != null) {
      vcList = <VehicleList>[];
      json['Vehicle'].forEach((v) {
        vcList!.add(VehicleList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vcList != null) {
      data['Vehicle'] = vcList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehicleList {
  String? vehNo;
  String? groupId;
  String? trnCode;
  String? carNo;
  String? model;
  String? engNo;
  String? chasisNo;
  String? typeModel;
  String? year;
  String? make;
  String? rdtaxExp;
  String? sm3No;
  String? sm3Siri;
  String? sm3IsuDt;
  String? sm3ExpDt;
  String? inspDt;
  String? nxOilChg;
  String? nxFilChg;
  String? capacity;
  String? kegunaan;
  String? tonage;
  String? rtExpDt;
  String? jpjRec;
  String? ispDate;
  String? ispRecNo;
  String? acctNo;
  String? icNo;
  String? balance;
  String? insCom1;
  String? insCom2;
  String? expDt;
  String? nextInspectDt;
  String? transtamp;
  String? inUsed;
  String? deleted;
  String? createUser;
  String? createDate;
  String? editUser;
  String? editDate;
  String? compCode;
  String? branchCode;
  String? rowKey;
  String? lastupload;
  String? merchantNo;
  String? iD;
  String? nonActive;
  String? diCode;
  String? lastEditedBy;
  String? createdBy;

  VehicleList(
      {this.vehNo,
      this.groupId,
      this.trnCode,
      this.carNo,
      this.model,
      this.engNo,
      this.chasisNo,
      this.typeModel,
      this.year,
      this.make,
      this.rdtaxExp,
      this.sm3No,
      this.sm3Siri,
      this.sm3IsuDt,
      this.sm3ExpDt,
      this.inspDt,
      this.nxOilChg,
      this.nxFilChg,
      this.capacity,
      this.kegunaan,
      this.tonage,
      this.rtExpDt,
      this.jpjRec,
      this.ispDate,
      this.ispRecNo,
      this.acctNo,
      this.icNo,
      this.balance,
      this.insCom1,
      this.insCom2,
      this.expDt,
      this.nextInspectDt,
      this.transtamp,
      this.inUsed,
      this.deleted,
      this.createUser,
      this.createDate,
      this.editUser,
      this.editDate,
      this.compCode,
      this.branchCode,
      this.rowKey,
      this.lastupload,
      this.merchantNo,
      this.iD,
      this.nonActive,
      this.diCode,
      this.lastEditedBy,
      this.createdBy});

  VehicleList.fromJson(Map<String, dynamic> json) {
    vehNo = json['veh_no'];
    groupId = json['group_id'];
    trnCode = json['trn_code'];
    carNo = json['car_no'];
    model = json['model'];
    engNo = json['eng_no'];
    chasisNo = json['chasis_no'];
    typeModel = json['type_model'];
    year = json['year'];
    make = json['make'];
    rdtaxExp = json['rdtax_exp'];
    sm3No = json['sm3_no'];
    sm3Siri = json['sm3_siri'];
    sm3IsuDt = json['sm3_isu_dt'];
    sm3ExpDt = json['sm3_exp_dt'];
    inspDt = json['insp_dt'];
    nxOilChg = json['nx_oil_chg'];
    nxFilChg = json['nx_fil_chg'];
    capacity = json['capacity'];
    kegunaan = json['kegunaan'];
    tonage = json['tonage'];
    rtExpDt = json['rt_exp_dt'];
    jpjRec = json['jpj_rec'];
    ispDate = json['isp_date'];
    ispRecNo = json['isp_rec_no'];
    acctNo = json['acct_no'];
    icNo = json['ic_no'];
    balance = json['balance'];
    insCom1 = json['ins_com1'];
    insCom2 = json['ins_com2'];
    expDt = json['exp_dt'];
    nextInspectDt = json['next_inspect_dt'];
    transtamp = json['transtamp'];
    inUsed = json['in_used'];
    deleted = json['deleted'];
    createUser = json['create_user'];
    createDate = json['create_date'];
    editUser = json['edit_user'];
    editDate = json['edit_date'];
    compCode = json['comp_code'];
    branchCode = json['branch_code'];
    rowKey = json['row_key'];
    lastupload = json['lastupload'];
    merchantNo = json['merchant_no'];
    iD = json['ID'];
    nonActive = json['non_active'];
    diCode = json['di_code'];
    lastEditedBy = json['last_edited_by'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['veh_no'] = vehNo;
    data['group_id'] = groupId;
    data['trn_code'] = trnCode;
    data['car_no'] = carNo;
    data['model'] = model;
    data['eng_no'] = engNo;
    data['chasis_no'] = chasisNo;
    data['type_model'] = typeModel;
    data['year'] = year;
    data['make'] = make;
    data['rdtax_exp'] = rdtaxExp;
    data['sm3_no'] = sm3No;
    data['sm3_siri'] = sm3Siri;
    data['sm3_isu_dt'] = sm3IsuDt;
    data['sm3_exp_dt'] = sm3ExpDt;
    data['insp_dt'] = inspDt;
    data['nx_oil_chg'] = nxOilChg;
    data['nx_fil_chg'] = nxFilChg;
    data['capacity'] = capacity;
    data['kegunaan'] = kegunaan;
    data['tonage'] = tonage;
    data['rt_exp_dt'] = rtExpDt;
    data['jpj_rec'] = jpjRec;
    data['isp_date'] = ispDate;
    data['isp_rec_no'] = ispRecNo;
    data['acct_no'] = acctNo;
    data['ic_no'] = icNo;
    data['balance'] = balance;
    data['ins_com1'] = insCom1;
    data['ins_com2'] = insCom2;
    data['exp_dt'] = expDt;
    data['next_inspect_dt'] = nextInspectDt;
    data['transtamp'] = transtamp;
    data['in_used'] = inUsed;
    data['deleted'] = deleted;
    data['create_user'] = createUser;
    data['create_date'] = createDate;
    data['edit_user'] = editUser;
    data['edit_date'] = editDate;
    data['comp_code'] = compCode;
    data['branch_code'] = branchCode;
    data['row_key'] = rowKey;
    data['lastupload'] = lastupload;
    data['merchant_no'] = merchantNo;
    data['ID'] = iD;
    data['non_active'] = nonActive;
    data['di_code'] = diCode;
    data['last_edited_by'] = lastEditedBy;
    data['created_by'] = createdBy;
    return data;
  }
}