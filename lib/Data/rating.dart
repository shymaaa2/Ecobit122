class Rating {
  String? key;
  RatingData? ratingData;

  Rating({this.key, this.ratingData});
}

class RatingData{
  String? uid;
  double? q1;
  double? q2;
  double? q3;
  double? q4;

  RatingData({this.uid, this.q1, this.q2, this.q3, this.q4});

  RatingData.fromJson(Map<dynamic, dynamic> json)
      : uid = json['uid'] as String?,
        q1 = json['q1'] as double?,
        q2 = json['q2'] as double?,
        q3 = json['q3'] as double?,
        q4 = json['q4'] as double?;
}