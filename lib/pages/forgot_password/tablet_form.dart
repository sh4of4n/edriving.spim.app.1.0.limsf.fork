

import 'package:auto_route/auto_route.dart';
import '/common_library/utils/app_localizations.dart';
import '/base/page_base_class.dart';
import '/common_library/services/repository/auth_repository.dart';
import '/utils/constants.dart';
import '/common_library/utils/custom_snackbar.dart';
import '/common_library/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ForgotPasswordTabletForm extends StatefulWidget {
  const ForgotPasswordTabletForm({super.key});

  @override
  ForgotPasswordTabletFormState createState() =>
      ForgotPasswordTabletFormState();
}

class ForgotPasswordTabletFormState extends State<ForgotPasswordTabletForm>
    with PageBaseClass {
  final authRepo = AuthRepo();

  final _formKey = GlobalKey<FormState>();

  final FocusNode _phoneFocus = FocusNode();

  final primaryColor = ColorConstant.primaryColor;

  final localStorage = LocalStorage();

  bool _isLoading = false;

  String? _phone;
  String? _message = '';

  // var _height = ScreenUtil().setHeight(1200);

  // var _height = ScreenUtil.screenHeight / 4.5;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      curve: Curves.elasticOut,
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
        padding:
            EdgeInsets.only(left: 50.w, right: 50.w, top: 48.h, bottom: 60.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 35.h,
              ),
              TextFormField(
                focusNode: _phoneFocus,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  hintStyle: TextStyle(
                    color: primaryColor,
                  ),
                  labelText:
                      AppLocalizations.of(context)!.translate('phone_lbl'),
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate('phone_required_msg');
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != _phone) {
                    _phone = value;
                  }
                },
              ),
              SizedBox(
                height: 40.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Wrap(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!
                          .translate('forgot_password_msg'),
                      style: TextStyle(
                        fontSize: 30.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      /* _message.isNotEmpty
                          ? Text(
                              _message,
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox.shrink(), */
                      _submitButton(),
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
                      context.router.pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.translate('go_back_lbl'),
                      style: TextStyle(
                        fontSize: 35.sp,
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

  _submitButton() {
    return Container(
      child: _isLoading
          ? SpinKitFoldingCube(
              color: primaryColor,
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(420.w, 45.h),
                padding: const EdgeInsets.symmetric(vertical: 11.0),
                shape: const StadiumBorder(),
                backgroundColor: const Color(0xffdd0e0e),
                textStyle: const TextStyle(color: Colors.white),
              ),
              onPressed: _submit,
              child: Text(
                AppLocalizations.of(context)!.translate('submit_btn'),
                style: TextStyle(
                  fontSize: 35.sp,
                ),
              ),
            ),
    );
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).requestFocus(FocusNode());

      setState(() {
        // _height = ScreenUtil().setHeight(1200);
        _isLoading = true;
      });

      var result = await authRepo.login(
        context: context,
        phone: _phone,
        password: '',
        deviceRemark: '',
        latitude: '999',
        longitude: '999',
        phDeviceId: '',
      );
      if (mounted) {
        if (result.isSuccess) {
          context.router.pop();
          CustomSnackbar().show(
            context,
            message: result.message.toString(),
            type: MessageType.success,
          );
        }
      } else {
        if (result.message!.contains('timeout')) {
          setState(() {
            _message =
                AppLocalizations.of(context)!.translate('timeout_exception');
          });
        } else if (result.message!.contains('socket')) {
          setState(() {
            _message =
                AppLocalizations.of(context)!.translate('socket_exception');
          });
        } else {
          setState(() {
            _message = result.message;
          });
        }
        if (!context.mounted) return;
        CustomSnackbar().show(
          context,
          message: _message,
          type: MessageType.error,
        );

        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        // _height = ScreenUtil().setHeight(1300);
      });
    }
  }
}
