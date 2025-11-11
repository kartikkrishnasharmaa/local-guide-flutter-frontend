import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/models/response/image_dto.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/gallery/full_image_view.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/utils/app_state.dart';
import 'package:localguider/utils/extensions.dart';

import '../../base/base_callback.dart';
import '../../common_libs.dart';
import '../../components/app_image.dart';
import '../../components/custom_text.dart';
import '../../main.dart';

class AllImages extends StatefulWidget {
  String title;
  UserRole userRole;
  String dtoId;
  bool canEdit = false;

  AllImages(
      {super.key,
      required this.title,
      required this.userRole,
      required this.dtoId,
      this.canEdit = false});

  @override
  State<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends BaseState<AllImages, HomeBloc> {
  String url =
      "https://www.thoughtco.com/thmb/RfmaKLCPWg1atgJPr7JRGAropFU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-595123682-b2f7ecee5cda4ce2a1df2151782c76f3.jpg";

  List<ImageDto> items = [];

  var page = 1;
  var lastPage = 10000000;
  var loadingPage = -1;
  AppState _state = AppState.FETCHING_DATA;

  @override
  void init() {
    disableDialogLoading = true;
    _getData();
  }

  @override
  HomeBloc setBloc() => HomeBloc();

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
              Icons.arrow_back_ios,
              color: $styles.colors.white,
            )),
        title: CustomText(
          widget.title,
          color: $styles.colors.white,
          fontSize: 18,
        ),
        actions: [
          if (widget.canEdit)
            IconButton(
                onPressed: () {
                  pickImageDialog(
                      (bool success, String message, XFile? image) async {
                    $logger.log(message: image != null ? image.path : "null");
                    if (success && image != null) {
                      disableDialogLoading = false;
                      bloc.addImage(
                          await image.readAsBytes(),
                          widget.userRole == UserRole.PHOTOGRAPHER
                              ? widget.dtoId
                              : null,
                          widget.userRole == UserRole.GUIDER
                              ? widget.dtoId
                              : null,
                          widget.userRole == UserRole.PLACE
                              ? widget.dtoId
                              : null, (p0) {
                        disableDialogLoading = true;
                        setState(() {
                          items.clear();
                          page = 1;
                          lastPage = 100000;
                          _getData();
                        });
                      });
                    }
                  });
                },
                icon: Icon(
                  Icons.add,
                  color: $styles.colors.white,
                ))
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels ==
              scrollNotification.metrics.maxScrollExtent) {
            if (loadingPage != page && page < lastPage) {
              page++;
              loadingPage = page;
              _getData();
            }
          }
          return true;
        },
        child: _state == AppState.FETCHING_DATA
            ? Padding(
                padding: EdgeInsets.all(
                  sizing(40, context),
                ),
                child: Center(
                    child: CircularProgressIndicator(
                  color: $styles.colors.blue,
                )),
              )
            : items.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(
                      sizing(40, context),
                    ),
                    child: Center(child: CustomText("No Images")),
                  )
                : GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: <Widget>[
                      ...items.map((e) => InkWell(
                            onTap: () {
                              navigate(FullImageView(
                                  currentPosition: items.indexOf(e),
                                  imageUrl: items
                                      .map((e) => e.image.appendRootUrl())
                                      .toList()));
                            },
                            onLongPress: () {
                              _deleteImage(e.id.toString(), items.indexOf(e));
                            },
                            child: AppImage(
                              image: NetworkImage(e.image.appendRootUrl()),
                              fit: BoxFit.cover,
                            ),
                          ))
                    ],
                  ),
      ),
    );
  }

  _getData() {
    bloc.getImages(
        widget.userRole == UserRole.PHOTOGRAPHER ? widget.dtoId : null,
        widget.userRole == UserRole.GUIDER ? widget.dtoId : null,
        widget.userRole == UserRole.PLACE ? widget.dtoId : null,
        page,
        (p0) => _handleResponse(p0));
  }

  _deleteImage(imageId, position) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            padding: EdgeInsets.all(sizing(15, context)),
            title: "Delete Image?",
            dialogBackgroundColor: $styles.colors.background,
            titleTextStyle: TextStyle(
              color: $styles.colors.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            descTextStyle: TextStyle(
              color: $styles.colors.title,
            ),
            desc: "Are you sure you want to delete this image?",
            btnCancelText: "Not Now",
            btnOkText: "Yes",
            btnOkOnPress: () {
              disableDialogLoading = false;
              bloc.deleteImage(imageId, (p0) {
                if (p0.success == true) {
                  snackBar(
                      "Success!", p0.message ?? "Image deleted successfully");
                  setState(() {
                    items.clear();
                    page = 1;
                    lastPage = 100000;
                    _getData();
                  });
                } else {
                  snackBar(
                      "Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
                }
              });
            },
            btnCancelOnPress: () {})
        .show();
  }

  _handleResponse(BaseListCallback<ImageDto> event) {
    disableDialogLoading = true;
    setState(() {
      loadingPage == -1;
      _state = AppState.DATA_READY;
      if (event.success == true) {
        if ((event.data?.length ?? 0) < 10) {
          lastPage = page;
        }
        event.data?.forEach((element) {
          items.add(element);
        });
      }
    });
  }
}
