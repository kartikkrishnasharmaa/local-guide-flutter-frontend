
import '../../common_libs.dart';
import '../../main.dart';
import '../style/colors.dart';

appDatePicker(
    {context,
    DateTime? initialDateTime,
    DateTime? firstDate,
    DateTime? lastDate,
    required String title,
    required Function(DateTime?) onPick}) {
  showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1930),
      lastDate: lastDate ?? DateTime.now(),
      helpText: title,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: $styles.colors.accent2, // header background color
              onPrimary: $styles.colors.black, // header text color
              onSurface: $styles.colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: $styles.colors.title, // button text color
              ),
            ),
          ),
          child: child!,
        );
      }).then((pickedDate) async {
    onPick(pickedDate);
  });
}
