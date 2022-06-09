// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ProfileLoading extends StatelessWidget {
  final dynamic message;

  const ProfileLoading(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
