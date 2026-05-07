import 'package:flutter/material.dart';
import '../../l10n/te_panel_localizations.dart';

class SliderTypeToggleWidget extends StatelessWidget {
  final List<bool> selectedList;
  final Function(int) onPressed;

  const SliderTypeToggleWidget({
    super.key,
    required this.selectedList,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 100,
      child: ToggleButtons(
        renderBorder: true,
        borderRadius: BorderRadius.circular(20),
        borderColor: Colors.white30,
        selectedBorderColor: Colors.blue,
        textStyle: const TextStyle(fontSize: 12),
        isSelected: selectedList,
        color: Colors.white70,
        fillColor: Colors.blue,
        selectedColor: Colors.white,
        onPressed: onPressed,
        children: <Widget>[
          Text(TEPanelLocalizations.of(context).makeup),
          Text(TEPanelLocalizations.of(context).lut)
        ],
      ),
    );
  }
}