import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/main.dart';
import 'package:universal_html/html.dart' as html;
import '../../style/colors.dart';

class FullImageView extends StatefulWidget {

  List<String>? imageUrl;
  int currentPosition;
  FullImageView({super.key, required this.imageUrl, required this.currentPosition});

  @override
  State<FullImageView> createState() => _FullImageViewState();
}

class _FullImageViewState extends BaseState<FullImageView, HomeBloc> {

  final PageController _pageController = PageController();

  @override
  void postFrame() {
    _pageController.jumpToPage(widget.currentPosition);
    super.postFrame();
  }

  @override
  void init() {}

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
        actions: [
          IconButton(onPressed: (){
            downloadImage(widget.imageUrl![widget.currentPosition]);
          }, icon: Icon(Icons.download_rounded, color: $styles.colors.white,))
        ],
        title: null,
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        onPageChanged: (newPosition) {
          widget.currentPosition = newPosition;
        },
        children: widget.imageUrl!.map((e) => SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: AppImage(
              image: NetworkImage(e),
            ))).toList(),
      ),
    );
  }

  void downloadImage(String url) {
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', '')
      ..click();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  HomeBloc setBloc() => HomeBloc();

}
