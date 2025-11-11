import 'package:localguider/base/base_state.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/ui/photographers/photographer_details.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/utils/extensions.dart';

import '../../blocs/home_bloc.dart';
import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../rows/row_photographer_view_horizontal.dart';

class PhotographerHorizontalList extends StatefulWidget {
  String? placeId;
  UserRole userRole;
  PhotographerHorizontalList({super.key, this.placeId, required this.userRole});

  @override
  State<PhotographerHorizontalList> createState() =>
      _PhotographerHorizontalListState();
}

class _PhotographerHorizontalListState
    extends BaseState<PhotographerHorizontalList, HomeBloc> {
  List<PhotographerDto>? photographers = [];

  @override
  void init() {
    disableDialogLoading = true;
  }

  @override
  void postFrame() {
    _getData();
    super.postFrame();
  }

  _getData() {
    double lat = user.latitude?.toDouble() ?? 0.0;
    double lng = user.longitude?.toDouble() ?? 0.0;
    if(widget.userRole == UserRole.GUIDER) {
      widget.placeId != null ? bloc.getGuidersByPlace(widget.placeId,  (p0) { _handlePhotographerResponse(p0); }) : bloc.getGuiders(lat, lng, 1, "",  (p0) { _handlePhotographerResponse(p0); });
    } else {
      widget.placeId != null ? bloc.getPhotographersByPlace(widget.placeId, (p0) { _handlePhotographerResponse(p0); }) : bloc.getPhotographers(lat, lng, 1, "",  (p0) { _handlePhotographerResponse(p0); });
    }
  }

  @override
  setBloc() => HomeBloc();

  @override
  Widget view() {
    return SizedBox(
      height: 190,
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
                      : photographers.isNullOrEmpty()
                          ? CustomText("No data found")
                          : Container();
                }),
          ),
          ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              PhotographerDto? photographer = photographers?[index];
              return photographer == null
                  ? Container()
                  : RowPhotographerViewHorizontal(
                      photographer: photographer,
                      onClick: () {
                        navigate(PhotographerDetails(dto: photographer, userRole: widget.userRole, refreshCallback: () {
                          _getData();
                        },));
                      },
                    );
            },
            itemCount: photographers?.length ?? 0,
          )
        ],
      ),
    );
  }

  _handlePhotographerResponse(event) {
    if(event?.success == true) {
      setState(() {
        photographers = event?.data;
      });
    }
  }

}
