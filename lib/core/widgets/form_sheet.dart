import 'package:flutter/cupertino.dart';

import '../../l10n/gen/app_localizations.dart';

enum FormFieldType { text, toggle }

class FormFieldSpec {
  const FormFieldSpec({
    required this.key,
    required this.label,
    this.type = FormFieldType.text,
    this.keyboardType = TextInputType.text,
    this.initialText = '',
    this.initialBool = false,
  });

  final String key;
  final String label;
  final FormFieldType type;
  final TextInputType keyboardType;
  final String initialText;
  final bool initialBool;
}

/// Basit, tek sayfalık bir modal form: text/switch alanları girip Kaydet/İptal
/// ile döner. Deneyim, "daha fazla bilgi" ve alan-değeri girişleri için
/// ortak kullanılır. Dönüş: key -> "text değeri" (toggle için "true"/"false").
Future<Map<String, String>?> showFormSheet({
  required BuildContext context,
  required String title,
  required List<FormFieldSpec> fields,
}) {
  return showCupertinoModalPopup<Map<String, String>?>(
    context: context,
    builder: (context) => _FormSheet(title: title, fields: fields),
  );
}

class _FormSheet extends StatefulWidget {
  const _FormSheet({required this.title, required this.fields});

  final String title;
  final List<FormFieldSpec> fields;

  @override
  State<_FormSheet> createState() => _FormSheetState();
}

class _FormSheetState extends State<_FormSheet> {
  late final Map<String, TextEditingController> _controllers = {
    for (final f in widget.fields)
      if (f.type == FormFieldType.text) f.key: TextEditingController(text: f.initialText),
  };
  late final Map<String, bool> _toggles = {
    for (final f in widget.fields)
      if (f.type == FormFieldType.toggle) f.key: f.initialBool,
  };

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            final result = <String, String>{};
            _controllers.forEach((k, c) => result[k] = c.text.trim());
            _toggles.forEach((k, v) => result[k] = v.toString());
            Navigator.of(context).pop(result);
          },
          child: Text(l10n.commonSave),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: widget.fields.map((f) {
            if (f.type == FormFieldType.toggle) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(f.label),
                    CupertinoSwitch(
                      value: _toggles[f.key] ?? false,
                      onChanged: (v) => setState(() => _toggles[f.key] = v),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: CupertinoTextField(
                controller: _controllers[f.key],
                placeholder: f.label,
                keyboardType: f.keyboardType,
                padding: const EdgeInsets.all(14),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
