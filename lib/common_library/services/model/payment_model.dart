class GetPaymentStatusResponse{
  List<PaymentStatus>? paymentStatus;

  GetPaymentStatusResponse({this.paymentStatus});

  GetPaymentStatusResponse.fromJson(Map<String, dynamic> json){
    if (json['CollectTrn'] != null) {
      paymentStatus = <PaymentStatus>[];
      json['CollectTrn'].forEach((v) {
        paymentStatus!.add(PaymentStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (paymentStatus != null) {
      data['CollectTrn'] = paymentStatus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentStatus{
  String? jobNo;
  String? recpNo;
  String? serialType;
  String? trandate;
  String? trantime;
  String? vehNo;
  String? icNo;
  String? dsCode;
  String? tdefaAmt;
  String? thandChrg;
  String? tservChrg;
  String? tservTax;
  String? tranTotal;
  String? roundAmt;
  String? tranUser;
  String? payAmount;
  String? payMode;
  String? crdType;
  String? payRefno;
  String? balAmount;
  String? tlTaxAmt;
  String? cancelUser;
  String? cancelOn;
  String? cancel;
  String? transtamp;
  String? batchNo;
  String? cashAmount;
  String? chqAmount;
  String? ccAmount;
  String? remark;
  String? packageCode;
  String? commAmount;
  String? oriRecpno;
  String? oriStype;
  String? tcommAmt;
  String? tagentCommAmt;
  String? invDoc;
  String? invRef;
  String? compCode;
  String? branchCode;
  String? rowKey;
  String? lastupload;
  String? deleted;
  String? diCode;
  String? packageDesc;

  PaymentStatus(
      {this.jobNo,
      this.recpNo,
      this.serialType,
      this.trandate,
      this.trantime,
      this.vehNo,
      this.icNo,
      this.dsCode,
      this.tdefaAmt,
      this.thandChrg,
      this.tservChrg,
      this.tservTax,
      this.tranTotal,
      this.roundAmt,
      this.tranUser,
      this.payAmount,
      this.payMode,
      this.crdType,
      this.payRefno,
      this.balAmount,
      this.tlTaxAmt,
      this.cancelUser,
      this.cancelOn,
      this.cancel,
      this.transtamp,
      this.batchNo,
      this.cashAmount,
      this.chqAmount,
      this.ccAmount,
      this.remark,
      this.packageCode,
      this.commAmount,
      this.oriRecpno,
      this.oriStype,
      this.tcommAmt,
      this.tagentCommAmt,
      this.invDoc,
      this.invRef,
      this.compCode,
      this.branchCode,
      this.rowKey,
      this.lastupload,
      this.deleted,
      this.diCode,
      this.packageDesc});

  PaymentStatus.fromJson(Map<String, dynamic> json) {
    jobNo = json['job_no'] ?? '';
    recpNo = json['recp_no'] ?? '';
    serialType = json['serial_type'] ?? '';
    trandate = json['trandate'] ?? '';
    trantime = json['trantime'] ?? '';
    vehNo = json['veh_no'] ?? '';
    icNo = json['ic_no'] ?? '';
    dsCode = json['ds_code'] ?? '';
    tdefaAmt = json['tdefa_amt'] ?? '';
    thandChrg = json['thand_chrg'] ?? '';
    tservChrg = json['tserv_chrg'] ?? '';
    tservTax = json['tserv_tax'] ?? '';
    tranTotal = json['tran_total'] ?? '';
    roundAmt = json['round_amt'] ?? '';
    tranUser = json['tran_user'] ?? '';
    payAmount = json['pay_amount'] ?? '';
    payMode = json['pay_mode'] ?? '';
    crdType = json['crd_type'] ?? '';
    payRefno = json['pay_refno'] ?? '';
    balAmount = json['bal_amount'] ?? '';
    tlTaxAmt = json['tl_tax_amt'] ?? '';
    cancelUser = json['cancel_user'] ?? '';
    cancelOn = json['cancel_on'] ?? '';
    cancel = json['cancel'] ?? '';
    transtamp = json['transtamp'] ?? '';
    batchNo = json['batch_no'] ?? '';
    cashAmount = json['cash_amount'] ?? '';
    chqAmount = json['chq_amount'] ?? '';
    ccAmount = json['cc_amount'] ?? '';
    remark = json['remark'] ?? '';
    packageCode = json['package_code'] ?? '';
    commAmount = json['comm_amount'] ?? '';
    oriRecpno = json['ori_recpno'] ?? '';
    oriStype = json['ori_stype'] ?? '';
    tcommAmt = json['tcomm_amt'] ?? '';
    tagentCommAmt = json['tagent_comm_amt'] ?? '';
    invDoc = json['inv_doc'] ?? '';
    invRef = json['inv_ref'] ?? '';
    compCode = json['comp_code'] ?? '';
    branchCode = json['branch_code'] ?? '';
    rowKey = json['row_key'] ?? '';
    lastupload = json['lastupload'] ?? '';
    deleted = json['deleted'] ?? '';
    diCode = json['di_code'] ?? '';
    packageDesc = json['package_desc'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['job_no'] = jobNo;
    data['recp_no'] = recpNo;
    data['serial_type'] = serialType;
    data['trandate'] = trandate;
    data['trantime'] = trantime;
    data['veh_no'] = vehNo;
    data['ic_no'] = icNo;
    data['ds_code'] = dsCode;
    data['tdefa_amt'] = tdefaAmt;
    data['thand_chrg'] = thandChrg;
    data['tserv_chrg'] = tservChrg;
    data['tserv_tax'] = tservTax;
    data['tran_total'] = tranTotal;
    data['round_amt'] = roundAmt;
    data['tran_user'] = tranUser;
    data['pay_amount'] = payAmount;
    data['pay_mode'] = payMode;
    data['crd_type'] = crdType;
    data['pay_refno'] = payRefno;
    data['bal_amount'] = balAmount;
    data['tl_tax_amt'] = tlTaxAmt;
    data['cancel_user'] = cancelUser;
    data['cancel_on'] = cancelOn;
    data['cancel'] = cancel;
    data['transtamp'] = transtamp;
    data['batch_no'] = batchNo;
    data['cash_amount'] = cashAmount;
    data['chq_amount'] = chqAmount;
    data['cc_amount'] = ccAmount;
    data['remark'] = remark;
    data['package_code'] = packageCode;
    data['comm_amount'] = commAmount;
    data['ori_recpno'] = oriRecpno;
    data['ori_stype'] = oriStype;
    data['tcomm_amt'] = tcommAmt;
    data['tagent_comm_amt'] = tagentCommAmt;
    data['inv_doc'] = invDoc;
    data['inv_ref'] = invRef;
    data['comp_code'] = compCode;
    data['branch_code'] = branchCode;
    data['row_key'] = rowKey;
    data['lastupload'] = lastupload;
    data['deleted'] = deleted;
    data['di_code'] = diCode;
    data['package_desc'] = packageDesc;
    return data;
  }
}