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
    noOfRecords
  }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? diCode = await localStorage.getMerchantDbCode();

    String path = 
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&groupId=$groupId&trnCode=$trnCode&icNo=$icNo&startIndex=$startIndex&noOfRecords=$noOfRecords';

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
    noOfRecords
  }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? diCode = await localStorage.getMerchantDbCode();

    String path = 
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&groupId=$groupId&trnCode=$trnCode&icNo=$icNo&startIndex=$startIndex&noOfRecords=$noOfRecords';

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
}