import 'dart:convert';

import 'package:edriving_spim_app/common_library/services/model/instructor_model.dart';
import 'package:edriving_spim_app/common_library/services/networking.dart';
import 'package:edriving_spim_app/common_library/services/response.dart';
import 'package:edriving_spim_app/common_library/utils/local_storage.dart';
import 'package:edriving_spim_app/utils/app_config.dart';

class InstructorRepo{
  final appConfig = AppConfig();
  final localStorage = LocalStorage();
  final networking = Networking();

  Future<Response> getTrainerList({
    required context,
    startIndex,
    noOfRecords,
    groupId,
    keywordSearch
    }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? mLoginId = await localStorage.getUserPhone();
    String? deviceId = await localStorage.getLoginDeviceId();
    String? diCode = await localStorage.getMerchantDbCode();
    String? appId = appConfig.appId;

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&appId=$appId&mLoginId=$mLoginId&deviceId=$deviceId&diCode=$diCode&startIndex=$startIndex&noOfRecords=$noOfRecords&groupId=$groupId&keywordSearch=$keywordSearch';

    var response = await networking.getData(
      path: 'GetTrainerList?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetInstructorResponse getInstructorResponse =
          GetInstructorResponse.fromJson(response.data);


      return Response(true, data: getInstructorResponse.trainerList);
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

  Future<Response> getTrainerInfo({context}) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? mLoginId = await localStorage.getUserPhone();
    String? deviceId = await localStorage.getLoginDeviceId();
    String? diCode = await localStorage.getMerchantDbCode();
    String? appId = appConfig.appId;

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&appId=$appId&mLoginId=$mLoginId&deviceId=$deviceId&diCode=$diCode';
  
    var response = await networking.getData(
      path: 'GetTrainerInfo?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetTrainerInfoResponse getTrainerInfoResponse =
          GetTrainerInfoResponse.fromJson(response.data);


      return Response(true, data: getTrainerInfoResponse.trainerInfo);
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

  
  Future<Response> deleteInstructor({context}) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? mLoginId = await localStorage.getUserPhone();
    String? deviceId = await localStorage.getLoginDeviceId();
    String? diCode = await localStorage.getMerchantDbCode();
    String? trnCode = await localStorage.getTrnCode();

    DeleteInstructorRequest deleteInstructorRequest = 
      DeleteInstructorRequest(
        wsCodeCrypt: appConfig.wsCodeCrypt,
        caUid: caUid,
        caPwd: caPwd,
        mLoginId: mLoginId,
        deviceId: deviceId,
        diCode: diCode,
        appId: appConfig.appId,
        trnCode: trnCode,
      );

    String body = jsonEncode(deleteInstructorRequest);
    String api = 'DeleteTrainer';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    var response =
        await networking.postData(api: api, body: body, headers: headers);

    if (response.data == 'True') {
      // await localStorage.reset();
      // Hive.box('ws_url').clear();
      // Hive.box('telcoList').clear();
      // Hive.box('serviceList').clear();

      return Response(true, message: 'This trainer has been deleted.');
    }

    return Response(false,
        message: 'Failed to delete trainer. Please try again later.');
  }
}