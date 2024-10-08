

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

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  ChangePasswordFormState createState() => ChangePasswordFormState();
}

class ChangePasswordFormState extends State<ChangePasswordForm>
    with PageBaseClass {
  final authRepo = AuthRepo();

  final _formKey = GlobalKey<FormState>();

  final FocusNode _oldPasswordFocus = FocusNode();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmNewPasswordFocus = FocusNode();

  final primaryColor = ColorConstant.primaryColor;

  final localStorage = LocalStorage();

  bool _isLoading = false;

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _oldPassword;
  String? _newPassword;
  String? _confirmNewPassword;

  var _height = 1200.h;

  // var _height = ScreenUtil.screenHeight / 4.5;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      curve: Curves.elasticOut,
      width: double.infinity,
      height: _height,
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
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: ScreenUtil().setHeight(35),
              ),
              TextFormField(
                focusNode: _oldPasswordFocus,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  hintStyle: TextStyle(color: primaryColor),
                  labelText:
                      AppLocalizations.of(context)!.translate('password_lbl'),
                  fillColor: Colors.grey.withOpacity(.25),
                  filled: true,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureOldPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(
                        () {
                          _obscureOldPassword = !_obscureOldPassword;
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
                obscureText: _obscureOldPassword,
                onFieldSubmitted: (term) {
                  fieldFocusChange(
                      context, _oldPasswordFocus, _newPasswordFocus);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate('password_required_msg');
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != _oldPassword) {
                    _oldPassword = value;
                  }
                },
              ),
              SizedBox(
                height: ScreenUtil().setHeight(60),
              ),
              TextFormField(
                focusNode: _newPasswordFocus,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  hintStyle: TextStyle(color: primaryColor),
                  labelText: AppLocalizations.of(context)!
                      .translate('new_password_lbl'),
                  fillColor: Colors.grey.withOpacity(.25),
                  filled: true,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(
                        () {
                          _obscureNewPassword = !_obscureNewPassword;
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
                obscureText: _obscureNewPassword,
                onFieldSubmitted: (term) {
                  fieldFocusChange(
                      context, _newPasswordFocus, _confirmNewPasswordFocus);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate('new_password_required');
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != _newPassword) {
                    _newPassword = value;
                  }
                },
              ),
              SizedBox(
                height: ScreenUtil().setHeight(60),
              ),
              TextFormField(
                focusNode: _confirmNewPasswordFocus,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  hintStyle: TextStyle(color: primaryColor),
                  labelText: AppLocalizations.of(context)!
                      .translate('confirm_new_password_lbl'),
                  fillColor: Colors.grey.withOpacity(.25),
                  filled: true,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(
                        () {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
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
                obscureText: _obscureConfirmPassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate('confirm_new_password_required');
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != _confirmNewPassword) {
                    _confirmNewPassword = value;
                  }
                },
              ),
              SizedBox(
                height: ScreenUtil().setHeight(60),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      _submitButton(),
                    ],
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
                padding: const EdgeInsets.symmetric(vertical: 11.0),
                backgroundColor: const Color(0xffdd0e0e),
                minimumSize: Size(420.w, 45.h),
                shape: const StadiumBorder(),
                textStyle: const TextStyle(color: Colors.white),
              ),
              onPressed: _submit,
              child: Text(
                AppLocalizations.of(context)!.translate('submit_btn'),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
    );
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).requestFocus(FocusNode());

      if (mounted) {
        // check if new password and confirm new password matches
        if (_newPassword == _confirmNewPassword) {
          // check if new password is the same as old password
          if (_oldPassword != _newPassword) {
            setState(() {
              _height = ScreenUtil().setHeight(1350);
              _isLoading = true;
            });

            var result = await authRepo.verifyOldPassword(
              context: context,
              currentPassword: _oldPassword,
              newPassword: _newPassword,
            );

            if (mounted) {
              if (result.isSuccess) {
                context.router.popUntil(ModalRoute.withName('ProfileTab'));

                CustomSnackbar().show(
                  context,
                  message:
                      AppLocalizations.of(context)!.translate(result.message),
                  type: MessageType.success,
                );
              } else {
                CustomSnackbar().show(
                  context,
                  message:
                      AppLocalizations.of(context)!.translate(result.message),
                  type: MessageType.error,
                );
              }

              setState(() {
                _isLoading = false;
              });
            }
          }
        } else {
          CustomSnackbar().show(
            context,
            message:
                AppLocalizations.of(context)!.translate('password_same_msg'),
            type: MessageType.error,
          );
        }
      } else {
        CustomSnackbar().show(
          context,
          message:
              AppLocalizations.of(context)!.translate('password_not_match_msg'),
          type: MessageType.error,
        );
      }

      setState(() {
        _height = ScreenUtil().setHeight(1350);
      });
    } else {
      setState(() {
        _height = ScreenUtil().setHeight(1650);
      });
    }
  }
}
