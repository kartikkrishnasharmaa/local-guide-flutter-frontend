import 'package:cached_network_image/cached_network_image.dart';

import '../../common_libs.dart';

class ViewImage extends StatelessWidget {

  String imageUrl;
  ViewImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Hero(
        tag: "profile",
          child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover,)),
    );
  }
}
