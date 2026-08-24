import 'package:flutter/cupertino.dart';

import '../../l10n/gen/app_localizations.dart';
import '../domain/failures.dart';

Future<void> showErrorDialog(BuildContext context, Object error) {
  final l10n = AppLocalizations.of(context)!;
  final message = error is AppException ? error.message : l10n.authGenericError;
  return showCupertinoDialog<void>(
    context: context,
    builder: (ctx) => CupertinoAlertDialog(
      title: Text(l10n.commonError),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: Text(l10n.commonOk),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
      ],
    ),
  );
}
