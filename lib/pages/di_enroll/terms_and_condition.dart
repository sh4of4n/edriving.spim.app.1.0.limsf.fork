// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/common_library/utils/app_localizations.dart';

class TermsAndCondition extends StatelessWidget {
  final String? termsAndCondition;

  const TermsAndCondition({this.termsAndCondition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!
            .translate('terms_and_condition_link')),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Center(
              child: HtmlWidget(
                termsAndCondition!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
