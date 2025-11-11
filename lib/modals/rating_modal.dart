import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/components/input_field.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/utils/extensions.dart';

import '../common_libs.dart';
import '../components/custom_text.dart';
import '../main.dart';
import '../style/styles.dart';

class RatingModal extends StatefulWidget {
  Function(double, String) callback;
  double rating;

  RatingModal({super.key, required this.rating, required this.callback});

  @override
  State<RatingModal> createState() => _RatingModalState();
}

class _RatingModalState extends State<RatingModal> {
  final TextEditingController _messageController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: $styles.colors.white,
          borderRadius: BorderRadius.circular(
              sizing($appUtils.defaultCornerRadius, context))),
      padding: EdgeInsets.all(sizing(20, context)),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Give a review",
              style: FontStyles.medium,
              color: $styles.colors.black,
              fontSize: sizing(20, context),
            ),
            gap(context, height: 10),
            RatingBar.builder(
              initialRating: widget.rating,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: sizing(50, context),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                widget.rating = rating;
              },
            ),
            gap(context, height: 20),
            InputField(
                hint: "Type a message...",
                minLines: 5,
                maxLines: 20,
                enabledStrokeColor: $styles.colors.red.withOpacity(.1),
                focusStrokeColor: $styles.colors.red.withOpacity(.1),
                validator: (text) {
                  if (text.isNullOrEmpty()) {
                    return "Please type a message";
                  }
                  return null;
                },
                bgColor: $styles.colors.red.withOpacity(.1),
                controller: _messageController),
            gap(context, height: 20),
            DefaultButton($strings.submit, onClick: () {
              if (_formKey.currentState!.validate()) {
                navigatePop(context);
                widget.callback(widget.rating, _messageController.text);
              }
            })
          ],
        ),
      ),
    );
  }
}
