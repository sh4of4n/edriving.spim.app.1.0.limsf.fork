

// import 'package:auto_route/auto_route.dart';
// import 'package:hive/hive.dart';
// import '/base/page_base_class.dart';
// import '/common_library/services/location.dart';
// import '/common_library/services/repository/auth_repository.dart';
// import '/utils/constants.dart';
// import '/common_library/utils/device_info.dart';
// import '/common_library/utils/local_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import '/common_library/utils/app_localizations.dart';

// import '../../router.gr.dart';

// class LoginTabletForm extends StatefulWidget {
//   const LoginTabletForm({super.key});

//   @override
//   LoginTabletFormState createState() => LoginTabletFormState();
// }

// class LoginTabletFormState extends State<LoginTabletForm> with PageBaseClass {
//   final authRepo = AuthRepo();

//   final _formKey = GlobalKey<FormState>();

//   final FocusNode _phoneFocus = FocusNode();

//   final FocusNode _passwordFocus = FocusNode();

//   final primaryColor = ColorConstant.primaryColor;

//   final localStorage = LocalStorage();

//   bool _isLoading = false;

//   String? _phone;
//   String? _password;
//   String? _loginMessage = '';
//   bool _obscureText = true;

//   // var _height = ScreenUtil().setHeight(1300);

//   // var _height = ScreenUtil.screenHeight / 4.5;

//   Location location = Location();
//   String latitude = '';
//   String longitude = '';
//   final credentials = Hive.box('credentials');

//   DeviceInfo deviceInfo = DeviceInfo();
//   final String? deviceBrand = '';
//   String? deviceModel = '';
//   String? _deviceVersion = '';
//   String? _deviceId = '';
//   String? _deviceOs = '';

//   @override
//   void initState() {
//     super.initState();

//     _getCurrentLocation();
//     _getDeviceInfo();
//   }

//   _getDeviceInfo() async {
//     // get device info
//     await deviceInfo.getDeviceInfo();

//     // _deviceModel = deviceInfo.model;
//     _deviceVersion = deviceInfo.version;
//     _deviceId = deviceInfo.id;
//     _deviceOs = deviceInfo.os;

//     // print('deviceId: ' + deviceId);
//   }

//   _getCurrentLocation() async {
//     await location.getCurrentLocation();

//     setState(() {
//       latitude =
//           location.latitude != null ? location.latitude.toString() : '999';
//       longitude =
//           location.longitude != null ? location.longitude.toString() : '999';
//     });

//     // print('$_latitude, $_longitude');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       // height: _height,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.0),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black26,
//             offset: Offset(0.0, 15.0),
//             blurRadius: 15.0,
//           ),
//           BoxShadow(
//             color: Colors.black12,
//             offset: Offset(0.0, -10.0),
//             blurRadius: 10.0,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding:
//             EdgeInsets.only(left: 50.w, right: 50.w, top: 48.h, bottom: 60.h),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               SizedBox(
//                 height: 35.h,
//               ),
//               TextFormField(
//                 style: TextStyle(
//                   fontSize: 35.sp,
//                 ),
//                 focusNode: _phoneFocus,
//                 keyboardType: TextInputType.phone,
//                 textInputAction: TextInputAction.next,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.symmetric(vertical: 40.h),
//                   hintStyle: TextStyle(
//                     color: primaryColor,
//                   ),
//                   labelText:
//                       AppLocalizations.of(context)!.translate('phone_lbl'),
//                   fillColor: Colors.grey.withOpacity(.25),
//                   filled: true,
//                   prefixIcon: const Icon(Icons.account_circle, size: 32),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 onFieldSubmitted: (term) {
//                   fieldFocusChange(context, _phoneFocus, _passwordFocus);
//                 },
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return AppLocalizations.of(context)!
//                         .translate('phone_required_msg');
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   if (value != _phone) {
//                     _phone = value;
//                   }
//                 },
//               ),
//               SizedBox(
//                 height: 50.h,
//               ),
//               TextFormField(
//                 style: TextStyle(
//                   fontSize: 35.sp,
//                 ),
//                 focusNode: _passwordFocus,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.symmetric(vertical: 40.h),
//                   hintStyle: TextStyle(color: primaryColor),
//                   labelText:
//                       AppLocalizations.of(context)!.translate('password_lbl'),
//                   fillColor: Colors.grey.withOpacity(.25),
//                   filled: true,
//                   prefixIcon: const Icon(Icons.lock, size: 32),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                         _obscureText ? Icons.visibility_off : Icons.visibility),
//                     onPressed: () {
//                       setState(
//                         () {
//                           _obscureText = !_obscureText;
//                         },
//                       );
//                     },
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 obscureText: _obscureText,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return AppLocalizations.of(context)!
//                         .translate('password_required_msg');
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   if (value != _password) {
//                     _password = value;
//                   }
//                 },
//               ),
//               SizedBox(
//                 height: 40.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   InkWell(
//                     onTap: () {
//                       context.router.push(const ForgotPassword());
//                     },
//                     child: Text(
//                       AppLocalizations.of(context)!
//                           .translate('forgot_password_lbl'),
//                       style: TextStyle(
//                         fontSize: 35.sp,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 30.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Column(
//                     children: <Widget>[
//                       _loginMessage!.isNotEmpty
//                           ? LimitedBox(
//                               maxWidth: 800.w,
//                               child: Text(
//                                 _loginMessage!,
//                                 style: const TextStyle(color: Colors.red),
//                                 textAlign: TextAlign.center,
//                               ),
//                             )
//                           : const SizedBox.shrink(),
//                       _loginButton(),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 40.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   InkWell(
//                     onTap: () {
//                       context.router.push(const RegisterMobile());
//                     },
//                     child: Text(
//                       AppLocalizations.of(context)!.translate('sign_up_btn'),
//                       style: TextStyle(
//                         fontSize: 35.sp,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   _loginButton() {
//     return Container(
//       child: _isLoading
//           ? SpinKitFoldingCube(
//               color: primaryColor,
//             )
//           : ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(420.w, 45.h),
//                 padding: const EdgeInsets.symmetric(vertical: 11.0),
//                 shape: const StadiumBorder(),
//                 backgroundColor: const Color(0xffdd0e0e),
//                 textStyle: const TextStyle(color: Colors.white),
//               ),
//               onPressed: _submitLogin, // () => localStorage.reset(),

//               child: Text(
//                 AppLocalizations.of(context)!.translate('login_btn'),
//                 style: TextStyle(
//                   fontSize: 35.sp,
//                 ),
//               ),
//             ),
//     );
//   }

//   _submitLogin() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       FocusScope.of(context).requestFocus(FocusNode());

//       setState(() {
//         // _height = ScreenUtil().setHeight(1300);
//         _isLoading = true;
//         _loginMessage = '';
//       });

//       /* var result = await authRepo.login(
//         context: context,
//         phone: _phone,
//         password: _password,
//       ); */

//       var result = await authRepo.eDrivingAdminLoginResetPwd(
//         context: context,
//         phone: _phone,
//         password: _password,
//         latitude: latitude.isEmpty ? '999' : latitude,
//         longitude: longitude.isEmpty ? '999' : longitude,
//         deviceBrand: deviceBrand,
//         deviceModel: Uri.encodeComponent(deviceModel!),
//         deviceRemark: '$_deviceOs $_deviceVersion',
//         phDeviceId: _deviceId,
//       );

//       if (result.isSuccess) {
//         credentials.put('phone', _phone);
//         if (result.data == 'empty') {
//           if (!context.mounted) return;
//           var getRegisteredDi = await authRepo.getUserRegisteredDI(
//               context: context, type: 'LOGIN');

//           if (getRegisteredDi.isSuccess) {
//             if (!context.mounted) return;
//             localStorage.saveMerchantDbCode(getRegisteredDi.data[0].merchantNo);
//             localStorage.saveDiCode(getRegisteredDi.data[0].merchantNo);
//             credentials.put('merchantNo', getRegisteredDi.data[0].merchantNo);
//             context.router.replace(Home());
//           } else {
//             setState(() {
//               _isLoading = false;
//               _loginMessage = result.message;
//             });
//           }
//         } else if (result.data.length > 1) {
//           // Navigate to DI selection page
//           // Temporary navigate to home
//           // Navigator.replace(context, HOME);
//           if (!context.mounted) return;
//           context.router.replace(
//             SelectDrivingInstitute(diList: result.data),
//           );
//         } else {
//           localStorage.saveMerchantDbCode(result.data[0].merchantNo);
//           localStorage.saveDiCode(result.data[0].merchantNo);
//           if (!context.mounted) return;
//           context.router.replace( Home());
//         }
//       } else {
//         setState(() {
//           _isLoading = false;
//           _loginMessage = result.message;
//         });
//       }
//     } else {
//       setState(() {
//         // _height = ScreenUtil().setHeight(1450);
//       });
//     }
//   }
// }
