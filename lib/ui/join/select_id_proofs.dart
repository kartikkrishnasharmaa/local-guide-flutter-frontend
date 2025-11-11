import 'package:image_picker/image_picker.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../components/input_field.dart';
import '../../main.dart';
import '../../modals/items_selection.dart';
import '../../models/selection_model.dart';
import '../../responsive.dart';
import '../../style/styles.dart';

class SelectIdProofs extends StatefulWidget {

  Function(String type,Uint8List? frontImage, Uint8List? backImage,)? onIdProofUpdate;

  PhotographerDto? dto;
  SelectIdProofs({super.key, required this.onIdProofUpdate, this.dto});

  @override
  State<SelectIdProofs> createState() => _SelectIdProofsState();
}

class _SelectIdProofsState extends BaseState<SelectIdProofs, HomeBloc> {

  Uint8List? frontImage;
  Uint8List? backImage;

  final TextEditingController _idProofController = TextEditingController();

  final _idProofsList = <SelectionModel>[];

  SelectionModel? _selectedIdProof;

  @override
  void init() {
    _idProofsList.add(
      SelectionModel(title: "Aadhaar Card", caption: "Aadhaar Card", selected: false),
    );
    _idProofsList.add(
      SelectionModel(title: "PAN", caption: "PAN", selected: false),
    );
    _idProofsList.add(
      SelectionModel(title: "Passport", caption: "Passport", selected: false),
    );
    _selectedIdProof = _idProofsList.first;
    _syncInfo();
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    _idProofController.text = _selectedIdProof?.title ?? "";
    return Scaffold(
      backgroundColor: $styles.colors.blueBg,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(sizing(15, context)),
          child: Column(
            children: [
              gap(context, height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: CustomText(
                  "Identification Proofs",
                  fontSize: sizing(17, context),
                  style: FontStyles.openSansBold,
                ),
              ),
              gap(context, height: 20),
              InputField(
                hint: $strings.gender,
                disableLabel: true,
                isDisable: true,
                onClick: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          heightFactor: 0.5,
                          child: ItemSelectionSheet(
                            title: "Select ID Proof Type",
                            selectedItem: _selectedIdProof,
                            onItemSelected: (newValue) {
                              _onIdProofChange(newValue);
                            },
                            list: _idProofsList,
                          ),
                        );
                      });
                },
                controller: _idProofController,
                iconEnd: Icon(Icons.keyboard_arrow_down_rounded,
                    color: $styles.colors.black),
                validator: (text) {
                  if (text == null || text.isEmpty == true) {
                    return "Please select an id proof type.";
                  }
                  return null;
                },
              ),
              gap(context, height: 20),
              InkWell(
                onTap: () {
                  pickImageDialog((bool success, String message, XFile? image) async {
                    $logger.log(message: image != null ? image.path : "null");
                    if (success && image != null) {
                      frontImage = await image.readAsBytes();
                      print("Front Image +=============>  ${frontImage}");
                      _syncInfo();
                      setState(()  {});
                    }
                  });
                },
                child: Container(
                  height: sizing(200, context),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: $styles.colors.greyLight,
                      border: Border.all(color: $styles.colors.greyLight),
                      borderRadius: BorderRadius.circular(sizing(15, context))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(sizing(15, context)),
                    child: frontImage != null
                        ? Image.memory(
                            frontImage!,
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
                "Select/Capture Front Image",
                fontSize: sizing(12, context),
              )),
              gap(context, height: 20),
              InkWell(
                onTap: () {
                  pickImageDialog((bool success, String message, XFile? image) async {
                    $logger.log(message: image != null ? image.path : "null");
                    if (success && image != null) {
                      backImage = await image.readAsBytes();
                      _syncInfo();
                      setState(()  {});
                    }
                  });
                },
                child: Container(
                  height: sizing(200, context),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: $styles.colors.greyLight,
                      border: Border.all(color: $styles.colors.greyLight),
                      borderRadius: BorderRadius.circular(sizing(15, context))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(sizing(15, context)),
                    child: backImage != null
                        ? Image.memory(
                            backImage!,
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
                "Select/Capture Back Image",
                fontSize: sizing(12, context),
              )),
            ],
          ),
        ),
      ),
    );
  }

  _syncInfo() {
    if(widget.onIdProofUpdate == null) return;
    widget.onIdProofUpdate!(
      _selectedIdProof?.caption ?? "",
      frontImage, backImage
    );
  }

  _onIdProofChange(SelectionModel? newIdProof) {
    setState(() {
      if (_selectedIdProof != newIdProof) {
        frontImage == null;
        backImage == null;
      }
      _selectedIdProof = newIdProof;
      _syncInfo();
    });
  }
}
