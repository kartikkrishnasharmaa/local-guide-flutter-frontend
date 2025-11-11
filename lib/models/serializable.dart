abstract class Serializable {
  Map<String, dynamic> toJson();
}

class NoParamObj extends Serializable {

  @override
  Map<String, dynamic> toJson() {
     return {};
  }

  NoParamObj.fromJson(Map<String, dynamic> json);

}