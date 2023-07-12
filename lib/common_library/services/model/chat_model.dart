class GetUserByUserPhoneResponse {
  List<User>? user;

  GetUserByUserPhoneResponse({this.user});

  GetUserByUserPhoneResponse.fromJson(Map<String, dynamic> json) {
    if (json['User'] != null) {
      user = <User>[];
      json['User'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['User'] = this.user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? id;
  String? userId;
  String? appCode;
  String? appId;
  String? appVersion;
  String? phone;
  String? firstName;
  String? lastName;
  String? nickName;
  String? eMail;
  String? add;
  String? add1;
  String? add2;
  String? add3;
  String? add4;
  String? postcode;
  String? cityName;
  String? stateName;
  String? countryName;
  String? icNo;
  String? birthDate;
  String? nationality;
  String? race;
  String? gender;
  String? userPwd;
  String? tmpUserPwd;
  String? accessCode;
  String? branch;
  String? empno;
  String? userPhoto;
  String? userPhotoFilename;
  String? webBrowserUrl;
  String? deleted;
  String? createUser;
  String? createDate;
  String? editUser;
  String? editDate;
  String? compCode;
  String? branchCode;
  String? rowKey;
  String? transtamp;
  String? merchantNo;
  String? loginId;
  String? city;
  String? state;
  String? country;
  String? name;
  String? reportGps;
  String? gpsCheckSecond;
  String? lastupload;
  String? diCode;
  String? lastEditedBy;
  String? createdBy;

  User(
      {this.id,
      this.userId,
      this.appCode,
      this.appId,
      this.appVersion,
      this.phone,
      this.firstName,
      this.lastName,
      this.nickName,
      this.eMail,
      this.add,
      this.add1,
      this.add2,
      this.add3,
      this.add4,
      this.postcode,
      this.cityName,
      this.stateName,
      this.countryName,
      this.icNo,
      this.birthDate,
      this.nationality,
      this.race,
      this.gender,
      this.userPwd,
      this.tmpUserPwd,
      this.accessCode,
      this.branch,
      this.empno,
      this.userPhoto,
      this.userPhotoFilename,
      this.webBrowserUrl,
      this.deleted,
      this.createUser,
      this.createDate,
      this.editUser,
      this.editDate,
      this.compCode,
      this.branchCode,
      this.rowKey,
      this.transtamp,
      this.merchantNo,
      this.loginId,
      this.city,
      this.state,
      this.country,
      this.name,
      this.reportGps,
      this.gpsCheckSecond,
      this.lastupload,
      this.diCode,
      this.lastEditedBy,
      this.createdBy});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    appCode = json['app_code'];
    appId = json['app_id'];
    appVersion = json['app_version'];
    phone = json['phone'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    nickName = json['nick_name'];
    eMail = json['e_mail'];
    add = json['add'];
    add1 = json['add1'];
    add2 = json['add2'];
    add3 = json['add3'];
    add4 = json['add4'];
    postcode = json['postcode'];
    cityName = json['city_name'];
    stateName = json['state_name'];
    countryName = json['country_name'];
    icNo = json['ic_no'];
    birthDate = json['birth_date'];
    nationality = json['nationality'];
    race = json['race'];
    gender = json['gender'];
    userPwd = json['user_pwd'];
    tmpUserPwd = json['tmp_user_pwd'];
    accessCode = json['access_code'];
    branch = json['branch'];
    empno = json['empno'];
    userPhoto = json['user_photo'];
    userPhotoFilename = json['user_photo_filename'];
    webBrowserUrl = json['web_browser_url'];
    deleted = json['deleted'];
    createUser = json['create_user'];
    createDate = json['create_date'];
    editUser = json['edit_user'];
    editDate = json['edit_date'];
    compCode = json['comp_code'];
    branchCode = json['branch_code'];
    rowKey = json['row_key'];
    transtamp = json['transtamp'];
    merchantNo = json['merchant_no'];
    loginId = json['login_id'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    name = json['name'];
    reportGps = json['report_gps'];
    gpsCheckSecond = json['gps_check_second'];
    lastupload = json['lastupload'];
    diCode = json['di_code'];
    lastEditedBy = json['last_edited_by'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['app_code'] = this.appCode;
    data['app_id'] = this.appId;
    data['app_version'] = this.appVersion;
    data['phone'] = this.phone;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['nick_name'] = this.nickName;
    data['e_mail'] = this.eMail;
    data['add'] = this.add;
    data['add1'] = this.add1;
    data['add2'] = this.add2;
    data['add3'] = this.add3;
    data['add4'] = this.add4;
    data['postcode'] = this.postcode;
    data['city_name'] = this.cityName;
    data['state_name'] = this.stateName;
    data['country_name'] = this.countryName;
    data['ic_no'] = this.icNo;
    data['birth_date'] = this.birthDate;
    data['nationality'] = this.nationality;
    data['race'] = this.race;
    data['gender'] = this.gender;
    data['user_pwd'] = this.userPwd;
    data['tmp_user_pwd'] = this.tmpUserPwd;
    data['access_code'] = this.accessCode;
    data['branch'] = this.branch;
    data['empno'] = this.empno;
    data['user_photo'] = this.userPhoto;
    data['user_photo_filename'] = this.userPhotoFilename;
    data['web_browser_url'] = this.webBrowserUrl;
    data['deleted'] = this.deleted;
    data['create_user'] = this.createUser;
    data['create_date'] = this.createDate;
    data['edit_user'] = this.editUser;
    data['edit_date'] = this.editDate;
    data['comp_code'] = this.compCode;
    data['branch_code'] = this.branchCode;
    data['row_key'] = this.rowKey;
    data['transtamp'] = this.transtamp;
    data['merchant_no'] = this.merchantNo;
    data['login_id'] = this.loginId;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['name'] = this.name;
    data['report_gps'] = this.reportGps;
    data['gps_check_second'] = this.gpsCheckSecond;
    data['lastupload'] = this.lastupload;
    data['di_code'] = this.diCode;
    data['last_edited_by'] = this.lastEditedBy;
    data['created_by'] = this.createdBy;
    return data;
  }
}

class UserProfileWithPhone {
  String? iD;
  String? userId;
  String? phone;
  String? firstName;

  UserProfileWithPhone({this.iD, this.userId, this.phone, this.firstName});

  UserProfileWithPhone.fromJson(Map<String, dynamic> json) {
    iD = json['id'];
    userId = json['user_id'];
    phone = json['phone'];
    firstName = json['first_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.iD;
    data['user_id'] = this.userId;
    data['phone'] = this.phone;
    data['first_name'] = this.firstName;
    return data;
  }
}

class Message {
  String? id;
  String? author;
  String? target;
  String? data;
  int? sentDateTime;
  String? type;
  String? isSeen;

  MessageBody? body;

  Message(
      {this.id,
      this.author,
      this.target,
      this.body,
      this.data,
      this.sentDateTime,
      this.type,
      this.isSeen});

  factory Message.fromJson(Map<String, dynamic> json) => new Message(
      id: json['id'],
      author: json['author'],
      target: json['target'],
      //body: MessageBody.fromJson(json['body'])
      data: json['data'],
      sentDateTime: json['sent_date_time'],
      type: json['type'],
      isSeen: json['is_seen']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'target': target,
        'data': data,
        'sent_date_time': sentDateTime,
        'type': type,
        'is_seen': isSeen,
      };
}

class MessageBody {
  String? data;
  String? sentDateTime;
  String? type;
  String? isSeen;

  MessageBody({this.data, this.sentDateTime, this.type, this.isSeen});

  factory MessageBody.fromJson(Map<String, dynamic> json) => new MessageBody(
      data: json['data'],
      sentDateTime: json['sentDateTime'],
      type: json['type'],
      isSeen: json['isSeen']);

  Map<String, dynamic> toJson() => {
        'data': data,
        'sentDateTime': sentDateTime,
        'type': type,
        'isSeen': isSeen
      };
}

class MessageAndAuthorTable {
  String? id;
  String? author;
  String? data;
  int? sentDateTime;
  String? type;
  String? isSeen;

  MessageAndAuthorTable(
      {this.id,
      this.author,
      this.data,
      this.sentDateTime,
      this.type,
      this.isSeen});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'author': author,
      'data': data,
      'sent_date_time': sentDateTime,
      'type': type,
      'is_seen': isSeen,
    };
    return map;
  }

  MessageAndAuthorTable.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    author = map['author'];
    data = map['data'];
    sentDateTime = map['sent_date_time'];
    type = map['type'];
    isSeen = map['is_seen'];
  }
}

class MessageTargetTable {
  String? id;
  String? messageId;
  String? targetId;

  MessageTargetTable({
    this.id,
    this.messageId,
    this.targetId,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'message_id': messageId,
      'target_id': targetId,
    };
    return map;
  }

  MessageTargetTable.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    messageId = map['message_id'];
    targetId = map['target_id'];
  }
}
