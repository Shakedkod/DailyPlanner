// ignore_for_file: file_names

import 'package:daily_planner/components/dynamicRTLTextField.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget 
{
    final String? title;
    final String hint;
    final Color underlineColor;
    final TextEditingController controller;
    final Widget? widget;
    const InputField({
        super.key, 
        this.title, 
        required this.hint, 
        required this.underlineColor, 
        required this.controller, 
        this.widget
    });

    @override
    Widget build(BuildContext context) 
    {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                if (title != null) Text(
                    title!,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                    ),
                ),
                Container(
                    height: 52,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.only(left: 14),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: underlineColor,
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                        children: [
                            Expanded(
                                child: DynamicRTLTextField(
                                    readOnly: widget != null,
                                    autofocus: false,
                                    cursorColor: Colors.grey[700]!,
                                    controller: controller,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                    ),
                                    decoration: InputDecoration(
                                        hintText: hint,
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[400],
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 0,
                                            )
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 0,
                                            )
                                        ),
                                    ),
                                ),
                            ),
                            if (widget != null) Container(
                                child: widget,
                            )
                        ],
                    ),
                ),
            ],
        );
    }
}