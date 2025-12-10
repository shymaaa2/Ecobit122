class Photo {
  String? key;
  PhotoData? photoData;

  Photo({this.key, this.photoData});
}

class PhotoData{
  String? email;
  String? img;
  String? status;
  String? note;
  String? dateTaken;

  PhotoData({this.email, this.img, this.status, this.note, this.dateTaken});

  PhotoData.fromJson(Map<dynamic, dynamic> json)
      : email = json['email'] as String?,
        img = json['img'] as String?,
        status = json['status'] as String?,
        note = json['note'] as String?,
        dateTaken = json['dateTaken'] as String?;

        
}