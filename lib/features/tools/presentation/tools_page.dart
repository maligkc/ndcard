import 'package:flutter/cupertino.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../l10n/gen/app_localizations.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.tabTools)),
      child: SafeArea(
        child: EmptyState(
          icon: CupertinoIcons.square_grid_2x2,
          title: l10n.toolsPlaceholder,
          message: '',
        ),
      ),
    );
  }
}
