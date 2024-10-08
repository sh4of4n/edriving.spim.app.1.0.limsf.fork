import 'dart:convert';

import '/common_library/utils/custom_dialog.dart';
import '../../../utils/app_config.dart';
import '../../utils/local_storage.dart';
import '../model/epandu_model.dart';
import '../networking.dart';
import '../response.dart';
import 'package:html_unescape/html_unescape_small.dart';

class EpanduRepo {
  final appConfig = AppConfig();
  final localStorage = LocalStorage();
  final networking = Networking();
  final unescape = HtmlUnescape();
  final customDialog = CustomDialog();

  Future<Response<List<Enroll>?>> getEnrollByCode({
    context,
    groupId,
    icNo
    }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();

    String? diCode = await localStorage.getMerchantDbCode();
    // String diCode = await localStorage.getMerchantDbCode();
    // String groupId = '';

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&icNo=$icNo&groupId=${groupId ?? ''}';

    Response response = await networking.getData(
      path: 'GetEnrollByCode?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetEnrollmentResponse getEnrollmentResponse;

      getEnrollmentResponse = GetEnrollmentResponse.fromJson(response.data);

      // not relevant anymore as there could be more than one enrollment
      // localStorage.saveEnrolledGroupId(getEnrollmentResponse.enroll[0].groupId);
      // localStorage.saveBlacklisted(getEnrollmentResponse.enroll[0].blacklisted);

      return Response(true, data: getEnrollmentResponse.enroll);
    }

    return Response(
      false,
      message: response.message == null || response.message!.isEmpty
          ? 'You have no class enrolled.'
          : response.message!.replaceAll(r'\u000d\u000a', ''),
    );
  }

  Future<Response> getCollectionByStudent(
      {required context, startIndex}) async {
    assert(context != null);

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();

    String? diCode = await localStorage.getMerchantDbCode();
    // String diCode = await localStorage.getMerchantDbCode();
    String? icNo = await localStorage.getStudentIc();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&icNo=$icNo&startIndex=$startIndex&noOfRecords=10';

    var response = await networking.getData(
      path: 'GetCollectionByStudentV2?$path',
    );

    if (response.isSuccess && response.data != null) {
      StudentPaymentResponse studentPaymentResponse;

      studentPaymentResponse = StudentPaymentResponse.fromJson(response.data);

      return Response(true, data: studentPaymentResponse.collectTrn);
    }

    return Response(false,
        message: response.message == null || response.message!.isEmpty
            ? 'You have no payment history'
            : response.message!.replaceAll(r'\u000d\u000a', ''));
  }

  Future<Response> getCollectionDetailByRecpNo(
      {required context, recpNo}) async {
    assert(context != null);

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();

    String? diCode = await localStorage.getMerchantDbCode();
    // String diCode = await localStorage.getMerchantDbCode();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&recpNo=$recpNo';

    var response = await networking.getData(
      path: 'GetCollectionDetailByRecpNo?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetCollectionDetailByRecpNoResponse getCollectionDetailByRecpNoResponse;

      getCollectionDetailByRecpNoResponse =
          GetCollectionDetailByRecpNoResponse.fromJson(response.data);

      return Response(true,
          data: getCollectionDetailByRecpNoResponse.collectDetail);
    }

    return Response(
      false,
      message: response.message == null || response.message!.isEmpty
          ? 'No records found.'
          : response.message!.replaceAll(r'\u000d\u000a', ''),
    );
  }

  Future<Response> getDTestByCode({
    required context,
    icNo
  }) async {
    assert(context != null);

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();

    String? diCode = await localStorage.getMerchantDbCode();
    // String diCode = await localStorage.getMerchantDbCode();
    // String groupId = await localStorage.getEnrolledGroupId();
    // String? icNo = await localStorage.getStudentIc();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&icNo=$icNo&groupId=';

    var response = await networking.getData(
      path: 'GetDTestByCode?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetDTestByCodeResponse getDTestByCodeResponse;

      getDTestByCodeResponse = GetDTestByCodeResponse.fromJson(response.data);

      return Response(true, data: getDTestByCodeResponse.dTest);
    }

    return Response(false,
        message: response.message == null || response.message!.isEmpty
            ? 'You have no booking.'
            : response.message!.replaceAll(r'\u000d\u000a', ''));
  }

  // attendance
  Future<Response> getStuPracByCode({required context}) async {
    assert(context != null);

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();

    String? diCode = await localStorage.getMerchantDbCode();
    // String diCode = await localStorage.getMerchantDbCode();
    // String groupId = await localStorage.getEnrolledGroupId();
    String? icNo = await localStorage.getStudentIc();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&groupId=&icNo=$icNo';

    var response = await networking.getData(
      path: 'GetStuPracByCode?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetStuPracByCodeResponse getStuPracByCodeResponse;

      getStuPracByCodeResponse =
          GetStuPracByCodeResponse.fromJson(response.data);

      return Response(true, data: getStuPracByCodeResponse.stuPrac);
    }

    return Response(false,
        message: response.message == null || response.message!.isEmpty
            ? 'You have no attendance record.'
            : response.message!.replaceAll(r'\u000d\u000a', ''));
  }

  // booking
  /* Future<Response> getBookingTest({
    context,
    groupId,
    testType,
  }) async {
    assert(context != null);

    String caUid = await localStorage.getCaUid();
    String caPwd = await localStorage.getCaPwdEncode();

    String diCode = await localStorage.getMerchantDbCode();
    // String groupId = await localStorage.getEnrolledGroupId();
    String icNo = await localStorage.getStudentIc();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&groupId=${groupId ?? ''}&testType=${testType ?? ''}&icNo=$icNo';

    var response = await networking.getData(
      path: 'GetBookingTest?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetBookingTestResponse getBookingTestResponse;

      getBookingTestResponse = GetBookingTestResponse.fromJson(response.data);

      return Response(true, data: getBookingTestResponse.dTest);
    } else if (response.message != null &&
        response.message.contains('timeout')) {
      return Response(false,
          message: AppLocalizations.of(context).translate('timeout_exception'));
    } else if (response.message != null &&
        response.message.contains('socket')) {
      return Response(false,
          message: AppLocalizations.of(context).translate('socket_exception'));
    } else if (response.message != null && response.message.contains('http')) {
      return Response(false,
          message: AppLocalizations.of(context).translate('http_exception'));
    } else if (response.message != null &&
        response.message.contains('format')) {
      return Response(false,
          message: AppLocalizations.of(context).translate('format_exception'));
    }

    return Response(false,
        message: AppLocalizations.of(context).translate('no_records_found'));
  } */

  Future<Response> getTestListGroupId({
    required context,
  }) async {
    assert(context != null);

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();

    String? diCode = await localStorage.getMerchantDbCode();
    // String groupId = await localStorage.getEnrolledGroupId();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode';

    var response = await networking.getData(
      path: 'GetTestListGroupId?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetTestListGroupIdResponse getTestListGroupIdResponse;

      getTestListGroupIdResponse =
          GetTestListGroupIdResponse.fromJson(response.data);

      return Response(true, data: getTestListGroupIdResponse.test);
    }

    return Response(
      false,
      message: response.message == null || response.message!.isEmpty
          ? 'No records found.'
          : response.message!.replaceAll(r'\u000d\u000a', ''),
    );
  }

  Future<Response> getTestListGroupIdByIcNo({
    required context,
  }) async {
    assert(context != null);

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();
    String? icNo = await localStorage.getStudentIc();
    String? diCode = await localStorage.getMerchantDbCode();
    // String groupId = await localStorage.getEnrolledGroupId();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&icNo=$icNo';

    var response = await networking.getData(
      path: 'GetTestListGroupIdByIcNo?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetTestListGroupIdResponse getTestListGroupIdResponse;

      getTestListGroupIdResponse =
          GetTestListGroupIdResponse.fromJson(response.data);

      return Response(true, data: getTestListGroupIdResponse.test);
    }

    return Response(
      false,
      message: response.message == null || response.message!.isEmpty
          ? 'No records found.'
          : response.message!.replaceAll(r'\u000d\u000a', ''),
    );
  }

  Future<Response> getTestListTestType({
    required context,
    groupId,
  }) async {
    assert(context != null);

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();

    String? diCode = await localStorage.getMerchantDbCode();
    // String groupId = await localStorage.getEnrolledGroupId();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&groupId=$groupId';

    var response = await networking.getData(
      path: 'GetTestListTestType?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetTestListTestTypeResponse getTestListTestTypeResponse;

      getTestListTestTypeResponse =
          GetTestListTestTypeResponse.fromJson(response.data);

      return Response(true, data: getTestListTestTypeResponse.test);
    }

    return Response(
      false,
      message: response.message == null || response.message!.isEmpty
          ? 'No records found.'
          : response.message!.replaceAll(r'\u000d\u000a', ''),
    );
  }

  Future<Response> getTestList({
    required context,
    groupId,
    testType,
  }) async {
    assert(context != null);

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();

    String? diCode = await localStorage.getMerchantDbCode();
    // String groupId = await localStorage.getEnrolledGroupId();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&groupId=${groupId ?? ''}&testType=${testType ?? ''}';

    var response = await networking.getData(
      path: 'GetTestList?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetTestListResponse getTestListResponse;

      getTestListResponse = GetTestListResponse.fromJson(response.data);

      return Response(true, data: getTestListResponse.test);
    }

    return Response(
      false,
      message: response.message == null || response.message!.isEmpty
          ? 'No records found.'
          : response.message!.replaceAll(r'\u000d\u000a', ''),
    );
  }

  Future<Response> getCourseSectionList({
    required context,
    groupId,
  }) async {
    assert(context != null);

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();

    String? diCode = await localStorage.getMerchantDbCode();
    // String groupId = await localStorage.getEnrolledGroupId();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&groupId=${groupId ?? ''}';

    var response = await networking.getData(
      path: 'GetCourseSectionList?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetCourseSectionListResponse getCourseSectionListResponse;

      getCourseSectionListResponse =
          GetCourseSectionListResponse.fromJson(response.data);

      return Response(true, data: getCourseSectionListResponse.courseSection);
    }

    return Response(
      false,
      message: response.message == null || response.message!.isEmpty
          ? 'No records found.'
          : response.message!.replaceAll(r'\u000d\u000a', ''),
    );
  }

  Future<Response> saveBookingTest({
    context,
    userId,
    groupId,
    testType,
    testDate,
    courseSection,
  }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? diCode = await localStorage.getMerchantDbCode();
    String? icNo = await localStorage.getStudentIc();

    SaveBookingTestRequest saveUserPasswordRequest = SaveBookingTestRequest(
      wsCodeCrypt: appConfig.wsCodeCrypt,
      caUid: caUid,
      caPwd: caPwd,
      diCode: diCode,
      groupId: groupId,
      testType: testType,
      testDate: testDate,
      courseSection: courseSection,
      icNo: icNo,
      userId: userId,
    );

    String body = jsonEncode(saveUserPasswordRequest);
    String api = 'SaveBookingTest';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    var response =
        await networking.postData(api: api, body: body, headers: headers);

    if (response.isSuccess && response.data == 'True') {
      return Response(true);
    }

    return Response(false,
        message: response.message!.replaceAll(r'\u000d\u000a', ''));
  }

  Future<Response> getJpjTestCheckIn() async {
    // String customUrl =
    //     'http://192.168.168.2/etesting.MainService/${appConfig.wsVer}/MainService.svc';

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();
    String? icNo = await localStorage.getStudentIc();
    String? userId = await localStorage.getUserId();

    String? diCode = await localStorage.getMerchantDbCode();
    // String groupId = await localStorage.getEnrolledGroupId();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&userId=$userId&icNo=$icNo';

    var response = await networking.getData(
      path: 'GetJpjTestCheckIn?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetJpjTestCheckInResponse getJpjTestCheckInResponse;

      getJpjTestCheckInResponse =
          GetJpjTestCheckInResponse.fromJson(response.data);

      return Response(true, data: getJpjTestCheckInResponse.jpjTestTrn);
    }

    return Response(
      false,
      message: response.message == null || response.message!.isEmpty
          ? 'Found no check in result. Unable to generate QR.'
          : response.message!.replaceAll(r'\u000d\u000a', ''),
    );
  }

  Future<Response> getLastJpjTestCheckInByInterval({
    String? intervalInSeconds,
  }) async {
    // String customUrl =
    //     'http://192.168.168.2/etesting.MainService/${appConfig.wsVer}/MainService.svc';

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();
    String? diCode = await localStorage.getMerchantDbCode();
    // String groupId = await localStorage.getEnrolledGroupId();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&intervalInSeconds=${intervalInSeconds ?? ''}';

    var response = await networking.getData(
      path: 'GetLastJpjTestCheckInByInterval?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetLastJpjTestCheckInByIntervalResponse
          getLastJpjTestCheckInByIntervalResponse;

      getLastJpjTestCheckInByIntervalResponse =
          GetLastJpjTestCheckInByIntervalResponse.fromJson(response.data);

      return Response(true,
          data: getLastJpjTestCheckInByIntervalResponse.jpjTestTrn);
    }

    return Response(
      false,
      message: response.message == null || response.message!.isEmpty
          ? 'No records found.'
          : response.message!.replaceAll(r'\u000d\u000a', ''),
    );
  }

  Future<Response> verifyScanCode({
    context,
    required qrcodeJson,
    required icNo,
  }) async {
    // String customUrl =
    //     'http://192.168.168.2/etesting.MainService/${appConfig.wsVer}/MainService.svc';

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? diCode = await localStorage.getMerchantDbCode();
    String? userId = await localStorage.getUserId();

    VerifyScanCodeRequest verifyScanCodeRequest = VerifyScanCodeRequest(
      wsCodeCrypt: appConfig.wsCodeCrypt,
      caUid: caUid,
      caPwd: caPwd,
      icNo: icNo,
      diCode: diCode,
      userId: userId,
      qrcodeJson: qrcodeJson,
    );

    /* customDialog.show(
      context: context,
      title: Text('$customUrl/webapi/VerifyScanCodeByIcNo'),
      content:
          'wsCodeCrypt: ${appConfig.wsCodeCrypt}, caUid: $caUid, caPwd: $caPwd, icNo: $icNo, merchantNo: $diCode, userId: $userId, qrCodeJson: $qrcodeJson',
      customActions: [
        TextButton(
          child: Text(AppLocalizations.of(context).translate('ok_btn')),
          onPressed: () => ExtendedNavigator.of(context).pop(),
        ),
      ],
      type: DialogType.GENERAL,
    ); */

    String body = jsonEncode(verifyScanCodeRequest);
    String api = 'VerifyScanCodeByIcNo';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    var response =
        await networking.postData(api: api, body: body, headers: headers);

    if (response.isSuccess && response.data != null) {
      VerifyScanCodeResponse verifyScanCodeResponse =
          VerifyScanCodeResponse.fromJson(response.data);

      return Response(true, data: verifyScanCodeResponse.jpjTestTrn);
    }

    return Response(false,
        message: response.message == null || response.message!.isEmpty
            ? 'Queue number not created. Please try again.'
            : response.message!.replaceAll(r'\u000d\u000a', ''));
  }

  Future<Response> getScanCodeByAction() async {
    // String customUrl =
    //     'https://192.168.168.2/etesting.MainService/${appConfig.wsVer}/MainService.svc';

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();
    String? diCode = await localStorage.getMerchantDbCode();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&userId=&action=JPJ_PART2_CHECK_IN';

    var response = await networking.getData(
      path: 'GetScanCodeByAction?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetScanCodeByActionResponse getScanCodeByActionResponse =
          GetScanCodeByActionResponse.fromJson(response.data);

      return Response(true, data: getScanCodeByActionResponse.table1);
    }

    return Response(false,
        message: response.message == null || response.message!.isEmpty
            ? 'Failed to receive QR code data. Please try again.'
            : response.message!.replaceAll(r'\u000d\u000a', ''));
  }

  Future<Response> getLastCallingJpjTestQueueNumber({context}) async {
    // String customUrl =
    //     'http://192.168.168.2/etesting.MainService/${appConfig.wsVer}/MainService.svc';

    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwdEncode();
    String? diCode = await localStorage.getMerchantDbCode();

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode';

    /* customDialog.show(
      context: context,
      title: Text('GetLastCallingJpjTestQueueNumber'),
      content:
          '$customUrl/webapi/GetLastCallingJpjTestQueueNumber?wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=W1007',
      customActions: [
        TextButton(
          child: Text(AppLocalizations.of(context).translate('ok_btn')),
          onPressed: () => ExtendedNavigator.of(context).pop(),
        ),
      ],
      type: DialogType.GENERAL,
    ); */

    var response = await networking.getData(
      path: 'GetLastCallingJpjTestQueueNumber?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetLastCallingJpjTestQueueNumberResponse
          getLastCallingJpjTestQueueNumberResponse =
          GetLastCallingJpjTestQueueNumberResponse.fromJson(response.data);

      return Response(true,
          data: getLastCallingJpjTestQueueNumberResponse.jpjTestTrn);
    }

    return Response(false,
        message: response.message == null || response.message!.isEmpty
            ? 'Tiada nombor giliran semasa.'
            : response.message!.replaceAll(r'\u000d\u000a', ''));
  }
}
