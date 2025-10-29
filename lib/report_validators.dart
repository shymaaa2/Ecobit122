class ReportValidators {
  static String? validateEmptyReports(List<dynamic>? value){
    if(value!.isEmpty){
      return 'No data found.';
    }
    return null;
  }

  static String? validateReports(List<dynamic>? value){
    if(value is List<int> || value is List<double> || value is List<String>){
      return "Incorrect Data";
    }
    return null;
  }
}