class Rating {
  String? key;
  RatingData? ratingData;

  Rating({this.key, this.ratingData});
}

class RatingData{
  String? uid;
  int? q1;
  int? q2;
  int? q3;
  int? q4;

  RatingData({this.uid, this.q1, this.q2, this.q3, this.q4});

  RatingData.fromJson(Map<dynamic, dynamic> json)
      : uid = json['uid'] as String?,
        q1 = json['q1'] as int?,
        q2 = json['q2'] as int?,
        q3 = json['q3'] as int?,
        q4 = json['q4'] as int?;
}