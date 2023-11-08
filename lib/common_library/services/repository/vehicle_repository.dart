import 'package:edriving_spim_app/common_library/services/model/vehicle_model.dart';
import 'package:edriving_spim_app/common_library/services/networking.dart';
import 'package:edriving_spim_app/common_library/services/response.dart';
import 'package:edriving_spim_app/utils/app_config.dart';
import '../../utils/local_storage.dart';

class VehicleRepo{
  final appConfig = AppConfig();
  final localStorage = LocalStorage();
  final networking = Networking();

  Future<Response> getVehicleList({
    required context,
    groupId,
    startIndex,
    noOfRecords,
    trnCode,
    keywordSearch
    }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? mLoginId = await localStorage.getUserPhone();
    String? deviceId = await localStorage.getLoginDeviceId();
    String? diCode = await localStorage.getMerchantDbCode();
    String? appId = appConfig.appId;

    String path =
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&appId=$appId&mLoginId=$mLoginId&deviceId=$deviceId&diCode=$diCode&trnCode=$trnCode&groupId=$groupId&startIndex=$startIndex&noOfRecords=$noOfRecords&keywordSearch=$keywordSearch';

    var response = await networking.getData(
      path: 'GetVehicleList?$path',
    );
    
    if (response.isSuccess && response.data != null) {
      GetVehicleListResponse getVehicleListResponse =
          GetVehicleListResponse.fromJson(response.data);


      return Response(true, data: getVehicleListResponse.vcList);
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