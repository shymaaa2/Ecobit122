class FeedbackValidators {
  static String? validateQuestion(double? value){
    if(value == 0){
      return 'Please fill in all fields';
    }
    return null;
  }

  static String? validateRating(Map<String, dynamic> data){
    if(data.isEmpty){
      return "No data to store";
    }
    else if (data.values.isEmpty){
      return "No data to store";
    }
    return null;
  }
}