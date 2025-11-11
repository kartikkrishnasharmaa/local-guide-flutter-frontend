import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/utils/extensions.dart';

import '../../common_libs.dart';
import '../main.dart';
import '../responsive.dart';
import '../style/styles.dart';

class InputField extends StatefulWidget {
  InputField(
      {super.key,
      required this.hint,
      required this.controller,
      this.maxLines = 1,
      this.inputType,
      this.isForPassword,
      this.iconStart,
      this.iconEnd,
      this.iconTint,
      this.iconTintEnd,
      this.obscureText,
      this.isNumeric = false,
      this.isDecimalNumeric = false,
      this.isLowerCase = false,
      this.isUsername = false,
      this.onlyAlphabet = false,
      this.maxLength = 255,
      this.minLines,
      this.isDisable = false,
      this.radius = 10,
      this.padding = 15,
      this.onClick,
      this.error,
      this.disableLabel,
      this.bgColor,
      this.hintColor,
      this.textColor,
      this.focusTextColor,
      this.enabledStrokeColor,
      this.focusStrokeColor,
      this.onIconEndTap,
      this.validator});

  final String hint;
  final int? maxLines;
  final int? minLines;
  final TextInputType? inputType;
  final TextEditingController controller;

  bool? isForPassword = false;
  bool isNumeric = false;
  bool isDecimalNumeric = false;
  bool isLowerCase = false;
  bool isUsername = false;
  bool isDisable = false;
  bool onlyAlphabet = false;
  int maxLength = 255;
  Widget? iconEnd;
  double radius = 10;
  double padding = 15;
  String? error;
  Widget? iconStart;
  Color? hintColor;
  Color? textColor;
  Color? focusTextColor;
  Color? iconTint;
  Color? iconTintEnd;
  Color? enabledStrokeColor;
  Color? focusStrokeColor;
  Function(String?)? onIconEndTap;
  bool? obscureText;
  bool? disableLabel = false;
  Function? onClick;
  Color? bgColor;

  String? Function(String?)? validator;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _passwordVisible = false;

  double inputTextSize = 14;

  late FocusNode myFocusNode;

  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void _handleTextChanged(String newText) {
    setState(() {
      if (widget.isUsername) widget.controller.text = newText.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onClick!();
      },
      child: AbsorbPointer(
        absorbing: widget.isDisable,
        child: TextFormField(
          focusNode: myFocusNode,
          onChanged: _handleTextChanged,
          controller: widget.controller,
          minLines: widget.minLines,
          maxLines: widget.maxLines ?? 1,
          obscureText: widget.obscureText ?? widget.isForPassword == true,
          cursorColor: $styles.colors.title,
          maxLength: widget.maxLength,
          keyboardType: widget.inputType ?? (widget.isNumeric || widget.isDecimalNumeric
              ? TextInputType.numberWithOptions(
                  decimal: widget.isDecimalNumeric)
              : TextInputType.text),
          inputFormatters: <TextInputFormatter>[
            if (widget.isNumeric || widget.isDecimalNumeric)
              FilteringTextInputFormatter.digitsOnly,
            if (widget.isLowerCase)
              FilteringTextInputFormatter.allow(RegExp("[a-z]")),
            if (widget.isUsername)
              FilteringTextInputFormatter.allow(RegExp("[-a-zA-Z0-9_.]")),
            if (widget.onlyAlphabet)
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
          ],
          style: TextStyle(
              color: myFocusNode.hasFocus
                  ? (widget.focusTextColor ??
                      widget.textColor ??
                      $styles.colors.title)
                  : widget.textColor ?? $styles.colors.title,
              fontSize: inputTextSize,
              fontFamily: FontStyles.regular.value),
          decoration: InputDecoration(
            labelText: widget.disableLabel == true ? null : widget.hint,
            hintText: widget.disableLabel == true ? widget.hint : null,
            alignLabelWithHint: true,
            counterText: "",
            fillColor: widget.bgColor ?? Colors.transparent,
            filled: true,
            errorText: widget.error.isNullOrEmpty() ? null : widget.error,
            contentPadding: EdgeInsets.all(sizing(widget.padding, context)),
            labelStyle: TextStyle(
                color: widget.hintColor ?? $styles.colors.caption,
                fontSize: inputTextSize,
                fontFamily: FontStyles.regular.value),
            hintStyle: TextStyle(
                color: widget.hintColor ?? $styles.colors.caption,
                fontSize: inputTextSize,
                fontFamily: FontStyles.regular.value),
            suffixIconColor: widget.iconTintEnd ?? widget.iconTint,
            prefixIcon: widget.iconStart,
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(sizing(widget.radius, context)),
              borderSide: BorderSide(
                  color: widget.enabledStrokeColor ??
                      $styles.colors.borderColor()),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(sizing(widget.radius, context)),
              borderSide: BorderSide(color: $styles.colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(sizing(widget.radius, context)),
              borderSide: BorderSide(color: $styles.colors.red),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(sizing(widget.radius, context)),
              borderSide: BorderSide(
                  color: widget.enabledStrokeColor ??
                      $styles.colors.borderColor()),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(sizing(widget.radius, context)),
              borderSide: BorderSide(
                  color: widget.focusStrokeColor ?? $styles.colors.blue),
            ),
            suffixIcon: widget.isForPassword == true
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                        widget.obscureText = !_passwordVisible;
                      });
                    },
                    icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: $styles.colors.title),
                  )
                : (widget.iconEnd != null
                    ? CustomInkWell(
                        onTap: () {
                          widget.onIconEndTap!(widget.controller.text);
                        },
                        child: widget.iconEnd!)
                    : null),
          ),
          validator: widget.validator,
        ),
      ),
    );
  }
}
