import 'package:flutter/material.dart';

class ColorServices 
{
    // newHueValue must be between 0.0 and 360.0
    static Color changeColorHue(Color color, double newHueValue) => HSLColor.fromColor(color).withHue(newHueValue).toColor();

    // newSaturationValue must be between 0.0 and 1.0
    static Color changeColorSaturation(Color color, double newSaturationValue) => HSLColor.fromColor(color).withSaturation(newSaturationValue).toColor();

    // newLightnessValue must be between 0.0 and 1.0
    static Color changeColorLightness(Color color, double newLightnessValue) => HSLColor.fromColor(color).withLightness(newLightnessValue).toColor();
}