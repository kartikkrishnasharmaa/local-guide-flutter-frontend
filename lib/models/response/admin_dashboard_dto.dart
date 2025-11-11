import 'package:localguider/models/serializable.dart';

class AdminDashboardDto extends Serializable {
  AdminDashboardDto({
      this.totalUsers, 
      this.totalPlaces, 
      this.totalGuiders, 
      this.totalPhotographers,
      this.totalTransactions,
      this.pendingWithdrawals,});

  AdminDashboardDto.fromJson(dynamic json) {
    totalUsers = json['totalUsers'];
    totalPlaces = json['totalPlaces'];
    totalGuiders = json['totalGuiders'];
    totalTransactions = json['totalTransactions'];
    totalPhotographers = json['totalPhotographers'];
    pendingWithdrawals = json['pendingWithdrawals'];
  }
  num? totalUsers;
  num? totalPlaces;
  num? totalGuiders;
  num? totalTransactions;
  num? totalPhotographers;
  num? pendingWithdrawals;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalUsers'] = totalUsers;
    map['totalPlaces'] = totalPlaces;
    map['totalGuiders'] = totalGuiders;
    map['totalTransactions'] = totalTransactions;
    map['totalPhotographers'] = totalPhotographers;
    map['pendingWithdrawals'] = pendingWithdrawals;
    return map;
  }

}