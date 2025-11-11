import 'package:localguider/base/base_state.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/components/input_field.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/admin/network/admin_bloc.dart';

import '../../../common_libs.dart';
import '../../../main.dart';

class SendNotification extends StatefulWidget {
  Function() refreshCallback;

  SendNotification({super.key, required this.refreshCallback});

  @override
  State<SendNotification> createState() => _SendNotificationState();
}

class _SendNotificationState extends BaseState<SendNotification, AdminBloc> {
  
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  bool forAll = true;
  bool forVisitors = false;
  bool forGuiders = false;
  bool forPhotographers = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void init() {
    disableDialogLoading = true;
  }
  
  @override
  Widget view() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        leading: IconButton(
            onPressed: () {
              navigatePop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: $styles.colors.white,
            )),
        title: CustomText(
          "Send Notification",
          fontSize: titleSize(),
          color: $styles.colors.white,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(sizing(15, context)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gap(context, height: 15),
              InputField(hint: "Title", validator: (text) {
                if(text == null || text.isEmpty) {
                  return "Title is required";
                }
                return null;
              }, controller: _titleController),
              gap(context, height: 10),
              InputField(
                  hint: "Caption",
                  minLines: 5,
                  maxLength: 5000,
                  validator: (text) {
                    if(text == null || text.isEmpty) {
                      return "Caption is required";
                    }
                    return null;
                  },
                  maxLines: 10,
                  inputType: TextInputType.multiline,
                  controller: _descriptionController),
              gap(context, height: 10),
              CustomText("Send To: "),
              gap(context, height: 10),
              Row(
                children: [
                  Checkbox(
                    value: forAll,
                    onChanged: (value) {
                      setState(() {
                        forAll = value!;
                        if(value == true) {
                          forPhotographers = false;
                          forGuiders = false;
                          forVisitors = false;
                        }
                      });
                    },
                  ),
                  CustomText("All"),
                ],
              ),
              gap(context, height: 10),
              Row(
                children: [
                  Checkbox(
                    value: forVisitors,
                    onChanged: (value) {
                      setState(() {
                        forVisitors = value!;
                        if(value == true) {
                          forAll = false;
                          forGuiders = false;
                          forPhotographers = false;
                        }
                      });
                    }
                  ),
                  CustomText("Visitors"),
                ]
              ),
              gap(context, height: 10),
              Row(
                children: [
                  Checkbox(
                    value: forPhotographers,
                    onChanged: (value) {
                      setState(() {
                        forPhotographers = value!;
                        if(value == true) {
                          forAll = false;
                          forGuiders = false;
                          forVisitors = false;
                        }
                      });
                    }
                  ),
                  CustomText("Photographers"),
                ]
              ),
              gap(context, height: 10),
              Row(
                children: [
                  Checkbox(
                    value: forGuiders,
                    onChanged: (value) {
                      setState(() {
                        forGuiders = value!;
                        if(value == true) {
                          forPhotographers = false;
                          forAll = false;
                          forVisitors = false;
                        }
                      });
                    }
                  ),
                  CustomText("Guiders"),
                ]
              ),
              gap(context, height: 20),
              DefaultButton("Send", loadingColor: $styles.colors.white, loadingController: bloc.loadingController, onClick: () {
                if(_formKey.currentState!.validate()) {
                  sendNotification();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  void sendNotification() {
    bloc.sendNotification(_titleController.text.toString(), _descriptionController.text.toString(), forAll, forPhotographers, forGuiders, forVisitors, (p0) {
      if(p0.success == true) {
        snackBar("Success!", "Notification sent successfully");
        _titleController.text = "";
        _descriptionController.text = "";
        widget.refreshCallback();
      } else {
        snackBar("Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }
  
  @override
  AdminBloc setBloc() => AdminBloc();
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
