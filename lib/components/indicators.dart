
import 'package:flutter/material.dart';

Center circularProgress(context) {
  return Center(
    child: CircularProgressIndicator(
      color: Theme.of(context).colorScheme.secondary,
    ),
  );
}

Container linearProgress(context) {
  return Container(
    child: LinearProgressIndicator(
      valueColor:
          AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
    ),
  );
}
