class InviteRoom {
  String? wsCodeCrypt;
  String? caUid;
  String? caPwd;
  String? merchantNo;
  String? mLoginId;
  String? appId;
  String? deviceId;
  String? appCode;
  String? otherMLoginId;
  String? roomId;
  String? roomName;
  String? mLoginIdMember;
  InviteRoom(
      {this.wsCodeCrypt,
      this.caUid,
      this.caPwd,
      this.merchantNo,
      this.mLoginId,
      this.appId,
      this.deviceId,
      this.appCode,
      this.otherMLoginId,
      this.roomId,
      this.roomName,
      this.mLoginIdMember});

  InviteRoom.fromJson(Map<String, dynamic> json) {
    wsCodeCrypt = json['wsCodeCrypt'];
    caUid = json['caUid'];
    caPwd = json['caPwd'];
    merchantNo = json['merchantNo'];
    mLoginId = json['mLoginId'];
    appId = json['appId'];
    deviceId = json['deviceId'];
    appCode = json['appCode'];
    otherMLoginId = json['otherMLoginId'];
    roomId = json['roomId'];
    roomName = json['roomName'];
    mLoginIdMember = json['mLoginIdMember'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wsCodeCrypt'] = wsCodeCrypt;
    data['caUid'] = caUid;
    data['caPwd'] = caPwd;
    data['merchantNo'] = merchantNo;
    data['mLoginId'] = mLoginId;
    data['appId'] = appId;
    data['deviceId'] = deviceId;
    data['appCode'] = appCode;
    data['otherMLoginId'] = otherMLoginId;
    data['roomId'] = roomId;
    data['roomName'] = roomName;
    data['mLoginIdMember'] = mLoginIdMember;
    return data;
  }
}
