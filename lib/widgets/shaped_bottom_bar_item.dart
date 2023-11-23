import 'package:flutter/material.dart';

///The main widget used as a child to the bottom bar,
///every item will be used as [ShapedBottomBarItem]
class ShapedBottomBarItem extends StatelessWidget {
  final Color selectedColor;
  final Color unselectedColor;
  final String? text;
  final Widget icon;
  final bool renderWithText;
  final TextStyle textStyle;
  final bool isSelected;

  const ShapedBottomBarItem({
    Key? key,
    required this.icon,
    required this.isSelected,
    required this.textStyle,
    this.text = '',
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.black,
    this.renderWithText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: isSelected
          ? ColorFilter.mode(selectedColor, BlendMode.srcIn)
          : ColorFilter.mode(unselectedColor, BlendMode.srcIn),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          renderWithText
              ? Text(
                  text ?? '',
                  style: isSelected
                      ? textStyle.copyWith(fontWeight: FontWeight.bold)
                      : textStyle,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
