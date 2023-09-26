

import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/services/repository/auth_repository.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import 'package:edriving_spim_app/common_library/utils/custom_button.dart';
import 'package:edriving_spim_app/common_library/utils/custom_dialog.dart';
import 'package:edriving_spim_app/common_library/utils/device_info.dart';
import 'package:edriving_spim_app/utils/app_config.dart';
import 'package:hive/hive.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '/common_library/services/repository/vclub_repository.dart';
import '/common_library/services/response.dart';
import '/common_library/utils/local_storage.dart';
import '/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

@RoutePage()
class MerchantProfile extends StatefulWidget {
  const MerchantProfile({super.key});

  @override
  State<MerchantProfile> createState() => MerchantProfileState();
}

class MerchantProfileState extends State<MerchantProfile> {
  final authRepo = AuthRepo();
  final vClubRepo = VclubRepo();
  final localStorage = LocalStorage();
  final myImage = ImagesConstant();
  final primaryColor = ColorConstant.primaryColor;
  final customDialog = CustomDialog();
  Future? getMerchant;
  String? _getCityName;
  String? _getBusinessHour;
  String? _getBusinessDay;
  String? bOfficeLoginId;

  DeviceInfo deviceInfo = DeviceInfo();
  final String _deviceBrand = '';
  final String _deviceModel = '';
  final String _deviceVersion = '';
  final String _deviceId = '';
  final String _deviceOs = '';


  final credentials = Hive.box('credentials');

  final RegExp removeBracket =
      RegExp("\\[(.*?)\\]", multiLine: true, caseSensitive: true);

  TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.grey.shade700,
  );

  TextEditingController bOfficeLoginIdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getMerchant = getMerchantApi();
  }

  Future<dynamic> getMerchantApi() async {
    String? dbCode = await localStorage.getMerchantDbCode();
    bOfficeLoginId = await credentials.get('boUserId');
    if (!context.mounted) return;
    Response result = await vClubRepo.getMerchant(
      context: context,
      keywordSearch: dbCode,
      merchantType: 'DI',
      startIndex: 0,
      noOfRecords: 10,
      latitude: '-90',
      longitude: '-180',
      maxRadius: '0',
    );

    if (result.isSuccess) {
      if (bOfficeLoginId != null) {
        bOfficeLoginIdController.text = bOfficeLoginId!;
      }
      
      return result.data;
    }
    return result.message;
  }

  _profileImage(data) {
    if (data.merchantIconFilename != null &&
        data.merchantIconFilename.isNotEmpty) {
      return Image.network(
        data.merchantIconFilename
            .replaceAll(removeBracket, '')
            .split('\r\n')[0],
        width: 600.w,
        height: 600.w,
        fit: BoxFit.contain,
      );
    }
    return Icon(
      Icons.account_circle,
      color: Colors.grey[850],
      size: 70,
    );
  }

  _merchantInfo(data) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ListTile(
            title: Text(AppLocalizations.of(context)!
                                  .translate('merchant_name')),
            subtitle: Text(data.name ?? '-', style: subtitleStyle)),
        ListTile(
            title: Text(AppLocalizations.of(context)!
                                  .translate('description')),
            subtitle: Text(data.merchantDesc ?? '-')),
        ListTile(
            title: Text(AppLocalizations.of(context)!
                                  .translate('city_lbl')),
            subtitle: Text(_getCityName ?? '-', style: subtitleStyle)),
        ListTile(
            title: Text(AppLocalizations.of(context)!
                                  .translate('business_hours')),
            subtitle: Text(_getBusinessHour ?? '-', style: subtitleStyle)),
        ListTile(
            title: Text(AppLocalizations.of(context)!
                                  .translate('business_day')),
            subtitle: Text(_getBusinessDay ?? '-', style: subtitleStyle)),
        backOfficeLoginIdField(),
      ],
    );
  }

  _requestApproval() async {
    // String? merchantDbCode = await credentials.get('merchantNo');
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    String? merchantDbCode = await localStorage.getMerchantDbCode();
    if (merchantDbCode != AppConfig().diCode) {
      if (bOfficeLoginIdController.text.isNotEmpty) {
        await credentials.put('boUserId', bOfficeLoginIdController.text);

        setState(() {});

        var result = await authRepo.requestDeviceActivation(
          boUserId: bOfficeLoginIdController.text,
          deviceId: _deviceId,
          deviceBrand: _deviceBrand,
          deviceModel: _deviceModel,
          deviceVersion: '$_deviceOs $_deviceVersion',
        );

        if (result.isSuccess) {
          if (!context.mounted) return;
          EasyLoading.dismiss();
          customDialog.show(
              context: context,
              title: const Center(
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 120,
                ),
              ),
              content: 'Successfully informed',
              barrierDismissable: false,
              type: DialogType.success,
              onPressed: ()async {
                await context.router.pop();
                if (!context.mounted) return;
                context.router.pop();
              });
        } else {
          if (!context.mounted) return;
          EasyLoading.dismiss();
          customDialog.show(
            context: context,
            content: 'Fail to send request',
            onPressed: () => Navigator.pop(context),
            type: DialogType.error,
          );
        }

        setState(() {});
      } else {
        if (!context.mounted) return;
        EasyLoading.dismiss();
        customDialog.show(
          context: context,
          content: 'Back Office Login ID is required',
          type: DialogType.warning,
        );
      }
    } else {
      if (!context.mounted) return;
      EasyLoading.dismiss();
      customDialog.show(
        context: context,
        content: 'Please register to a valid merchant before proceeding.',
        type: DialogType.warning,
      );
    }
  }

  backOfficeLoginIdField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: TextFormField(
        controller: bOfficeLoginIdController,
        autofocus: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: -10.h),
          hintText: AppLocalizations.of(context)!.translate('backOfficeId'),
          hintStyle: TextStyle(
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.amber.shade300, primaryColor],
          stops: const [0.5, 1],
          radius: 0.9,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Merchant Profile'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: getMerchant,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return SizedBox(
                    height: ScreenUtil().screenHeight,
                    child: const Center(
                      child: SpinKitFoldingCube(
                        color: Colors.blue,
                      ),
                    ),
                  );
                case ConnectionState.done:
                  if (snapshot.data is String) {
                    return Center(
                      child: Text(snapshot.data),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: SizedBox(
                        width: ScreenUtil().screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: ScreenUtil().setHeight(40)),
                            _profileImage(snapshot.data[0]),
                            _merchantInfo(snapshot.data[0]),
                            CustomButton(
                              onPressed: _requestApproval,
                              buttonColor: primaryColor,
                              title: AppLocalizations.of(context)!
                                  .translate('requestApproval'),
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ),
                    ),
                  );
                default:
                  return const Center(
                    child: Text(
                        'Failed to get merchant profile. Please try again.'),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
