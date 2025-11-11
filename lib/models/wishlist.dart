
class Wishlist {
  int? id;
  String? title;
  String? subTitle;
  String? type;
  String? objectId;
  String? data;
  DateTime? date;
  String? image;

  Wishlist({this.id = 0, this.title, this.subTitle, this.type, this.objectId, this.date, this.data, this.image});

  Wishlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['subTitle'];
    type = json['type'];
    objectId = json['objectId'];
    data = json['data'];
    image = json['image'];
    date = DateTime.parse(json['date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['type'] = type;
    data['objectId'] = objectId;
    data['data'] = this.data;
    data['image'] = image;
    data['date'] = date.toString();
    return data;
  }

}