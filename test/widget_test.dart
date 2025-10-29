import 'package:eco/feedback_validators.dart';
import 'package:eco/report_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feedback Validator', () {
    // For ratings stored to database
    test('Validate if no data is passed', (){
      // False Case
      expect(
        FeedbackValidators.validateRating({}),
        'No data to store',
      );
    });
     test('Validate if data is passed', (){
      // Successful Case
      expect(
        FeedbackValidators.validateRating({'uid':'11','q1':1,'q2':1,'q3':1,'q4':1,'dateTaken':DateTime.now(),}),
        null,
      );
    });
  });

  group('Reports Validator', () {
    // For Reports fetched from database
    test('Validate if reports are not retrieved', (){
      // False Case
      expect(
        ReportValidators.validateEmptyReports([]),
        'No data found.',
      );
    });
     test('Validate if reports are retrieved', (){
      // Successful Case
      expect(
        ReportValidators.validateEmptyReports([{'email':'nahar@gmail.com', 'logTime': DateTime.now()}]),
        null,
      );
    });

  
    test('Validate if data retrieved is of incorrect type', (){
      // Successful Case
      expect(
        ReportValidators.validateReports([1,1,1].cast<int>()),
        'Incorrect Data',
      );
    });

     test('Validate if data retrieved is of correct type', (){
      // Successful Case
      expect(
        ReportValidators.validateReports([{'email':'nahar@gmail.com', 'logTime': DateTime.now()}]),
        null,
      );
    });
  });
}
