import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final String time;
  final Widget trailing;
  final EdgeInsetsGeometry contentPadding;
  final GestureTapCallback onTap;

  const CustomListTile({
    Key? key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.trailing,
    this.contentPadding = const EdgeInsets.all(16.0),
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: contentPadding,
        child: Row(
          children: [
            if (leading != null) leading,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$subtitle',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              '$time',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
