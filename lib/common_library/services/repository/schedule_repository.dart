import 'package:edriving_spim_app/common_library/services/model/schedule_model.dart';
import 'package:edriving_spim_app/common_library/services/networking.dart';
import 'package:edriving_spim_app/common_library/services/response.dart';
import 'package:edriving_spim_app/common_library/utils/local_storage.dart';
import 'package:edriving_spim_app/utils/app_config.dart';

class ScheduleRepo{
  final appConfig = AppConfig();
  final localStorage = LocalStorage();
  final networking = Networking();

  Future<Response> getTrainerSchedule({
    required context,
    dateFrom,
    dateTo,
    noOfRecords,
    startIndex,
    trnCode
  }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? diCode = await localStorage.getMerchantDbCode();
    String? userId = await localStorage.getUserId();

    String path = 
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&userId=$userId&trnCode=$trnCode&dateFrom=$dateFrom&dateTo=$dateTo&noOfRecords=$noOfRecords&startIndex=$startIndex';
  
    var response = await networking.getData(
      path: 'GetTimeTableListByTrnCode?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetScheduleResponse getScheduleResponse =
          GetScheduleResponse.fromJson(response.data);


      return Response(true, data: getScheduleResponse.trainerSchedule);
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

  Future<Response> getStudentLicense({
    required context,
    icNo,
    licenseType
  }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? diCode = await localStorage.getMerchantDbCode();
    // String? licenseType = 'LDL';

    String path = 
      'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&icNo=$icNo&licenseType=$licenseType';

    var response = await networking.getData(
      path: 'GetStudentLicenseByIcNo?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetStudentLicenseResponse getStudentLicenseResponse =
          GetStudentLicenseResponse.fromJson(response.data);


      return Response(true, data: getStudentLicenseResponse.studentLicense);
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