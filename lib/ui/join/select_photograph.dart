import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/responsive.dart';

import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../style/styles.dart';

class SelectPhotograph extends StatefulWidget {

  Function(Uint8List? photograph)? onPhotographUpdate;

  PhotographerDto? dto;
  SelectPhotograph({super.key, required this.onPhotographUpdate, this.dto});

  @override
  State<SelectPhotograph> createState() => _SelectPhotographState();
}

class _SelectPhotographState extends BaseState<SelectPhotograph, HomeBloc> {

  Uint8List? _photograph;

  @override
  void init() {

  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      backgroundColor: $styles.colors.blueBg,
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(sizing(15, context),), child: Column(
          children: [
            gap(context, height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: CustomText(
                "Photograph/Selfie",
                fontSize: sizing(17, context),
                style: FontStyles.openSansBold,
              ),
            ),
            gap(context, height: 20),
            InkWell(
              onTap: () {
                pickImageDialog((bool success, String message, XFile? image) async {
                  $logger.log(message: image != null ? image.path : "null");
                  if (success && image != null) {
                    _photograph = await image.readAsBytes();
                    _syncInfo();
                    setState(()  { });
                  }
                });
              },
              child: Container(
                height: sizing(200, context),
                width: sizing(200, context),
                decoration: BoxDecoration(
                    color: $styles.colors.greyLight,
                    border: Border.all(color: $styles.colors.greyLight),
                    borderRadius: BorderRadius.circular(sizing(15, context))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(sizing(15, context)),
                  child: _photograph != null
                      ? Image.memory(
                    _photograph!,
                    fit: BoxFit.fill,
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
                  "Select/Capture a Photograph/Selfie of Yourself",
                  fontSize: sizing(12, context),
                )),
          ],
        ),),
      ),
    );
  }

  _syncInfo() {
    if(widget.onPhotographUpdate == null) return;
    widget.onPhotographUpdate!(_photograph);
  }

}
