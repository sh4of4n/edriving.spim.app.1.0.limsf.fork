import 'package:auto_route/auto_route.dart';
import '/common_library/services/model/auth_model.dart';
import '/router.gr.dart';
import 'package:flutter/material.dart';

class CheckEnrollment extends StatefulWidget {
  const CheckEnrollment({super.key});

  @override
  CheckEnrollmentState createState() => CheckEnrollmentState();
}

class CheckEnrollmentState extends State<CheckEnrollment> {
  @override
  void initState() {
    super.initState();

    context.router.replace(SelectInstitute(
      data: EnrollmentData(
        icNo: '',
        name: '',
        email: '',
        gender: '',
        dateOfBirthString: '',
        nationality: 'WARGANEGARA',
        race: '',
        profilePic: '',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
