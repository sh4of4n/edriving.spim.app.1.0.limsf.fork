import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MiFare extends StatefulWidget {
  const MiFare({super.key});

  @override
  State<MiFare> createState() => _MiFareState();
}

class _MiFareState extends State<MiFare> {
  @override
  Widget build(BuildContext context) {
    return const Text('MiFare');
  }
}