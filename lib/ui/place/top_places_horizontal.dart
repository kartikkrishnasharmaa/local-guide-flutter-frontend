import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/utils/extensions.dart';

import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../models/place_model.dart';
import '../../responsive.dart';
import '../../style/styles.dart';
import '../rows/row_places_horizontal.dart';

class TopPlacesHorizontal extends StatefulWidget {
  const TopPlacesHorizontal({super.key});

  @override
  State<TopPlacesHorizontal> createState() => _TopPlacesHorizontalState();
}

class _TopPlacesHorizontalState extends BaseState<TopPlacesHorizontal, HomeBloc> {
  
  List<PlaceModel>? places = [];
  
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
    bloc.getPlaces(user.latitude?.toDouble() ?? 0.0, user.longitude?.toDouble() ?? 0.0, 1, "", (p0) {
      _handleResponse(p0);
    }, onlyTopPlaces: true);
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Stack(
      children: [
        Center(
          child: StreamBuilder<bool>(
              stream: bloc.loadingController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? CircularProgressIndicator(
                  color: $styles.colors.blue,
                )
                    : places.isNullOrEmpty()
                    ? CustomText("No data found")
                    : Container();
              }),
        ),
        Container(
          height: 175,
          padding: EdgeInsets.only(
              left: sizing(5, context),
              right: sizing(5, context)),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return RowPlacesHorizontal(place: places![index], refreshCallback: () {
                _getData();
              });
            },
            itemCount: places?.length ?? 0,
          ),
        ),
      ],
    );
  }

  _handleResponse(event) {
    if(event?.success == true) {
      setState(() {
        places = event?.data;
      });
    }
  }

  @override
  void observer() {
    super.observer();
  }
  
}
