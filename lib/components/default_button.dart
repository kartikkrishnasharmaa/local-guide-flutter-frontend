import 'dart:async';

import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/main.dart';
import 'package:flutter/material.dart';

import '../responsive.dart';
import 'custom_text.dart';

const defaultButtonTextSize = 12.0;

class DefaultButton extends StatefulWidget {

  double fontSize = defaultButtonTextSize;
  bool isBold = true;
  bool? enable = true;

  final String buttonTitle;
  final Function? onClick;
  final Color? bgColor;
  final Color? textColor;
  final Color? loadingColor;
  final double? stroke;
  final Color? strokeColor;
  final double? padding;
  double? radius = 10.0;
  final StreamController<bool>? loadingController;
  final EdgeInsetsGeometry? customPadding;
  Widget? iconEnd;
  Widget? iconStart;
  Color? iconTint;

  DefaultButton(
    this.buttonTitle, {
    super.key,
    required this.onClick,
    this.bgColor,
    this.padding,
    this.stroke,
    this.customPadding,
    this.loadingColor,
    this.textColor,
    this.loadingController,
    this.strokeColor,
        this.radius,
    this.fontSize = defaultButtonTextSize,
    this.iconStart,
    this.iconEnd,
    this.iconTint,
    this.enable = true,
    this.isBold = false,
  });

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {

    bool isLoading = false;

    return Container(
      decoration: BoxDecoration(
        color: widget.enable == true
            ? widget.bgColor ?? $styles.colors.background
            : $styles.colors.greyMedium,
        borderRadius: BorderRadius.circular(Responsive.size(context,
            widget.radius ?? 20)),
        border: widget.stroke != null
            ? Border.all(
                color: widget.strokeColor ?? $styles.colors.title, width: widget.stroke ?? 0)
            : null,
      ),
      child: CustomInkWell(
        rippleColor: $styles.colors.greyMedium,
        radius: Responsive.size(context,
            widget.radius ?? 20),
        bgColor: widget.enable == true
            ? widget.bgColor ?? $styles.colors.blue
            : $styles.colors.greyMedium,
        onTap: () {
          if (widget.enable == true & !isLoading) widget.onClick!();
        },
        child: Padding(
          padding:
              widget.customPadding ?? EdgeInsets.all(sizing(widget.padding ?? 12, context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.iconStart != null) widget.iconStart!,
              if (widget.iconStart != null) gap(context, width: 10),
              if(widget.loadingController != null) StreamBuilder(
                stream: widget.loadingController?.stream,
                  builder: (context, snapshot) {
                  isLoading = snapshot.data == true;
                return snapshot.data == true ? _loadingView(context) : _textView();
              }) else _textView(),
              if (widget.iconEnd != null) gap(context, width: 10),
              if (widget.iconEnd != null) widget.iconEnd!,
            ],
          ),
        ),
      ),
    );
  }

  CustomText _textView() {
   return  CustomText(
      widget.buttonTitle,
      isBold: widget.isBold,
      fontSize: widget.fontSize,
      color: widget.enable == true ? (widget.textColor ?? $styles.colors.white) : $styles.colors.greyStrong,
    );
  }

  Widget _loadingView(context) {
    return SizedBox(
      height: sizing(15, context),
      width: sizing(15, context),
      child: CircularProgressIndicator(
        color: widget.loadingColor ?? $styles.colors.blue,
        strokeWidth: 2,
      ),
    );
  }
  
  @override
  void dispose() {
    widget.loadingController?.close();
    super.dispose();
  }

}
