import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final bool loading;
  final Color color;
  final Color borderColor;
  final EdgeInsets margin, padding;
  final Function onPress;
  final BorderRadius borderRadius;
  final String text;
  final IconData leftIcon, rightIcon;
  final double height, width;
  final TextStyle textStyle;
  final Color iconColor;
  const CustomButton({
    Key key,
    this.color,
    this.text,
    this.margin,
    this.padding,
    this.onPress,
    this.leftIcon,
    this.loading = false,
    this.borderRadius,
    this.height,
    this.width,
    this.rightIcon,
    this.borderColor,
    this.textStyle,
    this.iconColor,
  })  : assert(text != null || leftIcon != null || rightIcon != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth == double.infinity ? null : double.infinity,
        margin: margin,
        decoration: BoxDecoration(
            // gradient: color == null ? horizontalGradient : null,
            color: color ?? Color(0xff2D7F9D),
            borderRadius: borderRadius ?? BorderRadius.circular(50),
            border:
                borderColor != null ? Border.all(color: borderColor) : null),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(50),
          ),
          onPressed: onPress,
          padding: EdgeInsets.all(0),
          child: Container(
            padding: padding ?? EdgeInsets.all(15),
            child: loading
                ? SizedBox(
                    width: 17,
                    height: 17,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (leftIcon != null)
                        Icon(
                          leftIcon,
                          size: text == null ? 22 : 18,
                          color: iconColor ?? Colors.white,
                        ),
                      if (text != null && leftIcon != null) SizedBox(width: 10),
                      if (text != null)
                        Text(
                          text,
                          style: textStyle ??
                              GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                              ),
                        ),
                      if (text != null && rightIcon != null)
                        SizedBox(width: 10),
                      if (rightIcon != null)
                        Icon(
                          rightIcon,
                          size: text == null ? 22 : 18,
                          color: iconColor ?? Colors.white,
                        ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
