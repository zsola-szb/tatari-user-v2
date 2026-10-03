import 'package:tatarigigs_user/common/widgets/code_picker_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final String? title;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final bool? isPassword;
  final bool? isShowBorder;
  final bool? isAutoFocus;
  final Function(String)? onSubmit;
  final bool? isEnabled;
  final int? maxLines;
  final bool? isShowSuffixIcon;
  final TextCapitalization? capitalization;
  final Function(String text)? onChanged;
  final String? countryDialCode;
  final String? suffixIconUrl;
  final Function(CountryCode countryCode)? onCountryChanged;
  final String? Function(String?)? onValidate;
  final bool contentPadding;
  final double? borderRadius;
  final bool isRequired;
  final String? prefixIcon;
  final bool? isFromOfflinePayment;
  final Function? onSuffixTap;

  const CustomTextField({
    super.key,
    this.hintText = '',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.isShowSuffixIcon = false,
    this.onSubmit,
    this.capitalization = TextCapitalization.none,
    this.isPassword = false,
    this.isShowBorder,
    this.isAutoFocus = false,
    this.countryDialCode,
    this.onCountryChanged,
    this.suffixIconUrl,
    this.onChanged,
    this.onValidate,
    this.title,
    this.contentPadding = true,
    this.borderRadius,
    this.isRequired = true,
    this.prefixIcon,
    this.isFromOfflinePayment = false,
    this.onSuffixTap,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  void onFocusChanged() {
    FocusScope.of(context).unfocus();
    FocusScope.of(Get.context!).requestFocus(widget.focusNode);
    widget.focusNode?.addListener(() {
      if (kDebugMode) {
        print("Current focus is ${widget.focusNode?.hasFocus}");
      }
      if (kDebugMode) {
        print("Next Focus is ${widget.nextFocus?.hasFocus}");
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final textField = _buildTextField(context);

    if (widget.isShowBorder == true) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (widget.title != null)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.title,
                  style: context.subHeading.defaultSize.overrideWith(
                    fontWeight: AppWeight.medium,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: context.subHeading.defaultSize.overrideWith(color: Theme.of(context).colorScheme.error),
                  ),
              ],
            ),
          ),
        const SizedBox(height: Dimensions.padding6),

        textField,
      ]);
    }

    return textField;
  }

  Widget _buildTextField(BuildContext context) {
    return Focus(
      onFocusChange: (v) {},
      child: TextFormField(
        onTap: widget.isFromOfflinePayment == false ? onFocusChanged : null,
        maxLines: widget.maxLines,
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: context.subHeading.defaultSize.overrideWith(
          color: widget.isEnabled == false ? Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.6) : Theme.of(context).textTheme.bodyLarge!.color,
        ),
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        cursorColor: Theme.of(context).hintColor,
        textCapitalization: widget.capitalization!,
        enabled: widget.isEnabled,
        autofocus: widget.isAutoFocus!,
        autofillHints: widget.inputType == TextInputType.name
            ? [AutofillHints.name]
            : widget.inputType == TextInputType.emailAddress
            ? [AutofillHints.email]
            : widget.inputType == TextInputType.phone
            ? [AutofillHints.telephoneNumber]
            : widget.inputType == TextInputType.streetAddress
            ? [AutofillHints.fullStreetAddress]
            : widget.inputType == TextInputType.url
            ? [AutofillHints.url]
            : widget.inputType == TextInputType.visiblePassword
            ? [AutofillHints.password]
            : null,
        obscureText: widget.isPassword! ? _obscureText : false,
        inputFormatters: widget.inputType == TextInputType.phone
            ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))]
            : null,
        decoration: InputDecoration(
          isCollapsed: widget.focusNode?.hasFocus == true ||
              widget.isEnabled == true ||
              widget.controller!.text.isNotEmpty
              ? false
              : true,
          isDense: widget.focusNode?.hasFocus == true ||
              (widget.nextFocus != null && widget.nextFocus?.hasFocus == true) ||
              widget.controller!.text.isNotEmpty
              ? false
              : true,
          label: widget.countryDialCode == null && widget.isShowBorder == null
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AnimatedDefaultTextStyle(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(seconds: 2),
              style: context.subHeading.defaultSize.copyWith(
                fontWeight: AppWeight.medium,
                color: widget.focusNode?.hasFocus == true || widget.controller!.text.isNotEmpty ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).hintColor,
                fontSize: widget.focusNode?.hasFocus == true ? Dimensions.fontSizeDefault + 2 : 15,
              ),
              child: Text(widget.title ?? ""),
            ),

            if (widget.isRequired)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  "*",
                  style: context.subHeading.defaultSize.overrideWith(color: Theme.of(context).colorScheme.error),
                ),
              )
          ])
              : null,
          labelStyle: widget.countryDialCode == null
              ? context.subHeading.overLarge.overrideWith(fontWeight: AppWeight.medium)
              : null,
          prefixIcon: widget.prefixIcon != null
              ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.padding16,
              vertical: 5,
            ),
            child: Image.asset(
              widget.prefixIcon!,
              width: 20,
              height: 20,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
            ),
          )
              : widget.countryDialCode != null
              ? Padding(
            padding: EdgeInsets.only(
              left: widget.isShowBorder == true ? 10 : 0,
              top: 0,
            ),
            child: CodePickerWidget(
              onChanged: widget.onCountryChanged,
              initialSelection: widget.countryDialCode,
              favorite: [widget.countryDialCode ?? ""],
              showDropDownButton: true,
              padding: EdgeInsets.zero,
              showFlagMain: true,
              dialogSize: Size(Dimensions.webMaxWidth / 2, Get.height * 0.6),
              dialogBackgroundColor: Theme.of(context).cardColor,
              barrierColor: Get.isDarkMode
                  ? Colors.black.withValues(alpha: 0.4)
                  : null,
              textStyle: context.subHeading.large,
            ),
          )
              : null,
          contentPadding: EdgeInsets.only(
            top: widget.countryDialCode != null ||
                widget.isShowBorder != null && widget.isShowBorder!
                ? Dimensions.padding16
                : 0.0,
            bottom: widget.controller!.text.isNotEmpty
                ? Dimensions.padding10
                : Dimensions.padding16,
            left: widget.isShowBorder != null && widget.isShowBorder!
                ? Dimensions.padding16
                : 0,
            right: widget.isShowBorder != null && widget.isShowBorder!
                ? Dimensions.padding16
                : 0,
          ),
          focusedBorder: widget.isShowBorder != null && widget.isShowBorder!
              ? OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? Dimensions.radius8,
            ),
          )
              : UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          enabledBorder: widget.isShowBorder != null && widget.isShowBorder!
              ? OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).hintColor.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? Dimensions.radius8,
            ),
          )
              : UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).hintColor.withValues(alpha: 0.5),
            ),
          ),
          errorBorder: widget.isShowBorder != null && widget.isShowBorder!
              ? OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? Dimensions.radius8,
            ),
          )
              : UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          focusedErrorBorder: widget.isShowBorder != null && widget.isShowBorder!
              ? OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? Dimensions.radius8,
            ),
          )
              : UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          hintText: widget.hintText,
          hintStyle: context.subHeading.defaultSize.overrideWith(
            color: Theme.of(context).hintColor.withValues( alpha: Get.isDarkMode ? .5 : 1, ),
          ),
          suffixIconConstraints: widget.isPassword!
              ? BoxConstraints(
            maxHeight: widget.focusNode?.hasFocus == true ||
                (widget.nextFocus != null &&
                    widget.nextFocus?.hasFocus == true) ||
                widget.controller!.text.isNotEmpty
                ? 40
                : 20,
          )
              : null,
          suffixIcon: widget.isPassword!
              ? IconButton(
            alignment: widget.isShowBorder == true
                ? null
                : widget.focusNode?.hasFocus == true ||
                widget.controller!.text.isNotEmpty
                ? Alignment.bottomRight
                : Alignment.centerRight,
            padding: EdgeInsets.zero,
            icon: Icon(
              _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              size: 20,
              color: context.customThemeColors.textColor,
            ),
            onPressed: _toggle,
          )
              : widget.suffixIconUrl != null
              ? IconButton(
            onPressed: widget.onSuffixTap as void Function()?,
            icon: Image.asset(
              widget.suffixIconUrl!,
              width: 20,
            ),
          )
              : null,
        ),
        onFieldSubmitted: (text) => widget.nextFocus != null
            ? FocusScope.of(context).requestFocus(widget.nextFocus)
            : widget.onSubmit != null
            ? widget.onSubmit!(text)
            : null,
        onChanged: widget.onChanged,
        validator: widget.onValidate,
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}