

import 'package:flutter/material.dart';

class ProfileLoading extends StatelessWidget {
  final dynamic message;

  const ProfileLoading(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
