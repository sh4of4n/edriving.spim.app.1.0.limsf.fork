// ignore_for_file: use_key_in_widget_constructors

import 'package:auto_route/auto_route.dart';

import '/common_library/utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

@RoutePage(name: 'ReadMore')
class ReadMore extends StatelessWidget {
  final String? packageDesc;

  const ReadMore({this.packageDesc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('enroll_lbl'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: HtmlWidget(packageDesc!),
        ),
      ),
    );
  }
}
