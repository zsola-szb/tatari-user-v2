import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ContactInfoBottomSheet extends StatefulWidget {
  final VoidCallback onSaved;
  final String initialName;
  final String initialPhone;

  const ContactInfoBottomSheet({
    super.key,
    required this.onSaved,
    this.initialName = '',
    this.initialPhone = '',
  });

  @override
  State<ContactInfoBottomSheet> createState() => _ContactInfoBottomSheetState();
}

class _ContactInfoBottomSheetState extends State<ContactInfoBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;

    final String number = widget.initialPhone;
    final String normalised = PhoneVerificationHelper.isPhoneValid(number, fromAuthPage: false);
    _phoneController.text = normalised.isEmpty ? number : normalised;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nameNode.dispose();
    _phoneNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (LocationController locationController) {
        return BaseBottomSheet(
          child: Padding(
            padding: EdgeInsets.fromLTRB(Dimensions.padding16, 0, Dimensions.padding16, MediaQuery.of(context).viewInsets.bottom + Dimensions.padding16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('contact_info'.tr, style: context.heading.large),
                  const SizedBox(height: Dimensions.padding20),

                  CustomTextField(
                    title: 'name'.tr,
                    hintText: 'contact_person_name_hint'.tr,
                    controller: _nameController,
                    focusNode: _nameNode,
                    nextFocus: _phoneNode,
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                    isShowBorder: true,
                    onValidate: (String? value) =>
                        FormValidation().isValidLength((value ?? '').trim()),
                  ),
                  const SizedBox(height: Dimensions.padding20),

                  CustomTextField(
                    title: 'phone_number'.tr,
                    hintText: 'contact_person_number_hint'.tr,
                    controller: _phoneController,
                    focusNode: _phoneNode,
                    inputType: TextInputType.phone,
                    inputAction: TextInputAction.done,
                    isShowBorder: true,
                    countryDialCode: locationController.countryDialCode,
                    onCountryChanged: (CountryCode code) {
                      locationController.countryDialCode = code.dialCode ?? '';
                    },
                    onValidate: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_phone_number'.tr;
                      }
                      return FormValidation().isValidPhone(
                        locationController.countryDialCode + value,
                        fromAuthPage: false,
                      );
                    },
                  ),
                  const SizedBox(height: Dimensions.padding24),

                  CustomButton(
                    buttonText: 'save'.tr,
                    width: double.infinity,
                    radius: Dimensions.radius12,
                    onPressed: () => _onSave(locationController),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSave(LocationController locationController) {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final String dialCode = locationController.countryDialCode;
    final String phone = dialCode +
        PhoneVerificationHelper.isPhoneValid(
          dialCode + _phoneController.text,
          fromAuthPage: false,
        );
    locationController.setGuestContactInfo(
      name: _nameController.text.trim(),
      phone: phone,
    );

    Get.back();
    widget.onSaved();
  }
}
