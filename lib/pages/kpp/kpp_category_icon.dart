// ignore_for_file: use_key_in_widget_constructors

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class KppCategoryIcon extends StatelessWidget {
  final dynamic image;
  final dynamic width;
  final dynamic height;
  final dynamic borderWidth;
  final dynamic borderColor;
  final dynamic component;

  const KppCategoryIcon({
    this.image,
    this.width,
    this.height,
    this.borderWidth,
    this.borderColor,
    this.component,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        component != null
            ? context.router.push(component)
            : const SizedBox.shrink();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              width: borderWidth ?? 1.0,
              color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        width: width,
        height: height,
      ),
    );
  }
}
