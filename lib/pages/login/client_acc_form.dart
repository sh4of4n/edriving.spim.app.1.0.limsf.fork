

import 'package:auto_route/auto_route.dart';
import '/base/page_base_class.dart';
import '/common_library/services/repository/auth_repository.dart';
import '/utils/app_config.dart';
import '/utils/constants.dart';
import '/common_library/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/common_library/utils/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../router.gr.dart';

class ClientAccountForm extends StatefulWidget {
  final dynamic data;

  const ClientAccountForm(this.data, {super.key});

  @override
  ClientAccountFormState createState() => ClientAccountFormState();
}

class ClientAccountFormState extends State<ClientAccountForm>
    with PageBaseClass {
  final authRepo = AuthRepo();
  final AppConfig appConfig = AppConfig();

  final _formKey = GlobalKey<FormState>();

  final FocusNode _urlFocus = FocusNode();
  final FocusNode _caUidFocus = FocusNode();
  final FocusNode _caPwdFocus = FocusNode();

  final primaryColor = ColorConstant.primaryColor;

  final localStorage = LocalStorage();

  bool _isLoading = false;

  String _message = '';
  bool _obscureText = true;
  String? _connectedUrl = '';
  String? _connectedCa = '';

  final urlController = TextEditingController();
  final caUidController = TextEditingController();
  final caPwdController = TextEditingController();
  // var _height = ScreenUtil().setHeight(1300);

  // var _height = ScreenUtil.screenHeight / 4.5;

  @override
  void initState() {
    super.initState();

    _getConnectedUrl();
    _getConnectedCa();
  }

  @override
  void dispose() {
    urlController.dispose();
    caUidController.dispose();
    caPwdController.dispose();

    super.dispose();
  }

  _getConnectedUrl() async {
    String? savedUrl = await Hive.box('ws_url').get('userDefinedUrl');

    setState(() {
      urlController.text = savedUrl ?? '';
      _connectedUrl = savedUrl;
    });
  }

  _getConnectedCa() async {
    String? clientAcc = await localStorage.getCaUid();

    setState(() {
      _connectedCa = clientAcc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: _height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 15.0),
            blurRadius: 15.0,
          ),
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, -10.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 35.h,
              ),
              TextFormField(
                controller: caUidController,
                focusNode: _caUidFocus,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  hintStyle: TextStyle(
                    color: primaryColor,
                  ),
                  labelText: AppLocalizations.of(context)!
                      .translate('client_acc_id_lbl'),
                  fillColor: Colors.grey.withOpacity(.25),
                  filled: true,
                  prefixIcon: const Icon(Icons.account_circle),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onFieldSubmitted: (term) {
                  fieldFocusChange(context, _caUidFocus, _caPwdFocus);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate('client_acc_id_required');
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 70.h,
              ),
              TextFormField(
                controller: caPwdController,
                focusNode: _caPwdFocus,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  hintStyle: TextStyle(color: primaryColor),
                  labelText: AppLocalizations.of(context)!
                      .translate('client_acc_pwd_lbl'),
                  fillColor: Colors.grey.withOpacity(.25),
                  filled: true,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(
                        () {
                          _obscureText = !_obscureText;
                        },
                      );
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                obscureText: _obscureText,
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate('password_required_msg');
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 60.h,
              ),
              _showConnectedUrl(),
              _showConnectedCa(),
              TextFormField(
                controller: urlController,
                maxLines: 5,
                focusNode: _urlFocus,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  hintStyle: TextStyle(
                    color: primaryColor,
                  ),
                  labelText: 'URL',
                  fillColor: Colors.grey.withOpacity(.25),
                  filled: true,
                  prefixIcon: const Icon(Icons.public),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onFieldSubmitted: (term) {
                  fieldFocusChange(context, _urlFocus, _caUidFocus);
                },
              ),
              SizedBox(
                height: 70.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      _message.isNotEmpty
                          ? Text(
                              _message,
                              style: const TextStyle(color: Colors.red),
                            )
                          : const SizedBox.shrink(),
                      _saveButton(),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (widget.data == 'SETTINGS') {
                        context.router.replace(const Login());
                      } else {
                        context.router.pop();
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.translate('go_back_lbl'),
                      style: TextStyle(
                        fontSize: 56.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showConnectedUrl() {
    if (_connectedUrl != null && _connectedUrl!.isNotEmpty) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
                '${AppLocalizations.of(context)!.translate('connected_url')}: $_connectedUrl'),
          ),
          SizedBox(
            height: 60.h,
          ),
        ],
      );
    }
    return const SizedBox(width: 0, height: 0);
  }

  _showConnectedCa() {
    if (_connectedCa!.isNotEmpty) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
                '${AppLocalizations.of(context)!.translate('connected_ca')}: $_connectedCa'),
          ),
          SizedBox(
            height: 60.h,
          ),
        ],
      );
    }
    return const SizedBox(width: 0, height: 0);
  }

  _saveButton() {
    return Container(
      child: _isLoading
          ? SpinKitFoldingCube(
              color: primaryColor,
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(color: Colors.white),
                shape: const StadiumBorder(),
                backgroundColor: const Color(0xffdd0e0e),
                padding: const EdgeInsets.symmetric(vertical: 11.0),
                minimumSize: Size(420.w, 45.h),
              ),
              onPressed: _submit,
              child: Text(
                AppLocalizations.of(context)!.translate('save_btn'),
                style: TextStyle(
                  fontSize: 56.sp,
                ),
              ),
            ),
    );
  }

  _submit() async {
    if (urlController.text.isNotEmpty) {
      await Hive.box('ws_url').put(
        'userDefinedUrl',
        urlController.text.replaceAll('_wsver_', '6_2'),
      );

      await Hive.box('ws_url').put(
        'getWsUrl',
        '0',
      );

      localStorage.saveCaUid(caUidController.text.replaceAll(' ', ''));
      localStorage.saveCaPwd(caPwdController.text.replaceAll(' ', ''));
      localStorage.saveCaPwdEncode(
          Uri.encodeQueryComponent(caPwdController.text.replaceAll(' ', '')));
      if (!context.mounted) return;
      if (widget.data == 'SETTINGS') {
        if (!context.mounted) return;
        context.router.replace(const Login());
      } else {
        if (!context.mounted) return;
        context.router.pop();
      }
    } else {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        FocusScope.of(context).requestFocus(FocusNode());

        await Hive.box('ws_url').put(
          'getWsUrl',
          '1',
        );

        setState(() {
          _message = '';
          _isLoading = true;
        });
        if (!context.mounted) return;
        var result = await authRepo.getWsUrl(
          context: context,
          acctUid: caUidController.text.replaceAll(' ', ''),
          acctPwd: caPwdController.text.replaceAll(' ', ''),
          loginType: appConfig.wsCodeCrypt,
        );

        if (result.isSuccess) {
          await Hive.box('ws_url').delete('userDefinedUrl');
          if (!context.mounted) return;
          if (widget.data == 'SETTINGS') {
            if (!context.mounted) return;
            context.router.replace(const Login());
          } else {
            if (!context.mounted) return;
            context.router.pop();
          }
        } else {
          setState(() {
            _message = result.message.toString();
          });
        }

        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
