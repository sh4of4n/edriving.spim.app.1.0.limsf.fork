import 'dart:convert';

import 'package:edriving_spim_app/common_library/services/model/class_model.dart';
import 'package:edriving_spim_app/common_library/services/networking.dart';
import 'package:edriving_spim_app/common_library/services/response.dart';
import 'package:edriving_spim_app/common_library/utils/local_storage.dart';
import 'package:edriving_spim_app/utils/app_config.dart';

class ClassRepo{
  final appConfig = AppConfig();
  final localStorage = LocalStorage();
  final networking = Networking();

  Future<Response> getProgressClass({
    required context,
    groupId,
    trnCode,
    icNo,
    startIndex,
    noOfRecords,
    keywordSearch
  }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? diCode = await localStorage.getMerchantDbCode();

    String path = 
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&groupId=$groupId&trnCode=$trnCode&icNo=$icNo&startIndex=$startIndex&noOfRecords=$noOfRecords&keywordSearch=$keywordSearch';

    var response = await networking.getData(
      path: 'GetTodayInProgressStuPrac?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetProgressClassResponse getClassResponse =
          GetProgressClassResponse.fromJson(response.data);


      return Response(true, data: getClassResponse.progressClassList);
    } else if (response.message != null &&
        response.message!.contains('timeout')) {
      return Response(false,
          message: 'Data took too long to load, please try again.');
    } else if (response.message != null &&
        response.message!.contains('socket')) {
      return Response(false,
          message: 'Our servers appear to be down. Please try again later.');
    } else if (response.message != null && response.message!.contains('http')) {
      return Response(false,
          message: 'Server error, we apologize for any inconvenience.');
    } else if (response.message != null &&
        response.message!.contains('format')) {
      return Response(false, message: 'Please verify your client account.');
    }

    return Response(false, message: response.message);
  }

  Future<Response> getTodayClass({
    required context,
    groupId,
    trnCode,
    icNo,
    startIndex,
    noOfRecords
  }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? diCode = await localStorage.getMerchantDbCode();

    String path = 
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&groupId=$groupId&trnCode=$trnCode&icNo=$icNo&startIndex=$startIndex&noOfRecords=$noOfRecords';

    var response = await networking.getData(
      path: 'GetTodayTimeTableList?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetTodayClassResponse getTodayClassResponse =
          GetTodayClassResponse.fromJson(response.data);


      return Response(true, data: getTodayClassResponse.todayClassList);
    } else if (response.message != null &&
        response.message!.contains('timeout')) {
      return Response(false,
          message: 'Data took too long to load, please try again.');
    } else if (response.message != null &&
        response.message!.contains('socket')) {
      return Response(false,
          message: 'Our servers appear to be down. Please try again later.');
    } else if (response.message != null && response.message!.contains('http')) {
      return Response(false,
          message: 'Server error, we apologize for any inconvenience.');
    } else if (response.message != null &&
        response.message!.contains('format')) {
      return Response(false, message: 'Please verify your client account.');
    }

    return Response(false, message: response.message);
  }

  Future<Response> getCompleteClass({
    required context,
    groupId,
    trnCode,
    icNo,
    startIndex,
    noOfRecords,
    keywordSearch
  }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? diCode = await localStorage.getMerchantDbCode();

    String path = 
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&groupId=$groupId&trnCode=$trnCode&icNo=$icNo&startIndex=$startIndex&noOfRecords=$noOfRecords&keywordSearch=$keywordSearch';

    var response = await networking.getData(
      path: 'GetTodayCompleteStuPrac?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetCompleteClassResponse getCompleteClassResponse =
          GetCompleteClassResponse.fromJson(response.data);


      return Response(true, data: getCompleteClassResponse.completeClassList);
    } else if (response.message != null &&
        response.message!.contains('timeout')) {
      return Response(false,
          message: 'Data took too long to load, please try again.');
    } else if (response.message != null &&
        response.message!.contains('socket')) {
      return Response(false,
          message: 'Our servers appear to be down. Please try again later.');
    } else if (response.message != null && response.message!.contains('http')) {
      return Response(false,
          message: 'Server error, we apologize for any inconvenience.');
    } else if (response.message != null &&
        response.message!.contains('format')) {
      return Response(false, message: 'Please verify your client account.');
    }

    return Response(false, message: response.message);
  }

  Future<Response> getStuPracByTrnCode({
    required context,
    trnCode,
    groupId,
    icNo,
    dateFromString,
    dateToString,
    startIndex,
    noOfRecords,
    keywordSearch
  }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? diCode = await localStorage.getMerchantDbCode();

    String path = 
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&trnCode=$trnCode&groupId=$groupId&icNo=$icNo&dateFromString=$dateFromString&dateToString=$dateToString&startIndex=$startIndex&noOfRecords=$noOfRecords&keywordSearch=$keywordSearch';

    var response = await networking.getData(
      path: 'GetStuPracByTrnCode?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetStuPracResponse getStuPracResponse =
          GetStuPracResponse.fromJson(response.data);


      return Response(true, data: getStuPracResponse.stuPrac);
    } else if (response.message != null &&
        response.message!.contains('timeout')) {
      return Response(false,
          message: 'Data took too long to load, please try again.');
    } else if (response.message != null &&
        response.message!.contains('socket')) {
      return Response(false,
          message: 'Our servers appear to be down. Please try again later.');
    } else if (response.message != null && response.message!.contains('http')) {
      return Response(false,
          message: 'Server error, we apologize for any inconvenience.');
    } else if (response.message != null &&
        response.message!.contains('format')) {
      return Response(false, message: 'Please verify your client account.');
    }

    return Response(false, message: response.message);
  }

  Future<Response> saveStuPrac({
    context,
    required String? icNo,
    required String? groupId,
    required String? startTime,
    String? endTime,
    required String courseCode,
    required String trandateString,
    required String trnCode,
    required String byFingerPrn,
    required String dsCode
  }) async {
    final String? caUid = await localStorage.getCaUid();
    final String? caPwd = await localStorage.getCaPwd();
    String? merchantNo = await localStorage.getMerchantDbCode();

    SaveStuPrac params = SaveStuPrac(
      wsCodeCrypt: appConfig.wsCodeCrypt,
      caUid: caUid,
      caPwd: caPwd,
      merchantNo: merchantNo,
      icNo: icNo,
      groupId: groupId,
      startTime: startTime,
      endTime: endTime ?? 'No Thumbout Yet',
      courseCode: courseCode,
      trandateString: trandateString,
      trnCode: trnCode,
      byFingerPrn: byFingerPrn,
      dsCode: dsCode
    );

    String body = jsonEncode(params);
    String api = 'SaveStuPrac';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    var response =
        await networking.postData(api: api, body: body, headers: headers);

    var message = '';

    //Success
    if (response.isSuccess && response.data != null) {
      message = 'Your request will be processed.';

      return Response(true, message: message);
    }
    //Fail
    message = 'Student Prac added failed. Please try again later.';

    return Response(false, message: response.message ?? message);
  }
}