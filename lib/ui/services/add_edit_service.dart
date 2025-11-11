import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/models/response/service_dto.dart';
import 'package:localguider/utils/extensions.dart';

import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../components/input_field.dart';
import '../../main.dart';
import '../../responsive.dart';

class AddEditService extends StatefulWidget {

  ServiceDto? serviceDto;
  String? photographerId;
  String? guiderId;
  bool isSelectionOnly = false;
  Function(bool isEdit, ServiceDto service) callback;

  AddEditService(
      {super.key,
      this.photographerId,
      this.guiderId,
      this.serviceDto,
      this.isSelectionOnly = false,
      required this.callback});

  @override
  State<AddEditService> createState() => _AddEditServiceState();
}

class _AddEditServiceState extends BaseState<AddEditService, HomeBloc> {
  File? _image;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isEdit = false;

  @override
  void init() {
    isEdit = widget.serviceDto != null;
  }

  @override
  void postFrame() {
    super.postFrame();
    if (isEdit) {
      _titleController.text = widget.serviceDto?.title ?? "";
      _descriptionController.text = widget.serviceDto?.description ?? "";
      _priceController.text = widget.serviceDto?.servicePrice.toString() ?? "";
    }
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      backgroundColor: $styles.colors.blueBg,
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              navigatePop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: $styles.colors.white,
            )),
        title: CustomText(
          isEdit ? "Edit Service" : "Add Service",
          color: $styles.colors.white,
          fontSize: titleSize(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
            sizing(15, context),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                gap(context, height: 20),
                InkWell(
                  onTap: () {
                    pickImageDialog(
                        (bool success, String message, XFile? image) {
                      $logger.log(message: image != null ? image.path : "null");
                      if (success && image != null) {
                        setState(() {
                          _image = File(image.path);
                        });
                      }
                    });
                  },
                  child: Container(
                    height: sizing(200, context),
                    width: sizing(200, context),
                    decoration: BoxDecoration(
                        color: $styles.colors.greyLight,
                        border: Border.all(color: $styles.colors.greyLight),
                        borderRadius:
                            BorderRadius.circular(sizing(15, context))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(sizing(15, context)),
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.fill,
                            )
                          : isEdit && widget.serviceDto?.image != null
                              ? AppImage(
                                  image: NetworkImage(
                                    widget.serviceDto!.image.appendRootUrl(),
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Icon(
                                  Icons.add,
                                  size: sizing(30, context),
                                  color: $styles.colors.black,
                                )),
                    ),
                  ),
                ),
                gap(context, height: 7),
                Center(
                    child: CustomText(
                  "Select an Image",
                  fontSize: sizing(12, context),
                )),
                gap(context, height: 10),
                InputField(
                    hint: "Title (Required)",
                    radius: 30,
                    disableLabel: true,
                    maxLines: 1,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please enter title";
                      }
                      return null;
                    },
                    bgColor: $styles.colors.white,
                    controller: _titleController),
                gap(context, height: 15),
                InputField(
                    hint: "Price (Required)",
                    radius: 30,
                    isDecimalNumeric: true,
                    maxLength: 7,
                    minLines: 1,
                    maxLines: 1,
                    disableLabel: true,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please enter price";
                      }
                      return null;
                    },
                    bgColor: $styles.colors.white,
                    controller: _priceController),
                gap(context, height: 15),
                InputField(
                    hint: "Describe your services",
                    radius: 30,
                    disableLabel: true,
                    maxLines: 10,
                    minLines: 5,
                    bgColor: $styles.colors.white,
                    controller: _descriptionController),
                gap(context, height: 15),
                DefaultButton("Save", onClick: () {
                  if (_formKey.currentState!.validate()) {
                    _saveDetails();
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveDetails() {

    if(widget.isSelectionOnly) {
      ServiceDto serviceDto = widget.serviceDto ?? ServiceDto();
      serviceDto.image = _image?.path;
      serviceDto.title = _titleController.text;
      serviceDto.description = _descriptionController.text;
      serviceDto.servicePrice = double.parse(_priceController.text);
      widget.callback(isEdit, serviceDto);
      navigatePop(context);
      return;
    }

    bloc.saveService(
        photographerId: widget.photographerId,
        guiderId: widget.guiderId,
        serviceId: widget.serviceDto?.id?.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        servicePrice: double.parse(_priceController.text),
        image: _image,
        callback: (response) {
          if (response.success == true) {
            snackBar("Success!", response.message ?? "Success");
            widget.callback(isEdit, response.data!);
            navigatePop(context);
          } else {
            snackBar(
                "Failed!", response.message ?? $strings.SOME_THING_WENT_WRONG);
          }
        });
  }
}
