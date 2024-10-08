

import 'package:auto_route/auto_route.dart';
import '/common_library/services/model/provider_model.dart';
import '/common_library/utils/custom_dialog.dart';
import '/common_library/utils/language_options.dart';
import '/common_library/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '/common_library/utils/app_localizations.dart';
import '../../router.gr.dart';

class LoginBottomCard extends StatefulWidget {
  const LoginBottomCard({super.key});

  @override
  LoginBottomCardState createState() => LoginBottomCardState();
}

class LoginBottomCardState extends State<LoginBottomCard> {
  final customDialog = CustomDialog();
  final localStorage = LocalStorage();
  int count = 0;
  String appVersion = '';

  @override
  void initState() {
    super.initState();

    _getPackageInfo();
  }

  _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = packageInfo.version;
    });

    localStorage.saveAppVersion(appVersion);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return LanguageOptions();
                },
              ),
              child: Consumer<LanguageModel>(
                builder: (context, lang, child) {
                  return Text(
                    '${AppLocalizations.of(context)!.translate('language_lbl')} ${lang.language}',
                    style:
                        TextStyle(fontSize: 56.sp, fontWeight: FontWeight.w500),
                  );
                },
              ),
            ),
            const SizedBox(height: 5.0),
            GestureDetector(
              onTap: () async {
                count += 1;

                if (count == 4) {
                  customDialog.show(
                    context: context,
                    title: Text(AppLocalizations.of(context)!
                        .translate('client_acc_title')),
                    content: AppLocalizations.of(context)!
                        .translate('client_acc_desc'),
                    type: DialogType.success,
                    barrierDismissable: false,
                    onPressed: () async {
                      count = 0;
                      context.router.pop();
                      context.router.push(
                        ClientAccount(data: ''),
                      );
                    },
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.translate('version_lbl'),
                    style: TextStyle(
                      fontSize: 52.sp,
                    ),
                  ),
                  Text(
                    ': $appVersion',
                    style: TextStyle(
                      fontSize: 52.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
