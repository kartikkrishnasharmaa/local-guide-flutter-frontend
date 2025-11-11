class BaseCallback<D extends dynamic> {
  String? message;
  String? other;
  bool? success;
  bool? isFieldError;
  D? data;

  BaseCallback({
    this.message,
    this.other,
    this.success,
    this.isFieldError,
    this.data,
  });
}

class BaseListCallback<T extends dynamic> {
  String? message;
  String? other;
  bool? success;
  bool? canGiveReview;
  bool? isFieldError;
  List<T>? data;

  BaseListCallback({
    this.message,
    this.other,
    this.success,
    this.canGiveReview,
    this.isFieldError,
    this.data,
  });

}