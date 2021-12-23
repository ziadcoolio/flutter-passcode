import 'package:flutter/material.dart';

typedef KeyboardTapCallback = void Function(String text);

@immutable
class KeyboardUIConfig {
  //Digits have a round thin borders, [digitBorderWidth] define their thickness
  final double digitBorderWidth;
  final TextStyle digitTextStyle;
  final TextStyle deleteButtonTextStyle;
  final Color primaryColor;
  final Color digitFillColor;
  final EdgeInsetsGeometry keyboardRowMargin;
  final EdgeInsetsGeometry digitInnerMargin;

  //Size for the keyboard can be define and provided from the app.
  //If it will not be provided the size will be adjusted to a screen size.
  final Size? keyboardSize;

  const KeyboardUIConfig({
    this.digitBorderWidth = 1,
    this.keyboardRowMargin = const EdgeInsets.only(top: 15, left: 4, right: 4),
    this.digitInnerMargin = const EdgeInsets.all(24),
    this.primaryColor = Colors.white,
    this.digitFillColor = Colors.transparent,
    this.digitTextStyle = const TextStyle(fontSize: 30, color: Colors.white),
    this.deleteButtonTextStyle =
        const TextStyle(fontSize: 16, color: Colors.white),
    this.keyboardSize,
  });
}

class Keyboard extends StatelessWidget {
  final KeyboardUIConfig keyboardUIConfig;
  final KeyboardTapCallback onKeyboardTap;

  //should have a proper order [1...9, 0]
  final List<String>? digits;
  final VoidCallback? onCancel;
  final VoidCallback? onBackspace;

  Keyboard(
      {Key? key,
      required this.keyboardUIConfig,
      required this.onKeyboardTap,
      this.digits,
      this.onBackspace,
      this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) => _buildKeyboard(context);

  Widget _buildKeyboard(BuildContext context) {
    List<String> keyboardItems = List.filled(10, '0');
    if (digits == null || digits!.isEmpty) {
      keyboardItems = [
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        'cancel',
        '0',
        'backspace'
      ];
      // create widget class with icon and callback. for backspace and cancel
    } else {
      keyboardItems = digits!;
    }
    final screenSize = MediaQuery.of(context).size;
    double keyboardHeight, keyboardWidth;
    if (screenSize.height > screenSize.width) {
      keyboardHeight = screenSize.height / 2;
      keyboardWidth = keyboardHeight * 3 / 4;
    } else {
      keyboardWidth = screenSize.width / 4;
      keyboardHeight = keyboardWidth * 4 / 3;
    }

    final keyboardSize = this.keyboardUIConfig.keyboardSize != null
        ? this.keyboardUIConfig.keyboardSize!
        : Size(keyboardWidth, keyboardHeight);
    return Container(
      width: keyboardSize.width,
      height: keyboardSize.height,
      margin: EdgeInsets.only(top: 16),
      child: AlignedGrid(
        keyboardSize: keyboardSize,
        children: List.generate(keyboardItems.length, (index) {
          if (keyboardItems[index] == "backspace") {
            return _buildKeyboardAction(this.onBackspace, icon:Icons.backspace);
          } else if (keyboardItems[index] == "cancel") {
            return _buildKeyboardAction(this.onCancel, text: "cancel");
          } else {
            return _buildKeyboardDigit(keyboardItems[index]);
          } //return _buildKeyboardDigit(keyboardItems[index]);
        }),
      ),
    );
  }

  Widget _buildKeyboardDigit(String text) {
    return Container(
      margin: EdgeInsets.all(6),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: keyboardUIConfig.primaryColor.withOpacity(0.4),
            onTap: () {
              onKeyboardTap(text);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                    color: keyboardUIConfig.primaryColor,
                    width: keyboardUIConfig.digitBorderWidth),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: keyboardUIConfig.digitFillColor,
                ),
                child: Center(
                  child: Text(
                    text,
                    style: keyboardUIConfig.digitTextStyle,
                    semanticsLabel: text,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardAction(VoidCallback? onActionTap,
      {String? text, IconData? icon}) {
    return Container(
      margin: EdgeInsets.all(6),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: keyboardUIConfig.primaryColor.withOpacity(0.4),
            onTap: onActionTap,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                    color: keyboardUIConfig.primaryColor,
                    width: keyboardUIConfig.digitBorderWidth),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //color: keyboardUIConfig.digitFillColor,
                  color: Colors.grey,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (() {
                        if (icon != null) {
                          return Icon(
                            icon,
                            color: Colors.black54,
                            size: 30,
                          );
                        } else {
                          return Container();
                        }
                      }()),
                      (() {
                        if (text != null) {
                          return Text(
                            text,
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54),
                            semanticsLabel: text,
                          );
                        } else {
                          return Container();
                        }
                      }()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlignedGrid extends StatelessWidget {
  final double runSpacing = 4;
  final double spacing = 4;
  final int listSize;
  final columns = 3;
  final List<Widget> children;
  final Size keyboardSize;

  const AlignedGrid(
      {Key? key, required this.children, required this.keyboardSize})
      : listSize = children.length,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final primarySize = keyboardSize.width > keyboardSize.height
        ? keyboardSize.height
        : keyboardSize.width;
    final itemSize = (primarySize - runSpacing * (columns - 1)) / columns;
    return Wrap(
      runSpacing: runSpacing,
      spacing: spacing,
      alignment: WrapAlignment.center,
      children: children
          .map((item) => Container(
                width: itemSize,
                height: itemSize,
                child: item,
              ))
          .toList(growable: false),
    );
  }
}
