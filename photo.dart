class Photo {
  String? key;
  PhotoData? photoData;

  Photo({this.key, this.photoData});
}

class PhotoData{
  String? email;
  String? imagePath;
  String? result;
  DateTime? dateTaken;
  String? note;

  PhotoData({this.email, this.imagePath, this.result, this.dateTaken, this.note});

  PhotoData.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        imagePath = json['image'],
        result = json['result'],
        dateTaken = json['dateTaken'],
        note = json['note'];
}