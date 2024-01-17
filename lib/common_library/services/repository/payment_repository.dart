import 'package:edriving_spim_app/common_library/services/model/payment_model.dart';
import 'package:edriving_spim_app/common_library/services/networking.dart';
import 'package:edriving_spim_app/common_library/services/response.dart';
import 'package:edriving_spim_app/common_library/utils/local_storage.dart';
import 'package:edriving_spim_app/utils/app_config.dart';

class PaymentRepo{
  final appConfig = AppConfig();
  final localStorage = LocalStorage();
  final networking = Networking();
  
  Future<Response> getStudentPaymentStatus({
    required context,
    icNo,
    startIndex,
    noOfRecords
  }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? diCode = await localStorage.getMerchantDbCode();

    String path = 
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&diCode=$diCode&icNo=$icNo&startIndex=$startIndex&noOfRecords=$noOfRecords';
  
    var response = await networking.getData(
      path: 'GetPaymentStatusByStudentIC?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetPaymentStatusResponse getPaymentStatusResponse =
          GetPaymentStatusResponse.fromJson(response.data);


      return Response(true, data: getPaymentStatusResponse.paymentStatus);
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