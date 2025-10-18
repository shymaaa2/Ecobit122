class Photo {
  String? key;
  PhotoData? photoData;

  Photo({this.key, this.photoData});
}

class PhotoData{
  String? uid;
  String? img;
  String? status;
  String? note;
  String? dateTaken;

  PhotoData({this.uid, this.img, this.status, this.note, this.dateTaken});

  PhotoData.fromJson(Map<dynamic, dynamic> json)
      : uid = json['uid'] as String?,
        img = json['img'] as String?,
        status = json['status'] as String?,
        note = json['note'] as String?,
        dateTaken = json['dateTaken'] as String?;

        
}