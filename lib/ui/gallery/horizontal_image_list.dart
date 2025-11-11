import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/main.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/gallery/full_image_view.dart';
import 'package:localguider/utils/extensions.dart';

import '../../base/base_callback.dart';
import '../../common_libs.dart';
import '../../models/response/image_dto.dart';

class HorizontalImagesList extends StatefulWidget {
  String? placeId;
  String? photographerId;
  String? guiderId;

  HorizontalImagesList(
      {super.key, this.placeId, this.guiderId, this.photographerId});

  @override
  State<HorizontalImagesList> createState() => _HorizontalImagesListState();
}

class _HorizontalImagesListState
    extends BaseState<HorizontalImagesList, HomeBloc> {
  List<ImageDto>? images = [];

  @override
  void init() {
    disableDialogLoading = true;
  }

  @override
  void postFrame() {
    bloc.getImages(widget.photographerId, widget.guiderId, widget.placeId, 1, (p0) => _handleResponse(p0));
    super.postFrame();
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          Center(
            child: StreamBuilder<bool>(
                stream: bloc.loadingController.stream,
                builder: (context, snapshot) {
                  return snapshot.data == true
                      ? CircularProgressIndicator(
                          color: $styles.colors.blue,
                        )
                      : images.isNullOrEmpty()
                          ? CustomText("No images")
                          : Container();
                }),
          ),
          ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _row(images?[index].image ?? "", images?[index].title, index);
            },
            itemCount: images?.length ?? 0,
          )
        ],
      ),
    );
  }

  Widget _row(String? url, String? title, index) {
    return CustomInkWell(
      onTap: () {
        navigate(FullImageView(
            currentPosition: index, imageUrl: images?.map((e) => e.image.appendRootUrl()).toList()));
      },
      child: Padding(
        padding: EdgeInsets.all(sizing(5, context)),
        child: SizedBox(
          width: 95,
          height: 95,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AppImage(image: NetworkImage(url.appendRootUrl()), fit: BoxFit.cover,),
          ),
        ),
      ),
    );
  }

  _handleResponse(BaseListCallback<ImageDto> event) {
    setState(() {
      images = event.data;
    });
  }
}
