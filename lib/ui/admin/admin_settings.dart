import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/input_field.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/admin/editor/simple_text_editor.dart';

import '../../common_libs.dart';
import '../../main.dart';
import '../../models/response/settings_model.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends BaseState<AdminSettings, HomeBloc> {

  String _privacyPolicy = "";
  String _termsAndConditions = "";
  String _aboutUs = "";
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _whatsAppNumber = TextEditingController();
  final TextEditingController _instagram = TextEditingController();
  final TextEditingController _facebook = TextEditingController();
  final TextEditingController _twitter = TextEditingController();
  final TextEditingController _minimumWithdrawal = TextEditingController();
  final TextEditingController _minimumAddBalance = TextEditingController();
  final TextEditingController _appointmentPlatformCharge = TextEditingController();
  final TextEditingController _withdrawalCharge = TextEditingController();
  final TextEditingController _shareSnippet = TextEditingController();

  SettingsModel? _settingsModel;

  @override
  void init() {

  }

  @override
  void postFrame() {
    bloc.getSettings(isShowLoading: true, callback: (p0) {
      if(p0.success == true) {
        setState(() {
          _settingsModel = p0.data;

          _privacyPolicy = _settingsModel?.privacyPolicy ?? "";
          _termsAndConditions = _settingsModel?.termsAndConditions ?? "";
          _aboutUs = _settingsModel?.aboutUs ?? "";

          _email.text = _settingsModel?.email ?? "";
          _phoneNumber.text = _settingsModel?.phoneNumber ?? "";
          _whatsAppNumber.text = _settingsModel?.whatsAppNumber ?? "";
          _instagram.text = _settingsModel?.instagram ?? "";
          _facebook.text = _settingsModel?.facebook ?? "";
          _twitter.text = _settingsModel?.twitter ?? "";
          _minimumWithdrawal.text = (_settingsModel?.minimumWithdrawal ?? 0.0).toString();
          _minimumAddBalance.text = (_settingsModel?.minimumAddBalance ?? 0.0).toString();
          _appointmentPlatformCharge.text = (_settingsModel?.appointmentPlatformCharge ?? 0.0).toString();
          _withdrawalCharge.text = (_settingsModel?.withdrawalCharge ?? 0.0).toString();
          _shareSnippet.text = _settingsModel?.shareSnippet?.toString() ?? "";

        });
      } else {
        _settingsModel = SettingsModel();
      }
    });
    super.postFrame();
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          navigatePop(context);
        }, icon: Icon(Icons.arrow_back_ios_rounded, color: $styles.colors.white,)),
        backgroundColor: $styles.colors.blue,
        title: CustomText("Settings", fontSize: titleSize(), color: $styles.colors.white,),
        actions: [
          IconButton(onPressed: () {
            _updateSettings();
          }, icon: Icon(Icons.check_rounded, color: $styles.colors.white,),)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(sizing(15, context)),
          child: Column(
            children: [
              CustomInkWell(
                onTap: () {
                  navigate(SimpleTextEditor(title: "Edit Privacy & Policy", content: _privacyPolicy, onSave: (text) {
                    setState(() {
                      _privacyPolicy = text;
                    });
                  }));
                },
                child: Padding(
                  padding: EdgeInsets.all(sizing(15, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText("Privacy & Policies"),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios_rounded, color: $styles.colors.black,)
                        ],
                      ),
                      if(_privacyPolicy.isNotEmpty) gap(context, height: 7),
                      if(_privacyPolicy.isNotEmpty) CustomText(_privacyPolicy, color: $styles.colors.greyMedium, fontSize: 10, maxLines: 1,),
                    ],
                  ),
                ),
              ),
              gap(context, height: 10),
              CustomInkWell(
                onTap: () {
                  navigate(SimpleTextEditor(title: "Edit Terms & Conditions", content: _termsAndConditions, onSave: (text) {
                    setState(() {
                      _termsAndConditions = text;
                    });
                  }));
                },
                child: Padding(
                  padding: EdgeInsets.all(sizing(15, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText("Terms & Conditions"),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios_rounded, color: $styles.colors.black,)
                        ],
                      ),
                      if(_termsAndConditions.isNotEmpty) gap(context, height: 7),
                      if(_termsAndConditions.isNotEmpty) CustomText(_termsAndConditions, color: $styles.colors.greyMedium, fontSize: 10, maxLines: 1,),
                    ],
                  ),
                ),
              ),
              gap(context, height: 10),
              CustomInkWell(
                onTap: () {
                  navigate(SimpleTextEditor(title: "Edit About Us", content: _aboutUs, onSave: (text) {
                    setState(() {
                      _aboutUs = text;
                    });
                  }));
                },
                child: Padding(
                  padding: EdgeInsets.all(sizing(15, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText("About Us"),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios_rounded, color: $styles.colors.black,)
                        ],
                      ),
                      if(_aboutUs.isNotEmpty) gap(context, height: 7),
                      if(_aboutUs.isNotEmpty) CustomText(_aboutUs, color: $styles.colors.greyMedium, fontSize: 10 , maxLines: 1,),
                    ],
                  ),
                ),
              ),
              gap(context, height: 20),
              InputField(hint: "Email", controller: _email,),
              gap(context, height: 10),
              InputField(hint: "Phone number", isNumeric: true, maxLength: 10, controller: _phoneNumber,),
              gap(context, height: 10),
              InputField(hint: "Whatsapp number", isNumeric: true, maxLength: 10, controller: _whatsAppNumber,),
              gap(context, height: 10),
              InputField(hint: "Instagram", controller: _instagram,),
              gap(context, height: 10),
              InputField(hint: "Facebook", controller: _facebook,),
              gap(context, height: 10),
              InputField(hint: "Twitter", controller: _twitter,),
              gap(context, height: 10),
              InputField(hint: "Minimum Withdrawal", isNumeric: true, controller: _minimumWithdrawal,),
              gap(context, height: 10),
              InputField(hint: "Minimum Add Balance", isNumeric: true, controller: _minimumAddBalance,),
              gap(context, height: 10),
              InputField(hint: "Appointment Platform Charge (%)", isNumeric: true, controller: _appointmentPlatformCharge,),
              gap(context, height: 10),
              gap(context, height: 10),
              InputField(hint: "Withdrawal Charge (%)", isNumeric: true, controller: _withdrawalCharge,),
              gap(context, height: 10),
              InputField(hint: "Share snippet", minLines: 10, maxLines: 50, controller: _shareSnippet,),
              gap(context, height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _updateSettings() {
    _settingsModel ??= SettingsModel();
    _settingsModel?.privacyPolicy = _privacyPolicy.isEmpty ? null : _privacyPolicy;
    _settingsModel?.termsAndConditions = _privacyPolicy.isEmpty ? null : _termsAndConditions;
    _settingsModel?.aboutUs = _aboutUs.isEmpty ? null : _aboutUs;

    _settingsModel?.email = _email.text.toString().isEmpty ? null : _email.text.toString();
    _settingsModel?.phoneNumber = _phoneNumber.text.toString().isEmpty ? null : _phoneNumber.text.toString();
    _settingsModel?.whatsAppNumber = _whatsAppNumber.text.toString().isEmpty ? null : _whatsAppNumber.text.toString();
    _settingsModel?.instagram = _instagram.text.toString().isEmpty ? null : _instagram.text.toString();
    _settingsModel?.facebook = _facebook.text.toString().isEmpty ? null : _facebook.text.toString();
    _settingsModel?.twitter = _twitter.text.toString().isEmpty ? null : _twitter.text.toString();
    _settingsModel?.minimumWithdrawal = _minimumWithdrawal.text.toString().isEmpty ? null : double.parse(_minimumWithdrawal.text.toString());
    _settingsModel?.minimumAddBalance = _minimumAddBalance.text.toString().isEmpty ? null : double.parse(_minimumAddBalance.text.toString());
    _settingsModel?.appointmentPlatformCharge = _appointmentPlatformCharge.text.toString().isEmpty ? null : double.parse(_appointmentPlatformCharge.text.toString());
    _settingsModel?.withdrawalCharge = _withdrawalCharge.text.toString().isEmpty ? null : double.parse(_withdrawalCharge.text.toString());

    _settingsModel?.shareSnippet = _shareSnippet.text.toString().isEmpty ? null : _shareSnippet.text.toString();

    bloc.updateSettings(request: _settingsModel!, callback: (p0) {
      if(p0.success == true) {
        snackBar("Success!", "Settings updated successfully.");
      } else {
        snackBar("Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }
  
  @override
  void dispose() {
    _email.dispose();
    _phoneNumber.dispose();
    _whatsAppNumber.dispose();
    _instagram.dispose();
    _facebook.dispose();
    _twitter.dispose();
    _minimumWithdrawal.dispose();
    _minimumAddBalance.dispose();
    super.dispose();
  }
}
