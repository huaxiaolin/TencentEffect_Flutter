import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../l10n/te_panel_localizations.dart';

class RevertButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const RevertButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10, left: 5),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          minimumSize: const Size(0, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 1, height: 20, color: const Color(0x19FFFFFF)),
            const SizedBox(width: 2),
            const Icon(Icons.replay, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(TEPanelLocalizations.of(context).revert, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}