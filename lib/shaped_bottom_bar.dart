library shaped_bottom_bar;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shaped_bottom_bar/models/shaped_item_object.dart';
import 'package:shaped_bottom_bar/utils/enums.dart';
import 'package:shaped_bottom_bar/widgets/custom_shape_widget.dart';

import 'package:shaped_bottom_bar/widgets/shaped_bottom_bar_item.dart';
import 'package:shaped_bottom_bar/widgets/shapes/circle_shape.dart';
import 'package:shaped_bottom_bar/widgets/shapes/diamond_shape.dart';
import 'package:shaped_bottom_bar/widgets/shapes/hexagon_shape.dart';
import 'package:shaped_bottom_bar/widgets/shapes/octagon_shape.dart';
import 'package:shaped_bottom_bar/widgets/shapes/pentagon_shape.dart';
import 'package:shaped_bottom_bar/widgets/shapes/rhombus_shape.dart';
import 'package:shaped_bottom_bar/widgets/shapes/rotated_hexagon.dart';
import 'package:shaped_bottom_bar/widgets/shapes/royal_shape.dart';
import 'package:shaped_bottom_bar/widgets/shapes/star_shape.dart';
import 'package:shaped_bottom_bar/widgets/shapes/triangle_shape.dart';
import 'package:shaped_bottom_bar/widgets/shapes/square_shape.dart';

import 'widgets/animated_shape.dart';
export 'utils/enums.dart';
export 'models/shaped_item_object.dart';

///The size of the bottom bar: default 70
const double shapedBottomBarSize = 70;

///Main widget of shaped bottom bar
///required [listItems] the list of [ShapedItemObject] that will be shown
///[onItemChanged] function that will be triggered every time the current item changes
///Other attributes are optional
///
///By default the bottom bar will be rendered without shape.
///to set a shape use [shape] type of [ShapeType] enum contain 6 different shapes.
class ShapedBottomBar extends StatefulWidget {
  ShapedBottomBar({
    GlobalKey<ShapedBottomBarState>? key,
    required this.onItemChanged,
    required this.listItems,
    this.height = shapedBottomBarSize,
    this.width,
    this.withRoundCorners = false,
    this.cornerRadius,
    this.shape = ShapeType.none,
    this.selectedItemIndex = 0,
    this.shapeColor = Colors.blue,
    this.unselectedIconColor = Colors.black,
    this.selectedIconColor = Colors.blue,
    this.textStyle = const TextStyle(),
    this.bottomBarTopColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.customShape,
    this.animationType = AnimationType.none,
    this.with3dEffect = false,
  }) : super(key: key) {
    if (withRoundCorners) assert(cornerRadius != null);
    if (shape == ShapeType.custom) assert(customShape != null);

    assert(listItems.isNotEmpty);
  }

  final List<ShapedItemObject> listItems;
  final Function(int) onItemChanged;

  final double height;
  final double? width;

  final bool withRoundCorners;
  final BorderRadius? cornerRadius;
  final ShapeType shape;
  final int selectedItemIndex;

  //Colors
  final Color shapeColor;
  final Color backgroundColor;
  final Color unselectedIconColor;
  final Color selectedIconColor;
  final TextStyle textStyle;
  final Color bottomBarTopColor;

  ///used to implement shaped bottom bar with custom shape
  ///with a given CustomPaint object and set [shape] to [ShapeType.custom]
  ///
  final CustomPaint? customShape;

  ///animation that will be set when navigating between navigation bar items
  ///possible values
  ///```dart
  ///[
  /// NONE,
  /// FADE,
  /// SLIDE_VERTICALLY,
  /// ROTATE
  ///]
  ///```
  ///
  final AnimationType animationType;

  ///Whether the selected shape will be rendered with 3D effects
  ///by default it's false
  ///
  final bool with3dEffect;

  @override
  ShapedBottomBarState createState() => ShapedBottomBarState();
}

class ShapedBottomBarState extends State<ShapedBottomBar>
    with TickerProviderStateMixin {
  ///Current selected item index, by default it takes the value of [this.widget.selectedItemIndex]
  ///
  late int selectedIndex;

  ///List of widgets that will be displayed in the bottom bar after adding the shape
  ///
  late List<Widget> bottomBarWidgets;

  ///Used when animation type set to [fade]
  ///
  double opacity = 1;

  ///the slide animation controller
  ///
  late AnimationController? slideController;

  ///the offset animation used for slide animation
  ///
  late Animation<Offset>? _offsetAnimation;

  ///The rotation animation controller
  ///
  late AnimationController? rotateController;

  double kSafeHeight = 20;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedItemIndex;
    slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    _offsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1.5)).animate(
      CurvedAnimation(parent: slideController!, curve: Curves.ease),
    );

    rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    generateListOfWidgets();
  }

  @override
  void dispose() {
    slideController?.dispose();
    rotateController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    kSafeHeight = MediaQuery.of(context).padding.bottom;
    if (kSafeHeight == 0) kSafeHeight = 20;
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height * 0.75 + (kSafeHeight == 20 ? 0 : kSafeHeight),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: renderBarItems(),
      ),
    );
  }

  ///generates the list of widgets  that will be displayed in the bottom bar
  ///return [List<Widget>] contains oll widget (selected and unselected items)
  List<Widget> renderBarItems() {
    List<Widget> bottomBarItems = [];
    List<Widget> renderingItems = [];
    for (int index = 0; index < bottomBarWidgets.length; index++) {
      final item = bottomBarWidgets[index];
      if (index == selectedIndex) {
        if (bottomBarItems.isNotEmpty) renderingItems.addAll(bottomBarItems);
        renderingItems.add(Expanded(flex: 1, child: renderSelectedItem(item)));
        bottomBarItems.clear();
      } else {
        bottomBarItems.add(
          Expanded(flex: 1, child: renderClickableWidget(index, item)),
        );
      }
    }
    if (bottomBarItems.isNotEmpty) renderingItems.addAll(bottomBarItems);

    return renderingItems;
  }

  ///render a clickable widget, every unselected item will be clickable
  ///the selected item is not clickable
  ///
  ///[index]: the index of the item, will be used to update the current selected item
  ///[item]: the actual unselected widget, will be used as a child in [InkWell] widget
  ///
  ///return a clickable [Widget] with a function that updates the current selected  item
  Widget renderClickableWidget(int index, Widget item) {
    return InkWell(
      onTap: () => onItemSelected(index),
      child: Container(
        height: (widget.height * 0.75) + kSafeHeight,
        color: widget.backgroundColor,
        child: item,
      ),
    );
  }

  void onSelectAction(int position) {
    widget.onItemChanged(position);
    selectedIndex = position;
    generateListOfWidgets();
  }

  ///updates the current selected item index to a new index
  ///triggered on tapping on any unselected widget, play the selected animation transition
  ///and trigger the [onItemChanged] function passed as parameter the the main widget
  ///
  ///[position]: the position of the new selected item
  ///
  /// has no return value
  void onItemSelected(int position) {
    switch (widget.animationType) {
      case AnimationType.fade:
        setState(() => opacity = 0);
        Timer(
          const Duration(milliseconds: 100),
          () {
            onSelectAction(position);
            Timer(
              const Duration(milliseconds: 100),
              () => setState(() => opacity = 1),
            );
          },
        );
        break;
      case AnimationType.slideVertically:
        slideController!.animateTo(0.5);
        Future.delayed(const Duration(milliseconds: 50), () {
          slideController!.animateTo(0);
          onSelectAction(position);
        });

        break;
      case AnimationType.rotate:
        onSelectAction(position);
        rotateController!.forward();
        Timer(
          const Duration(milliseconds: 300),
          rotateController!.reset,
        );
        break;
      default:
        onSelectAction(position);
    }
  }

  Widget getShapedWidget(Widget baseWidget) {
    switch (widget.shape) {
      case ShapeType.circle:
        return CircleShape(
          child: baseWidget,
          background: widget.shapeColor,
          size: widget.height,
        );
      case ShapeType.square:
        return SquareShape(
          child: baseWidget,
          background: widget.shapeColor,
          with3DEffect: widget.with3dEffect,
          size: widget.height,
        );

      case ShapeType.triangle:
        return TriangleShape(
          child: baseWidget,
          background: widget.shapeColor,
          size: widget.height,
          render3dEffect: widget.with3dEffect,
        );

      case ShapeType.hexagon:
        return HexagonShape(
          child: baseWidget,
          background: widget.shapeColor,
          with3DEffect: widget.with3dEffect,
        );

      case ShapeType.rotatedHexagon:
        return RotatedHexagon(
          child: baseWidget,
          background: widget.shapeColor,
          size: widget.height,
          with3DEffect: widget.with3dEffect,
        );

      case ShapeType.royalShape:
        return RoyalShape(
          child: baseWidget,
          background: widget.shapeColor,
          size: widget.height,
        );

      case ShapeType.pentagon:
        return PentagonShape(
          child: baseWidget,
          background: widget.shapeColor,
          size: widget.height,
          with3DEffect: widget.with3dEffect,
        );

      case ShapeType.star:
        return StarShape(
          child: baseWidget,
          background: widget.shapeColor,
          size: widget.height,
        );

      case ShapeType.rhombus:
        return RhombusShape(
          child: baseWidget,
          background: widget.shapeColor,
          size: widget.height,
          with3DEffect: widget.with3dEffect,
        );

      case ShapeType.octagon:
        return OctagonShape(
          child: baseWidget,
          background: widget.shapeColor,
          size: widget.height,
          with3DEffect: widget.with3dEffect,
        );

      case ShapeType.diamond:
        return DiamondShape(
          child: baseWidget,
          background: widget.shapeColor,
          size: widget.height,
          with3DEffect: widget.with3dEffect,
        );

      case ShapeType.custom:
        return CustomShapeWidget(
          child: baseWidget,
          shape: widget.customShape!,
        );

      default:
        return baseWidget;
    }
  }

  ///render the selected widget
  ///based on the parameter [shape] it render the appropriate shape
  ///if shape equals to [ShapeType.none] the selected item will be just a colored icon with the color is [selectedIconColor]
  ///
  ///the widget result will be warped with [AnimatedShape] widget with the selected animation [widget.animationType]
  ///
  ///[baseWidget] : the selected widget that will be wrapped  with a shape.
  ///
  ///return a [Widget] type variable.
  Widget renderSelectedItem(Widget baseWidget) {
    final shapedWidget = getShapedWidget(baseWidget);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: (widget.height * 0.75) + kSafeHeight,
            color: widget.backgroundColor,
          ),
        ),
        Positioned(
          top: -15,
          left: 0,
          right: 0,
          child: SizedBox(
            height: (widget.height * 0.75) + kSafeHeight,
            child: AnimatedShape(
              animationType: widget.animationType,
              animationValue: opacity,
              animationOffset: _offsetAnimation,
              animationController: rotateController,
              shape: shapedWidget,
            ),
          ),
        ),
      ],
    );
  }

  ///Generate list of [ShapedBottomBarItem] objects, used in rendering the shaped bottom bar
  ///iterates over [this.widget.listItems] and create the appropriate [ShapedBottomBarItem] widget
  ///
  ///this function has no parameter, and has no return value
  void generateListOfWidgets() {
    bottomBarWidgets = [];
    for (ShapedItemObject item in widget.listItems) {
      bottomBarWidgets.add(
        ShapedBottomBarItem(
          icon: item.icon,
          text: item.title ?? '',
          isSelected: widget.listItems.indexOf(item) == selectedIndex,
          selectedColor: widget.selectedIconColor,
          unselectedColor: widget.unselectedIconColor,
          textStyle: widget.textStyle,
        ),
      );
    }
  }
}
