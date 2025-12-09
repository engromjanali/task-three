import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_three/core/constants/dimension_theme.dart';
import 'package:task_three/core/extensions/ex_build_context.dart';

class WCElevatedButton extends StatelessWidget {
  final Function() onTap;
  final String label;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final EdgeInsets? margin;
  final Size? size;
  final BorderRadius? borderRadius;
  const WCElevatedButton({
    super.key,
    this.foregroundColor,
    this.backgroundColor,
    required this.onTap,
    required this.label,
    this.margin,
    this.size,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        height: size?.height ?? 50.h,
        width: size?.width ?? double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? context.button?.primary,
            foregroundColor: foregroundColor ?? context.backgroundColor,
            minimumSize: Size(double.maxFinite, 30.h),
            elevation: 0,
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius:
                  borderRadius ?? BorderRadius.circular(PTheme.borderRadius),
            ),
          ),
          onPressed: onTap,
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
