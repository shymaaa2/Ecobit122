import "package:firebase_database/firebase_database.dart";
import 'photo.dart';
import 'log.dart';
import 'user.dart';
import 'rating.dart';

class DatabaseService {
  final DatabaseReference db = FirebaseDatabase.instance.ref();
  
  // --------------- User-related Methods ----------------------

  // Adding Registered user to database
  Future<void> addUser(Map<String, dynamic> userData) async{
    await db.child('Users').push().set(userData);
  }

  // Saving Login logs
  Future<void> logUser(Map<String, dynamic> logData) async{
    await db.child('Logs').push().set(logData);
  }

  // Saving Photos
  Future<void> addPhoto(Map<String, dynamic> photoData) async{
    await db.child('Photos').push().set(photoData);
  }

  // Retrieving scanned fruit using user id
  static void getPhotos(Function(List<Photo>) photosCallback, String uid) {
    FirebaseDatabase.instance.ref().child("Photos").onValue
        .listen((photoDataSnapshot) {
      if (photoDataSnapshot.snapshot.exists) {
        List<Photo> photos = [];
        for (var element in photoDataSnapshot.snapshot.children) {
          if(element.child('uid').value == uid){
          PhotoData photoData = PhotoData.fromJson(element.value as Map);
          Photo photo = Photo(key: element.key, photoData: photoData);
          photos.add(photo);
          }
          photosCallback(photos);
        }
      } else {
        print("No data found!");
      }
    });
  }
  
  // Saving ratings
  Future<void> addRating(Map<String, dynamic> ratingData) async{
    await db.child('Ratings').push().set(ratingData);
  }

    // --------------- Admin-related Methods ----------------------

  // Retrieving logs
  static void getLogs(Function(List<Log>) logsCallback) {
    FirebaseDatabase.instance.ref().child("Logs").onValue
        .listen((logDataSnapshot) {
      if (logDataSnapshot.snapshot.exists) {
        List<Log> logs = [];
        for (var element in logDataSnapshot.snapshot.children) {
          LogData logData = LogData.fromJson(element.value as Map);
          Log log = Log(key: element.key, logData: logData);
          logs.add(log);
          }
          logsCallback(logs);
        }
      }
      );
    }

    // Retrieving users
    static void getUsers(Function(List<User>) usersCallback) {
      FirebaseDatabase.instance.ref().child("Users").onValue
          .listen((usersDataSnapshot) {
        if (usersDataSnapshot.snapshot.exists) {
          List<User> users = [];
          for (var element in usersDataSnapshot.snapshot.children) {
            UserData userData = UserData.fromJson(element.value as Map);
            User user = User(key: element.key, userData: userData);
            users.add(user);
            }
            usersCallback(users);
          }
        }
        );
      }

    // Retrieving ratings
    static void getRatings(Function(List<Rating>) ratingsCallback) {
      FirebaseDatabase.instance.ref().child("Ratings").onValue
          .listen((ratingsDataSnapshot) {
        if (ratingsDataSnapshot.snapshot.exists) {
          List<Rating> ratings = [];
          for (var element in ratingsDataSnapshot.snapshot.children) {
            RatingData ratingData = RatingData.fromJson(element.value as Map);
            Rating rating = Rating(key: element.key, ratingData: ratingData);
            ratings.add(rating);
            }
            ratingsCallback(ratings);
          }
        }
        );
      }
    
}

