import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

enum DialogType {
  general,
  info,
  success,
  error,
  warning,
  simpleDialog,
}

class CustomDialog {
  final double _defIconSize = 120;

  show({
    required BuildContext context,
    required String? content,
    Widget? title,
    customActions,
    required type,
    bool? barrierDismissable,
    onPressed,
  }) {
    List<Widget>? actions = <Widget>[
      TextButton(
        onPressed: onPressed ?? () => context.router.pop(),
        child: const Text("Ok"),
      )
    ];

    switch (type) {
      case DialogType.general:
        actions = customActions;
        return _dialog(
          context,
          title,
          content,
          actions,
          barrierDismissable,
        );
      case DialogType.info:
        title = Center(
          child: Icon(
            Icons.info_outline,
            size: _defIconSize,
          ),
        );
        return _dialog(
          context,
          title,
          content,
          actions,
          barrierDismissable,
        );
      case DialogType.success:
        title = Center(
          child: Icon(
            Icons.check_circle_outline,
            size: _defIconSize,
          ),
        );
        return _dialogApproval(
          context,
          title,
          content,
          actions,
          barrierDismissable,
        );
      case DialogType.warning:
        title = Center(
          child: Icon(
            Icons.warning,
            size: _defIconSize,
          ),
        );
        return _dialog(
          context,
          title,
          content,
          actions,
          barrierDismissable,
        );
      case DialogType.error:
        title = Center(
          child: Icon(
            Icons.cancel,
            color: const Color(0xffdd0e0e),
            size: _defIconSize,
          ),
        );
        return _dialogApproval(
          context,
          title,
          content,
          actions,
          barrierDismissable,
        );
      case DialogType.simpleDialog:
        actions = customActions;
        return _simpleDialog(
          context,
          title,
          actions,
          barrierDismissable,
        );
    }
  }

  _dialog(
    BuildContext context,
    Widget? title,
    String? content,
    actions,
    barrierDismissable,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(content ?? ''),
          title: title,
          actions: actions,
        );
      },
      barrierDismissible: barrierDismissable ?? true,
    );
  }

  _dialogApproval(
    BuildContext context,
    Widget? title,
    String? content,
    actions,
    barrierDismissable,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(content ?? ''),
          title: title,
          actions: actions,
        );
      },
      barrierDismissible: barrierDismissable ?? true,
    );
  }

  _simpleDialog(
    context,
    title,
    actions,
    barrierDismissible,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: title,
          children: actions,
        );
      },
      barrierDismissible: barrierDismissible ?? true,
    );
  }
}
