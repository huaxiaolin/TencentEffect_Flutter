import 'package:flutter/material.dart';
import '../../../uikit/view/widget/slider_type_toggle_widget.dart';


class BeautyPanelSlider extends StatelessWidget {
  final bool isShowSliderTypeLayout;
  final List<bool> selectedList;
  final Function(int) onSliderTypeClick;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  const BeautyPanelSlider({
    Key? key,
    required this.isShowSliderTypeLayout,
    required this.selectedList,
    required this.onSliderTypeClick,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    required this.onChangeEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isShowSliderTypeLayout
            ? SliderTypeToggleWidget(
                selectedList: selectedList,
                onPressed: onSliderTypeClick,
              )
            : Container(),
        Expanded(
          child: Slider(
            value: value,
            thumbColor: Colors.blue,
            activeColor: Colors.blue,
            inactiveColor: Colors.white,
            divisions: divisions,
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
            min: min,
            max: max,
            label: '$value',
          ),
        )
      ],
    );
  }
}
