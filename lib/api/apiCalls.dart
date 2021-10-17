import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:royal_advisor/customExceptions.dart';
import 'package:royal_advisor/models/questionListModel.dart';
import 'package:royal_advisor/models/questionModel.dart';

class ApiCalls {
  Future fetchQuestionList() async {
    final url =
        Uri.parse("https://royal-advisor-api.herokuapp.com/question/all");
    late final response;
    try {
      response = await http.get(url);
    } on SocketException catch (e) {
      print(e);
      return NoInternetException('No Internet Exception');
    } catch (e) {
      print(e);
      return NoServerResponseException(
          'Time Out', 'Unable to connect to server, please try again later');
    }
    print('fetch questions list');
    if (response.statusCode == 200) {
      // print(response.body);
      final parsed = json.decode(response.body) as Map<String, dynamic>;
      // print(parsed);
      if (parsed["questions"] == null) {
        return FOFNotFoundException(
            '404 Not Found', 'Resource does not exist on server');
      }
      try {
        var temp = parsed["questions"]
            .map<QuestionListItem>((json) => QuestionListItem.fromJson(json))
            .toList();
        // print(temp);
        print('end fetch questions list');
        return temp;
      } catch (e) {
        print(e);
        return JsonCastingException(
            'Error', 'Internal App Error, please try again later');
      }
    } else {
      print(response);
      String message = 'Some error occurred';

      try {
        if (response.body != null) {
          final parsed = json.decode(response.body) as Map<String, dynamic>;
          if (parsed["message"] != null) {
            message = parsed["message"].toString();
          }
        }
      } catch (e) {
        print(e);
      }

      return GeneralServerException(
          "Error Code ${response.statusCode}", message);
    }
  }

  Future fetchQuestion(String id) async {
    final url = Uri.parse(
        "https://royal-advisor-api.herokuapp.com/question/single/${id}");
    late final response;
    try {
      response = await http.get(url);
    } on SocketException catch (e) {
      print(e);
      return NoInternetException('No Internet Exception');
    } catch (e) {
      print(e);
      return NoServerResponseException(
          'Time Out', 'Unable to connect to server, please try again later');
    }
    print('fetch question');
    if (response.statusCode == 200) {
      // print(response.body);
      final parsed = json.decode(response.body) as Map<String, dynamic>;
      // print(parsed);
      if (parsed["question"] == null) {
        return FOFNotFoundException(
            '404 Not Found', 'Resource does not exist on server');
      }
      try {
        var temp = Question.fromJson(parsed['question']);
        // print(temp);
        print('end fetch question');
        return temp;
      } catch (e) {
        print(e);
        return JsonCastingException(
            'Error', 'Internal App Error, please try again later');
      }
    } else {
      print('no 200 status');
      print(response.body);
      String message = 'Some error occurred';

      try {
        if (response.body != null) {
          final parsed = json.decode(response.body) as Map<String, dynamic>;
          if (parsed["message"] != null) {
            message = parsed["message"].toString();
          }
        }
      } catch (e) {
        print(e);
      }

      return GeneralServerException(
          "Error Code ${response.statusCode}", message);
    }
  }
}
