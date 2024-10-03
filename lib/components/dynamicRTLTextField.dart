import 'package:flutter/material.dart';

class DynamicRTLTextField extends StatefulWidget {
  final String initialValue;
  final TextEditingController controller;
  final bool readOnly;
    final bool autofocus;
    final Color cursorColor;
    final TextStyle style;
    final InputDecoration decoration;

  const DynamicRTLTextField({
    super.key,
    this.initialValue = '',
    required this.controller,
    required this.readOnly,
    required this.autofocus,
    required this.cursorColor,
    required this.style,
    required this.decoration
  });

  @override
  _DynamicRTLTextFieldState createState() => _DynamicRTLTextFieldState();
}

class _DynamicRTLTextFieldState extends State<DynamicRTLTextField> {
  bool _isRTL = false;

  @override
  void initState() {
    super.initState();
    _isRTL = isHebrew(widget.initialValue);
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    widget.controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final newIsRTL = isHebrew(widget.controller.text);
    if (newIsRTL != _isRTL) {
      setState(() {
        _isRTL = newIsRTL;
      });
    }
  }

  bool isHebrew(String text) {
    return text.runes.any((rune) => rune >= 0x0590 && rune <= 0x05FF);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: TextFormField(
        controller: widget.controller,
        textAlign: _isRTL ? TextAlign.right : TextAlign.left,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        cursorColor: widget.cursorColor,
        style: widget.style,
        decoration: widget.decoration,
      ),
    );
  }
}